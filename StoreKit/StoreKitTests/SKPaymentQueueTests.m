#import <XCTest/XCTest.h>
#import "StoreKit.h"
#import "SKPaymentTransaction+Internal.h"
#import "Nocilla.h"

@interface SKPaymentQueue (Test)
- (void)postPaymentTransaction:(SKPaymentTransaction *)transaction completionHandler:(void (^)(void))completionHandler;
@end

@interface SKPaymentQueueTests : XCTestCase <SKPaymentTransactionObserver>

@end

@implementation SKPaymentQueueTests {
    XCTestExpectation *_expectation;
    NSArray<SKPaymentTransaction *> *_transactions;
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

    SKPaymentQueueTests *observer1 = [[SKPaymentQueueTests alloc] init];
    SKPaymentQueueTests *observer2 = [[SKPaymentQueueTests alloc] init];

    [queue addTransactionObserver:observer1];
    [queue addTransactionObserver:observer2];

    [queue removeTransactionObserver:observer1];
    [queue removeTransactionObserver:observer2];
}

- (void)testConnectToPaymentAPI {
    stubRequest(@"POST", @"https://api.tombo.io/payments").
    withBody(@"{\"payment\":{\"quantity\":1,\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\",\"requestId\":\"request1\"},\"user_jwt\":\"dummy_jwt\"}").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:
              @{
                @"data": @[
                        @{
                            @"type": @"payments",
                            @"id": @"transactionIdentifier1",
                            @"attributes": @{
                                    @"request_id": @"request1",
                                    @"product_identifier": @"product1",
                                    @"quantity": @"1",
                                    @"application_username": [NSNull null],
                                    @"status": @"2",
                                    @"created_at": @"1980-03-17T05:58:17.000+09:00",
                                    @"updated_at": @"1980-03-17T05:58:17.000+09:00",
                                    },
                            },
                        ]
                } options:NSJSONWritingPrettyPrinted error:nil]);
    
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
    [queue addTransactionObserver:self];

    SKProduct *product = [[SKProduct alloc] initWithProductIdentifier:@"product1" localizedTitle:@"title" localizedDescription:@"desc" price:[[NSDecimalNumber alloc] initWithInt:101] priceLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction.requestId = @"request1";

    _expectation = [self expectationWithDescription:@"SKPaymentTransactionObserver"];

    [queue postPaymentTransaction:transaction completionHandler:nil];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }
        
        XCTAssertEqual(_transactions.count, 1);

        XCTAssertEqualObjects(_transactions[0].transactionIdentifier, @"transactionIdentifier1");
        XCTAssertEqual(_transactions[0].transactionDate.timeIntervalSince1970, 322088297);

        for (SKPaymentTransaction *transaction in _transactions) {
            [queue finishTransaction:transaction];
        }
    }];
}

#pragma mark - SKPaymentTransactionObserver

// Handing Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray/*<SKPaymentTransaction *>*/ *)transactions
{
    _transactions = [transactions copy];
    [_expectation fulfill];
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray/*<SKPaymentTransaction *>*/ *)transactions
{
    [_expectation fulfill];
}

// Handling Restored Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [_expectation fulfill];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [_expectation fulfill];
}

// Handling Download Actions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray/*<SKDownload *>*/ *)downloads
{
    [_expectation fulfill];
}

@end
