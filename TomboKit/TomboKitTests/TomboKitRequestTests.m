#import <XCTest/XCTest.h>
#import "Nocilla.h"
#import "TomboKit.h"

@interface TomboKitProductsRequestTests : XCTestCase {
    XCTestExpectation *_expectationDidFinish;
    NSError *_error;
}
@end

@interface TomboKitReceiptRefreshRequestTests : XCTestCase
@end

@implementation TomboKitProductsRequestTests

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
    NSArray* identifiers = @[@"productIdentifier1", @"productIdentifier2"];

    stubRequest(@"GET", @"https://api.tombo.io/products?product_identifiers=productIdentifier1%2CproductIdentifier2&user_jwt=dummy_jwt").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:@{
        @"data": @[
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
    } options:NSJSONWritingPrettyPrinted error:nil]);

    _expectationDidFinish = [self expectationWithDescription:@"TomboKitProductRequestDelegate requestDidFinish"];

    TomboKitAPI *api = [[TomboKitAPI alloc] init];

    __block NSArray <NSDictionary*> *products = nil;
    __block NSError *apiError = nil;

    [api getProducts:identifiers success:^(NSArray *data) {
        products = data;
        [_expectationDidFinish fulfill];
    } failure:^(NSError *error) {
        apiError = error;
        [_expectationDidFinish fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }

        XCTAssertEqualObjects(products[0][@"productIdentifier"], @"productIdentifier1");
        XCTAssertEqualObjects(products[0][@"localizedTitle"], @"product 1");
        XCTAssertEqualObjects(products[0][@"localizedDescription"], @"description of product 1");
        XCTAssertEqualObjects(products[0][@"price"], @"101");
        XCTAssertEqualObjects(products[0][@"priceLocale"], @"ja_JP");

        XCTAssertEqualObjects(products[1][@"productIdentifier"], @"productIdentifier2");
        XCTAssertEqualObjects(products[1][@"localizedTitle"], @"product 2");
        XCTAssertEqualObjects(products[1][@"localizedDescription"], @"description of product 2");
        XCTAssertEqualObjects(products[1][@"price"], @"102");
        XCTAssertEqualObjects(products[1][@"priceLocale"], @"en_US");
    }];
}

@end

@implementation TomboKitReceiptRefreshRequestTests
// FIXME: implement
@end
