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
    withBody(@"{\"user_jwt\":\"dummy_jwt\",\"payments\":[{\"quantity\":1,\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\",\"requestId\":\"reguest1\"}]}").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:
        @{
            @"data": @[
                @{
                    @"attributes": @{
                        @"request_id": @"request1",
                        @"transaction_id": @"transactionIdentifier1",
                        @"product_identifier": @"product1",
                        @"quantity": @"1",
                        @"application_username": @2, // charge_complete
                        @"status": @"1",
                        @"created_at": @"1980-03-17T05:58:17+09:00",
                        @"updated_at": @"1980-03-17T05:58:17+09:00",
                    },
                },
            ]
        }
        options:NSJSONWritingPrettyPrinted error:nil]);

    _expectation = [self expectationWithDescription:@"TomboKitPaymentTransactionObserver"];

    NSString* identifier = @"product1";
    int quantity = 1;
    NSString* applicationUsername = nil;
    NSString* requestId = @"reguest1";

    TomboKitAPI *api = [[TomboKitAPI alloc] init];

    __block NSArray<NSDictionary*>* transactions = nil;
    __block NSError* apiError = nil;

    [api postPayments:identifier quantity:quantity requestData:nil applicationUsername:applicationUsername requestId:requestId success:^(NSArray *data) {
        transactions = data;
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

        NSLog(@"%s %@", __FUNCTION__, transactions);

        NSDictionary *transaction = transactions[0];
        XCTAssertEqualObjects(transaction[@"attributes"][@"request_id"], @"request1");
    }];
}

- (void)testConnectToPaymentAPIWithAPIError {
    stubRequest(@"POST", @"https://api.tombo.io/payments").
    withBody(@"{\"user_jwt\":\"dummy_jwt\",\"payments\":[{\"quantity\":1,\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\",\"requestId\":\"reguest1\"}]}").
    andReturn(401).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:
        @{
            @"errors": @[
                @"hogehoge",
            ]
        }
                                             options:NSJSONWritingPrettyPrinted error:nil]);

    _expectation = [self expectationWithDescription:@"TomboKitPaymentTransactionObserver"];

    NSString* identifier = @"product1";
    int quantity = 1;
    NSString* applicationUsername = nil;
    NSString* requestId = @"reguest1";

    TomboKitAPI *api = [[TomboKitAPI alloc] init];

    __block NSArray<NSDictionary*>* transactions = nil;
    __block NSError* apiError = nil;

    [api postPayments:identifier quantity:quantity requestData:nil applicationUsername:applicationUsername requestId:requestId success:^(NSArray *data) {
        transactions = data;
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

        XCTAssertNotNil(apiError);
        XCTAssertEqualObjects(apiError.domain, TomboKitErrorDomain);
        XCTAssertEqualObjects(apiError.localizedDescription, @"hogehoge");

        XCTAssertNil(transactions);
    }];
}

- (void)testConnectToPaymentAPIWithNetworkError {
    stubRequest(@"POST", @"https://api.tombo.io/payments").
    withBody(@"{\"user_jwt\":\"dummy_jwt\",\"payments\":[{\"quantity\":1,\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\",\"requestId\":\"reguest1\"}]}").
    andFailWithError([NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:nil]);

    _expectation = [self expectationWithDescription:@"TomboKitPaymentTransactionObserver"];

    NSString* identifier = @"product1";
    int quantity = 1;
    NSString* applicationUsername = nil;
    NSString* requestId = @"reguest1";

    TomboKitAPI *api = [[TomboKitAPI alloc] init];

    __block NSArray<NSDictionary*>* transactions = nil;
    __block NSError* apiError = nil;

    [api postPayments:identifier quantity:quantity requestData:nil applicationUsername:applicationUsername requestId:requestId success:^(NSArray *data) {
        transactions = data;
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

        XCTAssertNotNil(apiError);
        XCTAssertEqualObjects(apiError.domain, NSURLErrorDomain);
        
        XCTAssertNil(transactions);
    }];
}

@end
