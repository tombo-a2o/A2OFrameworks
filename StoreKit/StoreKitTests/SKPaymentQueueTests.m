/*
 *  SKPaymentQueueTests.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <XCTest/XCTest.h>
#import "StoreKit.h"
#import "SKPaymentTransaction+Internal.h"
#import "Nocilla.h"

@interface SKPaymentQueue (Test)
- (void)addTransactionForTest:(SKPaymentTransaction *)transaction;
+ (NSString*)confirmationMessage:(SKPayment*)payment;
@end

@interface SKPaymentQueueDelegate : NSObject<SKPaymentTransactionObserver>
@property XCTestExpectation *purchasingExpectation;
@property XCTestExpectation *purchasedExpectation;
@property XCTestExpectation *failedExpectation;
@property XCTestExpectation *removedExpectation;
@property XCTestExpectation *restoreExpectation;
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
            case SKPaymentTransactionStateRestored:
                [_restoreExpectation fulfill];
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
        XCTAssertEqual(queue.transactions.count, 0);
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
        XCTAssertEqual(queue.transactions.count, 0);
        [queue removeTransactionObserver:delegate];
    }];
}


- (void)testConnectToRestore {
    stubRequest(@"GET", @"https://api.tombo.io/payments/restorable?user_jwt=dummy_jwt").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([NSJSONSerialization dataWithJSONObject:
              @{
                @"data": @[
                        @{
                            @"type": @"payments",
                            @"id": @"transactionIdentifier1",
                            @"attributes": @{
                                    @"id": @"transactionIdentifier1",
                                    @"request_id": @"req1",
                                    @"product_identifier": @"product1",
                                    @"quantity": @"1",
                                    @"application_username": [NSNull null],
                                    @"status": @"2",
                                    @"created_at": @"1980-03-17T05:58:17.000+09:00",
                                    @"updated_at": @"1980-03-17T05:58:17.000+09:00",
                                    },
                            },
                        @{
                            @"type": @"payments",
                            @"id": @"transactionIdentifier2",
                            @"attributes": @{
                                    @"id": @"transactionIdentifier1",
                                    @"request_id": @"reg2",
                                    @"product_identifier": @"product2",
                                    @"quantity": @"2",
                                    @"application_username": [NSNull null],
                                    @"status": @"2",
                                    @"created_at": @"2017-03-17T05:58:17.000+09:00",
                                    @"updated_at": @"2017-03-17T05:58:17.000+09:00",
                                    },
                            }
                        ]
                } options:NSJSONWritingPrettyPrinted error:nil]);

    SKPaymentQueueDelegate *delegate = [[SKPaymentQueueDelegate alloc] init];
    delegate.restoreExpectation = [self expectationWithDescription:@"restore"];
    delegate.restoreExpectation.expectedFulfillmentCount = 2;
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
    [queue addTransactionObserver:delegate];

    [queue restoreCompletedTransactions];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }

        NSArray<SKPaymentTransaction *> *transactions = delegate.transactions;

        XCTAssertEqual(transactions.count, 2);

        SKPaymentTransaction *result = transactions[0];
        SKPaymentTransaction *original = result.originalTransaction;

        XCTAssertNotEqualObjects(result.transactionIdentifier, @"transactionIdentifier1");
        XCTAssertEqual(result.transactionState, SKPaymentTransactionStateRestored);

        XCTAssertNotNil(original);
        XCTAssertEqualObjects(original.transactionIdentifier, @"transactionIdentifier1");
        XCTAssertEqual(original.transactionDate.timeIntervalSince1970, 322088297);

        for (SKPaymentTransaction *transaction in transactions) {
            [queue finishTransaction:transaction];
        }
        XCTAssertEqual(queue.transactions.count, 0);
        [queue removeTransactionObserver:delegate];
    }];
}

- (void)testConfirmationMessage
{
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:@"12345"];
    SKProduct *product = [[SKProduct alloc] initWithProductIdentifier:@"product1" localizedTitle:@"title1" localizedDescription:@"desc1" price:price priceLocale:[NSLocale localeWithLocaleIdentifier:@"en_US@currency=JPY"]];
    SKPayment *payment = [SKPayment paymentWithProduct:product];

    NSString *message = [SKPaymentQueue confirmationMessage:payment];
    XCTAssertEqualObjects(message, @"Do you want to buy 1 title1 for ¥12,345");

}

@end
