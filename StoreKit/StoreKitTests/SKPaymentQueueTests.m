#import <XCTest/XCTest.h>
#import "StoreKit.h"

@interface SKPaymentQueueTests : XCTestCase <SKPaymentTransactionObserver>

@end

@implementation SKPaymentQueueTests {
    XCTestExpectation *_expectation;
    NSArray<SKPaymentTransaction *> *_transactions;
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
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
    [queue addTransactionObserver:self];

    SKProduct *product = [[SKProduct alloc] initWithProductIdentifier:@"product1" localizedTitle:@"title" localizedDescription:@"desc" price:[[NSDecimalNumber alloc] initWithInt:101] priceLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    SKPayment *payment = [SKPayment paymentWithProduct:product];

    _expectation = [self expectationWithDescription:@"SKPaymentTransactionObserver"];

    [queue connectToPaymentAPI:payment];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }

        XCTAssertEqualObjects(_transactions[0].transactionIdentifier, @"transactionIdentifier1");
        XCTAssertEqual(_transactions[0].transactionDate.timeIntervalSince1970, 322088297);
        XCTAssertEqualObjects(_transactions[1].transactionIdentifier, @"transactionIdentifier2");
        XCTAssertEqual(_transactions[1].transactionDate.timeIntervalSince1970, 1404206625);

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
