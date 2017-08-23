#import <XCTest/XCTest.h>
#import "StoreKit.h"
#import "SKPaymentTransaction+Internal.h"
#import "Nocilla.h"

@interface SKPaymentQueue (Test)
- (void)addTransactionForTest:(SKPaymentTransaction *)transaction;
@end

@interface SKPaymentQueueDelegate : NSObject<SKPaymentTransactionObserver>
@property XCTestExpectation *purchasingExpectation;
@property XCTestExpectation *purchasedExpectation;
@property XCTestExpectation *failedExpectation;
@property XCTestExpectation *removedExpectation;
@property NSArray<SKPaymentTransaction *> *transactions;
@end

@implementation SKPaymentQueueDelegate

// Handing Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    _transactions = [transactions copy];
    for(SKPaymentTransaction *transaction in transactions) {
        switch(transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                [_purchasingExpectation fulfill];
                break;
            case SKPaymentTransactionStatePurchased:
                [_purchasedExpectation fulfill];
                break;
            case SKPaymentTransactionStateFailed:
                [_failedExpectation fulfill];
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    [_removedExpectation fulfill];
}

// Handling Restored Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
//    [_expectation fulfill];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
//    [_expectation fulfill];
}

// Handling Download Actions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads
{
//    [_expectation fulfill];
}

@end

@interface SKPaymentQueueTests : XCTestCase
@end

@implementation SKPaymentQueueTests

+ (void)setUp
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"transactions.db"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
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

- (void)testCanMakePayments {
    // Now canMakePayments always returns YES
    XCTAssertTrue([SKPaymentQueue canMakePayments]);
}

- (void)testDefaultQueue {
    SKPaymentQueue *queue1 = [SKPaymentQueue defaultQueue];
    XCTAssertNotNil(queue1);
    SKPaymentQueue *queue2 = [SKPaymentQueue defaultQueue];
    XCTAssertEqualObjects(queue1, queue2);
}

- (void)testAddAndRemoveTransactionObserver {
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];

    SKPaymentQueueDelegate *observer1 = [[SKPaymentQueueDelegate alloc] init];
    SKPaymentQueueDelegate *observer2 = [[SKPaymentQueueDelegate alloc] init];

    [queue addTransactionObserver:observer1];
    [queue addTransactionObserver:observer2];

    [queue removeTransactionObserver:observer1];
    [queue removeTransactionObserver:observer2];
}

- (void)testConnectToPaymentAPI {
    NSString *requestId = [NSUUID UUID].UUIDString.lowercaseString;

    stubRequest(@"POST", @"https://api.tombo.io/payments").
    withBody([NSString stringWithFormat:@"{\"payment\":{\"quantity\":1,\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\",\"requestId\":\"%@\"},\"user_jwt\":\"dummy_jwt\"}", requestId]).
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:
              @{
                @"data": @{
                        @"type": @"payments",
                        @"id": @"transactionIdentifier1",
                        @"attributes": @{
                                @"request_id": requestId,
                                @"product_identifier": @"product1",
                                @"quantity": @"1",
                                @"application_username": [NSNull null],
                                @"status": @"2",
                                @"created_at": @"1980-03-17T05:58:17.000+09:00",
                                @"updated_at": @"1980-03-17T05:58:17.000+09:00",
                                },
                        }
                } options:NSJSONWritingPrettyPrinted error:nil]);

    SKPaymentQueueDelegate *delegate = [[SKPaymentQueueDelegate alloc] init];
    delegate.purchasingExpectation = [self expectationWithDescription:@"purchasing"];
    delegate.purchasedExpectation = [self expectationWithDescription:@"purchased"];
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
    [queue addTransactionObserver:delegate];

    SKProduct *product = [[SKProduct alloc] initWithProductIdentifier:@"product1" localizedTitle:@"title" localizedDescription:@"desc" price:[[NSDecimalNumber alloc] initWithInt:101] priceLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction.requestId = requestId;


    [queue addTransactionForTest:transaction];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }

        NSArray<SKPaymentTransaction *> *transactions = delegate.transactions;

        XCTAssertEqual(transactions.count, 1);

        XCTAssertEqualObjects(transactions[0].transactionIdentifier, @"transactionIdentifier1");
        XCTAssertEqual(transactions[0].transactionDate.timeIntervalSince1970, 322088297);

        for (SKPaymentTransaction *transaction in transactions) {
            [queue finishTransaction:transaction];
        }
        [queue removeTransactionObserver:delegate];
    }];
}

- (void)testConnectToPaymentAPIOnError {
    NSString *requestId = [NSUUID UUID].UUIDString.lowercaseString;
    
    stubRequest(@"POST", @"https://api.tombo.io/payments").
    withBody([NSString stringWithFormat:@"{\"payment\":{\"quantity\":1,\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\",\"requestId\":\"%@\"},\"user_jwt\":\"dummy_jwt\"}", requestId]).
    andReturn(400).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:
              @{
                @"errors": @[
                        @{
                            @"detail" : @"errordetail"

                            }
                        ]
                } options:NSJSONWritingPrettyPrinted error:nil]);

    SKPaymentQueueDelegate *delegate = [[SKPaymentQueueDelegate alloc] init];
    delegate.purchasingExpectation = [self expectationWithDescription:@"purchasing"];
    delegate.failedExpectation = [self expectationWithDescription:@"failed"];
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
    [queue addTransactionObserver:delegate];

    SKProduct *product = [[SKProduct alloc] initWithProductIdentifier:@"product1" localizedTitle:@"title" localizedDescription:@"desc" price:[[NSDecimalNumber alloc] initWithInt:101] priceLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction.requestId = requestId;

    [queue addTransactionForTest:transaction];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }

        NSArray<SKPaymentTransaction *> *transactions = delegate.transactions;

        XCTAssertEqual(transactions.count, 1);

        SKPaymentTransaction *result = transactions[0];

        XCTAssertNil(result.transactionIdentifier);
        XCTAssertNil(result.transactionDate);
        XCTAssertNotNil(result.error);
        XCTAssertEqualObjects(result.error.domain, SKServerErrorDomain);
        XCTAssertEqualObjects(result.error.userInfo[NSLocalizedDescriptionKey], @"errordetail");

        for (SKPaymentTransaction *transaction in transactions) {
            [queue finishTransaction:transaction];
        }
        [queue removeTransactionObserver:delegate];
    }];
}

@end
