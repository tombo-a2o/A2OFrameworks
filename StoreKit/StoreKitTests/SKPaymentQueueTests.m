#import <XCTest/XCTest.h>
#import "StoreKit.h"
#import "SKPaymentTransaction+Internal.h"
#import "Nocilla.h"

@interface SKPaymentQueue (Test)
- (void)postPaymentTransaction:(SKPaymentTransaction *)transaction completionHandler:(void (^)(void))completionHandler;
@end

@interface SKPaymentQueueDelegate : NSObject<SKPaymentTransactionObserver>
+(instancetype)delegateWithExpectation:(XCTestExpectation*)expectation;
@property NSArray<SKPaymentTransaction *> *transactions;
@end

@implementation SKPaymentQueueDelegate {
    XCTestExpectation *_expectation;
}

+(instancetype)delegateWithExpectation:(XCTestExpectation*)expectation
{
    SKPaymentQueueDelegate *delegate = [[SKPaymentQueueDelegate alloc] init];
    delegate->_expectation = expectation;
    return delegate;
}

#pragma mark - SKPaymentTransactionObserver

// Handing Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    _transactions = [transactions copy];
    [_expectation fulfill];
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
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
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads
{
    [_expectation fulfill];
}

@end

@interface SKPaymentQueueTests : XCTestCase
@end

@implementation SKPaymentQueueTests

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
    stubRequest(@"POST", @"https://api.tombo.io/payments").
    withBody(@"{\"payment\":{\"quantity\":1,\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\",\"requestId\":\"request1\"},\"user_jwt\":\"dummy_jwt\"}").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:
              @{
                @"data": @{
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
                        }
                } options:NSJSONWritingPrettyPrinted error:nil]);

    stubRequest(@"PATCH", @"https://api.tombo.io/payments/transactionIdentifier1").
    withBody(@"{\"user_jwt\":\"dummy_jwt\"}").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:
              @{
                @"data": @{
                        @"type": @"payments",
                        @"id": @"transactionIdentifier1",
                        @"attributes": @{
                                @"request_id": @"request1",
                                @"product_identifier": @"product1",
                                @"quantity": @"1",
                                @"application_username": [NSNull null],
                                @"status": @"3",
                                @"created_at": @"1980-03-17T05:58:17.000+09:00",
                                @"updated_at": @"1980-03-17T05:58:17.000+09:00",
                                },
                        }
                } options:NSJSONWritingPrettyPrinted error:nil]);

    SKPaymentQueueDelegate *delegate = [SKPaymentQueueDelegate delegateWithExpectation:[self expectationWithDescription:@"SKPaymentTransactionObserver"]];
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
    [queue addTransactionObserver:delegate];

    SKProduct *product = [[SKProduct alloc] initWithProductIdentifier:@"product1" localizedTitle:@"title" localizedDescription:@"desc" price:[[NSDecimalNumber alloc] initWithInt:101] priceLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction.requestId = @"request1";


    [queue postPaymentTransaction:transaction completionHandler:nil];

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
    stubRequest(@"POST", @"https://api.tombo.io/payments").
    withBody(@"{\"payment\":{\"quantity\":1,\"requestData\":null,\"applicationUsername\":null,\"productIdentifier\":\"product1\",\"requestId\":\"request1\"},\"user_jwt\":\"dummy_jwt\"}").
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

    SKPaymentQueueDelegate *delegate = [SKPaymentQueueDelegate delegateWithExpectation:[self expectationWithDescription:@"SKPaymentTransactionObserver2"]];
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
    [queue addTransactionObserver:delegate];

    SKProduct *product = [[SKProduct alloc] initWithProductIdentifier:@"product1" localizedTitle:@"title" localizedDescription:@"desc" price:[[NSDecimalNumber alloc] initWithInt:101] priceLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction.requestId = @"request1";

    [queue postPaymentTransaction:transaction completionHandler:nil];

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
