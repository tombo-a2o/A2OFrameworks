#import <XCTest/XCTest.h>
#import "StoreKit.h"
#import "Nocilla.h"

@interface SKProductsRequestTests : XCTestCase <SKProductsRequestDelegate> {
    XCTestExpectation *_expectationDidFinish;
    SKRequest *_request;
    SKProductsResponse *_response;
    NSError *_error;
}
@end

@interface SKReceiptRefreshRequestTests : XCTestCase
@end

@implementation SKProductsRequestTests

- (void)setUp
{
    [super setUp];
    [[LSNocilla sharedInstance] start];
}

- (void)tearDown
{
    [[LSNocilla sharedInstance] stop];
    [super tearDown];
}

- (void)testStart {
    stubRequest(@"GET", @"https://api.tombo.io/products?product_identifiers=productIdentifier1%2CproductIdentifier2&user_jwt=dummy_jwt").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:@{
                                                       @"data": @[
                                                               @{
                                                                   @"attributes": @{
                                                                           @"product_identifier": @"productIdentifier1",
                                                                           @"downloadable": @1,
                                                                           @"title": @"product 1",
                                                                           @"description": @"description of product 1",
                                                                           @"price": @"10100",
                                                                           @"currency": @"JPY",
                                                                           @"country": @"JP"
                                                                           },
                                                                   @"type": @"products",
                                                                   @"id": @"xxxxx"
                                                                   },
                                                               @{
                                                                   @"attributes": @{
                                                                           @"product_identifier": @"productIdentifier2",
                                                                           @"downloadable": @1,
                                                                           @"title": @"product 2",
                                                                           @"description": @"description of product 2",
                                                                           @"price": @"10200",
                                                                           @"currency": @"USD",
                                                                           @"country": @"US"
                                                                           },
                                                                   @"type": @"products",
                                                                   @"id": @"xxxxx"
                                                                   },
                                                               ]
                                                       } options:NSJSONWritingPrettyPrinted error:nil]);
    
    
    NSSet *set = [NSSet setWithObjects:@"productIdentifier1", @"productIdentifier2", nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;

    _expectationDidFinish = [self expectationWithDescription:@"SKProductRequestDelegate requestDidFinish"];

    [productsRequest start];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }
        
        XCTAssertNotNil(_response);

        NSArray <SKProduct *> *products = _response.products;

        XCTAssertEqualObjects(products[0].productIdentifier, @"productIdentifier1");
        XCTAssertEqualObjects(products[0].localizedTitle, @"product 1");
        XCTAssertEqualObjects(products[0].localizedDescription, @"description of product 1");
        XCTAssertEqualObjects(products[0].price, [[NSDecimalNumber alloc] initWithInt:101]);
        XCTAssertEqualObjects([products[0].priceLocale localeIdentifier], @"en_JP@currency=JPY");

        XCTAssertEqualObjects(products[1].productIdentifier, @"productIdentifier2");
        XCTAssertEqualObjects(products[1].localizedTitle, @"product 2");
        XCTAssertEqualObjects(products[1].localizedDescription, @"description of product 2");
        XCTAssertEqualObjects(products[1].price, [[NSDecimalNumber alloc] initWithInt:102]);
        XCTAssertEqualObjects([products[1].priceLocale localeIdentifier], @"en_US@currency=USD");
    }];
}

// FIXME: implement testCancel()

#pragma mark - SKProductsRequestDelegate

- (void)requestDidFinish:(SKRequest *)request
{
    _request = request;
    _error = nil;
    [_expectationDidFinish fulfill];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    _request = request;
    _error = error;
    [_expectationDidFinish fulfill];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    _response = response;
}

@end

@implementation SKReceiptRefreshRequestTests
// FIXME: implement
@end
