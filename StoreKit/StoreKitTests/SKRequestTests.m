#import <XCTest/XCTest.h>
#import "Nocilla.h"
#import "StoreKit.h"

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
    NSSet *set = [NSSet setWithObjects:@"productIdentifier1", @"productIdentifier2", nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;

    stubRequest(@"GET", [NSString stringWithFormat:@"%@?product_identifier=productIdentifier1%%2CproductIdentifier2", @"https://api.tombo.io/products"]).
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:@{
        @"data": @{
            @"products": @[
                @{
                    @"productIdentifier": @"productIdentifier1",
                    @"localizedTitle": @"product 1",
                    @"localizedDescription": @"description of product 1",
                    @"price": @"101",
                    @"priceLocale": @"ja_JP"
                },
                @{
                    @"productIdentifier": @"productIdentifier2",
                    @"localizedTitle": @"product 2",
                    @"localizedDescription": @"description of product 2",
                    @"price": @"102",
                    @"priceLocale": @"en_US"
                }
            ]
        }
    } options:NSJSONWritingPrettyPrinted error:nil]);

    _expectationDidFinish = [self expectationWithDescription:@"SKProductRequestDelegate requestDidFinish"];

    [productsRequest start];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }

        NSArray <SKProduct *> *products = _response.products;

        XCTAssertEqualObjects(products[0].productIdentifier, @"productIdentifier1");
        XCTAssertEqualObjects(products[0].localizedTitle, @"product 1");
        XCTAssertEqualObjects(products[0].localizedDescription, @"description of product 1");
        XCTAssertEqualObjects(products[0].price, [[NSDecimalNumber alloc] initWithInt:101]);
        XCTAssertEqualObjects([products[0].priceLocale localeIdentifier], @"ja_JP");

        XCTAssertEqualObjects(products[1].productIdentifier, @"productIdentifier2");
        XCTAssertEqualObjects(products[1].localizedTitle, @"product 2");
        XCTAssertEqualObjects(products[1].localizedDescription, @"description of product 2");
        XCTAssertEqualObjects(products[1].price, [[NSDecimalNumber alloc] initWithInt:102]);
        XCTAssertEqualObjects([products[1].priceLocale localeIdentifier], @"en_US");
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
