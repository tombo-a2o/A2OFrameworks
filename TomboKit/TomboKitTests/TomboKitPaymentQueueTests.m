#import <XCTest/XCTest.h>
#import "Nocilla.h"
#import "TomboKit.h"

@interface TomboKitPaymentQueueTests : XCTestCase <TomboKitPaymentTransactionObserver>

@end

@implementation TomboKitPaymentQueueTests {
    XCTestExpectation *_expectation;
    NSArray<TomboKitPaymentTransaction *> *_transactions;
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
    XCTAssertTrue([TomboKitPaymentQueue canMakePayments]);
}

- (void)testDefaultQueue {
    TomboKitPaymentQueue *queue1 = [TomboKitPaymentQueue defaultQueue];
    XCTAssertNotNil(queue1);
    TomboKitPaymentQueue *queue2 = [TomboKitPaymentQueue defaultQueue];
    XCTAssertEqualObjects(queue1, queue2);
}

- (void)testAddAndRemoveTransactionObserver {
    TomboKitPaymentQueue *queue = [TomboKitPaymentQueue defaultQueue];

    TomboKitPaymentQueueTests *observer1 = [[TomboKitPaymentQueueTests alloc] init];
    TomboKitPaymentQueueTests *observer2 = [[TomboKitPaymentQueueTests alloc] init];

    [queue addTransactionObserver:observer1];
    [queue addTransactionObserver:observer2];

    [queue removeTransactionObserver:observer1];
    [queue removeTransactionObserver:observer2];
}

- (void)testConnectToPaymentAPI {
    TomboKitPaymentQueue *queue = [TomboKitPaymentQueue defaultQueue];
    [queue addTransactionObserver:self];

    TomboKitProduct *product = [[TomboKitProduct alloc] initWithProductIdentifier:@"product1" localizedTitle:@"title" localizedDescription:@"desc" price:[[NSDecimalNumber alloc] initWithInt:101] priceLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    TomboKitPayment *payment = [TomboKitPayment paymentWithProduct:product];

    stubRequest(@"POST", TomboKitTomboPaymentsURL).
    withBody(@"{\"payments\":[{\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\",\"quantity\":1}]}").
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

        for (TomboKitPaymentTransaction *transaction in _transactions) {
            [queue finishTransaction:transaction];
        }
    }];
}

#pragma mark - TomboKitPaymentTransactionObserver

// Handing Transactions
- (void)paymentQueue:(TomboKitPaymentQueue *)queue updatedTransactions:(NSArray/*<TomboKitPaymentTransaction *>*/ *)transactions
{
    _transactions = [transactions copy];
    [_expectation fulfill];
}

- (void)paymentQueue:(TomboKitPaymentQueue *)queue removedTransactions:(NSArray/*<TomboKitPaymentTransaction *>*/ *)transactions
{
    [_expectation fulfill];
}

// Handling Restored Transactions
- (void)paymentQueue:(TomboKitPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [_expectation fulfill];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(TomboKitPaymentQueue *)queue
{
    [_expectation fulfill];
}

// Handling Download Actions
- (void)paymentQueue:(TomboKitPaymentQueue *)queue updatedDownloads:(NSArray/*<TomboKitDownload *>*/ *)downloads
{
    [_expectation fulfill];
}

@end