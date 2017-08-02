#import <XCTest/XCTest.h>
#import "Nocilla.h"
#import "TomboKit.h"

@interface TomboKitPaymentQueueTests : XCTestCase

@end

@implementation TomboKitPaymentQueueTests {
    XCTestExpectation *_expectation;
}

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

- (void)testConnectToPaymentAPI {
    stubRequest(@"POST", @"https://api.tombo.io/payments").
    withBody(@"{\"payments\":[{\"quantity\":1,\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\"}]}").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:
        @{
            @"data": @{
                @"transactions": @[
                    @{
                        @"transactionIdentifier": @"transactionIdentifier1",
                        @"transactionDate": @"1980-03-17T05:58:17+09:00",
                    },
                    @{
                        @"transactionIdentifier": @"transactionIdentifier2",
                        @"transactionDate": @"2014-07-01T01:23:45-08:00",
                    },
                ]
            }
        }
        options:NSJSONWritingPrettyPrinted error:nil]);

    _expectation = [self expectationWithDescription:@"TomboKitPaymentTransactionObserver"];

    NSString* identifier = @"product1";
    int quantity = 1;
    NSString* applicationUsername = nil;
    
    TomboKitAPI *api = [[TomboKitAPI alloc] init];
    
    __block NSArray<NSDictionary*>* transactions = nil;
    __block NSError* apiError = nil;
    
    [api postPayments:identifier quantity:quantity requestData:nil applicationUsername:applicationUsername success:^(NSDictionary *data) {
        transactions = data[@"transactions"];
        [_expectation fulfill];
    } failure:^(NSError *error) {
        apiError = error;
        [_expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }
        
        XCTAssertNil(apiError);
        XCTAssertEqualObjects(transactions[0][@"transactionIdentifier"], @"transactionIdentifier1");
        XCTAssertEqualObjects(transactions[0][@"transactionDate"], @"1980-03-17T05:58:17+09:00");
        XCTAssertEqualObjects(transactions[1][@"transactionIdentifier"], @"transactionIdentifier2");
        XCTAssertEqualObjects(transactions[1][@"transactionDate"], @"2014-07-01T01:23:45-08:00");
    }];
}

@end
