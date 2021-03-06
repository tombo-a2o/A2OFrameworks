//
//  SKPaymentTransactionStoreTest.m
//  StoreKit
//
//  Created by 千葉史哉 on 2017/08/16.
//  Copyright © 2017年 Tombo, inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SKPaymentTransactionStore.h"
#import "SKPaymentTransaction+Internal.h"
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentTransaction.h>

@interface SKPaymentTransactionStore (Test)
- (instancetype)initWithStoragePath:(NSString*)path;
@end

@interface SKPaymentTransactionStoreTest : XCTestCase

@end

@implementation SKPaymentTransactionStoreTest {
    NSString *_path;
    SKPaymentTransactionStore *_store;
}

- (void)setUp {
    [super setUp];
    _path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"transactions.db"];
    [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
    _store = [[SKPaymentTransactionStore alloc] initWithStoragePath:_path];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInsertAndGetWithEmptyTransaction {
    XCTAssertNotNil(_store);
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"productIdentifier1"];
    SKPaymentTransaction *transaction1 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    [_store insert:transaction1];
    SKPaymentTransaction *transaction2 = [_store transactionWithRequestId:transaction1.requestId];
    
    XCTAssertNotNil(transaction2);
    XCTAssertEqualObjects(transaction1.requestId, transaction2.requestId);
    XCTAssertEqualObjects(transaction1.payment.productIdentifier, transaction2.payment.productIdentifier);
    XCTAssertEqual(transaction1.payment.quantity, transaction2.payment.quantity);
    XCTAssertEqualObjects(transaction1.payment.requestData, transaction2.payment.requestData);
    XCTAssertEqualObjects(transaction1.payment.applicationUsername, transaction2.payment.applicationUsername);
    XCTAssertEqual(transaction1.transactionState, transaction2.transactionState);
    XCTAssertEqualObjects(transaction1.transactionDate, transaction2.transactionDate);
    XCTAssertEqualObjects(transaction1.transactionReceipt, transaction2.transactionReceipt);
    XCTAssertEqualObjects(transaction1.error, transaction2.error);
}

- (void)testInsertAndGetWithTransaction {
    XCTAssertNotNil(_store);
    
    SKMutablePayment *payment = [[SKPayment paymentWithProductIdentifier:@"productIdentifier1"] mutableCopy];
    payment.quantity = 2;
    payment.applicationUsername = @"username";
    payment.requestData = [NSData dataWithBytes:"requestdata" length:sizeof("requestdata")];
    SKPaymentTransaction *transaction1 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction1.transactionIdentifier = @"transactionIdentifier1";
    transaction1.transactionState = SKPaymentTransactionStateDeferred;
    transaction1.transactionDate = [NSDate date];
    transaction1.transactionReceipt = [NSData dataWithBytes:"receipt" length:sizeof("receipt")];;
    [_store insert:transaction1];
    SKPaymentTransaction *transaction2 = [_store transactionWithRequestId:transaction1.requestId];
    
    XCTAssertNotNil(transaction2);
    XCTAssertEqualObjects(transaction1.requestId, transaction2.requestId);
    XCTAssertEqualObjects(transaction1.payment.productIdentifier, transaction2.payment.productIdentifier);
    XCTAssertEqual(transaction1.payment.quantity, transaction2.payment.quantity);
    XCTAssertEqualObjects(transaction1.payment.requestData, transaction2.payment.requestData);
    XCTAssertEqualObjects(transaction1.payment.applicationUsername, transaction2.payment.applicationUsername);
    XCTAssertEqual(transaction1.transactionState, transaction2.transactionState);
    XCTAssertEqualObjects(transaction1.transactionDate, transaction2.transactionDate);
    XCTAssertEqualObjects(transaction1.transactionReceipt, transaction2.transactionReceipt);
    XCTAssertEqualObjects(transaction1.error, transaction2.error);
}

- (void)testIncomplete {
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"productIdentifier1"];
    SKPaymentTransaction *transaction1 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction1.requested = YES;
    [_store insert:transaction1];
    SKPaymentTransaction *transaction2 = [_store incompleteTransaction];
    
    XCTAssertNotNil(transaction2);
    XCTAssertEqualObjects(transaction1.requestId, transaction2.requestId);
}

- (void)testIncompletes {
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"productIdentifier1"];
    SKPaymentTransaction *transaction1 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction1.requested = YES;
    [_store insert:transaction1];
    SKPaymentTransaction *transaction2 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction2.requested = YES;
    [_store insert:transaction2];
    SKPaymentTransaction *transaction3 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction3.requested = NO;
    [_store insert:transaction3];
    NSArray<SKPaymentTransaction*> *transactions = [_store incompleteTransactions];
    
    XCTAssertNotNil(transactions);
    XCTAssertEqual(transactions.count, 2);
    XCTAssertEqualObjects(transactions[0].requestId, transaction1.requestId);
    XCTAssertEqualObjects(transactions[1].requestId, transaction2.requestId);
}

- (void)testNoIncomplete {
    SKPaymentTransaction *transaction = [_store incompleteTransaction];
    
    XCTAssertNil(transaction);
}

- (void)testNoIncompletes {
    NSArray<SKPaymentTransaction*> *transactions = [_store incompleteTransactions];
    
    XCTAssertNotNil(transactions);
    XCTAssertEqual(transactions.count, 0);
}


- (void)testUpdate {
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"productIdentifier1"];
    SKPaymentTransaction *transaction1 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    [_store insert:transaction1];
    
    transaction1.transactionState = SKPaymentTransactionStatePurchased;
    transaction1.transactionDate = [NSDate date];
    transaction1.transactionIdentifier = @"transactionIdentifier1";
    
    [_store update:transaction1];
    
    SKPaymentTransaction *transaction2 = [_store transactionWithRequestId:transaction1.requestId];
    
    XCTAssertNotNil(transaction2);
    XCTAssertEqualObjects(transaction1.requestId, transaction2.requestId);
    XCTAssertEqualObjects(transaction1.payment.productIdentifier, transaction2.payment.productIdentifier);
    XCTAssertEqual(transaction1.payment.quantity, transaction2.payment.quantity);
    XCTAssertEqualObjects(transaction1.payment.requestData, transaction2.payment.requestData);
    XCTAssertEqualObjects(transaction1.payment.applicationUsername, transaction2.payment.applicationUsername);
    XCTAssertEqual(transaction1.transactionState, transaction2.transactionState);
    XCTAssertEqualObjects(transaction1.transactionDate, transaction2.transactionDate);
    XCTAssertEqualObjects(transaction1.transactionReceipt, transaction2.transactionReceipt);
    XCTAssertEqualObjects(transaction1.error, transaction2.error);
}

- (void)testRemove {
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"productIdentifier1"];
    SKPaymentTransaction *transaction1 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    [_store insert:transaction1];
    
    [_store remove:transaction1];
    
    SKPaymentTransaction *transaction2 = [_store transactionWithRequestId:transaction1.requestId];
    
    XCTAssertNil(transaction2);
}

- (void)testRestoreInsert {
    SKMutablePayment *payment = [[SKPayment paymentWithProductIdentifier:@"productIdentifier1"] mutableCopy];
    payment.quantity = 2;
    payment.applicationUsername = @"username";
    payment.requestData = [NSData dataWithBytes:"requestdata" length:sizeof("requestdata")];
    SKPaymentTransaction *transaction1 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction1.transactionIdentifier = @"transactionIdentifier1";
    transaction1.transactionState = SKPaymentTransactionStateDeferred;
    transaction1.transactionDate = [NSDate date];
    transaction1.transactionReceipt = [NSData dataWithBytes:"receipt" length:sizeof("receipt")];;
    [_store insert:transaction1];
    
    SKPaymentTransactionStore *newStore = [[SKPaymentTransactionStore alloc] initWithStoragePath:_path];
    SKPaymentTransaction *transaction2 = [newStore transactionWithRequestId:transaction1.requestId];
    
    XCTAssertNotNil(transaction2);
    XCTAssertEqualObjects(transaction1.requestId, transaction2.requestId);
    XCTAssertEqualObjects(transaction1.payment.productIdentifier, transaction2.payment.productIdentifier);
    XCTAssertEqual(transaction1.payment.quantity, transaction2.payment.quantity);
    XCTAssertEqualObjects(transaction1.payment.requestData, transaction2.payment.requestData);
    XCTAssertEqualObjects(transaction1.payment.applicationUsername, transaction2.payment.applicationUsername);
    XCTAssertEqual(transaction1.transactionState, transaction2.transactionState);
    XCTAssertEqualObjects(transaction1.transactionDate, transaction2.transactionDate);
    XCTAssertEqualObjects(transaction1.transactionReceipt, transaction2.transactionReceipt);
    XCTAssertEqualObjects(transaction1.error, transaction2.error);
}

- (void)testRestoreUpdate {
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"productIdentifier1"];
    SKPaymentTransaction *transaction1 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    [_store insert:transaction1];
    
    transaction1.transactionState = SKPaymentTransactionStatePurchased;
    transaction1.transactionDate = [NSDate date];
    transaction1.transactionIdentifier = @"transactionIdentifier1";
    
    [_store update:transaction1];
    
    SKPaymentTransactionStore *newStore = [[SKPaymentTransactionStore alloc] initWithStoragePath:_path];
    SKPaymentTransaction *transaction2 = [newStore transactionWithRequestId:transaction1.requestId];
    
    XCTAssertNotNil(transaction2);
    XCTAssertEqualObjects(transaction1.requestId, transaction2.requestId);
    XCTAssertEqualObjects(transaction1.payment.productIdentifier, transaction2.payment.productIdentifier);
    XCTAssertEqual(transaction1.payment.quantity, transaction2.payment.quantity);
    XCTAssertEqualObjects(transaction1.payment.requestData, transaction2.payment.requestData);
    XCTAssertEqualObjects(transaction1.payment.applicationUsername, transaction2.payment.applicationUsername);
    XCTAssertEqual(transaction1.transactionState, transaction2.transactionState);
    XCTAssertEqualObjects(transaction1.transactionDate, transaction2.transactionDate);
    XCTAssertEqualObjects(transaction1.transactionReceipt, transaction2.transactionReceipt);
    XCTAssertEqualObjects(transaction1.error, transaction2.error);
}

- (void)testRestoreRemove {
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"productIdentifier1"];
    SKPaymentTransaction *transaction1 = [[SKPaymentTransaction alloc] initWithPayment:payment];
    [_store insert:transaction1];
    
    [_store remove:transaction1];
    
    SKPaymentTransactionStore *newStore = [[SKPaymentTransactionStore alloc] initWithStoragePath:_path];
    SKPaymentTransaction *transaction2 = [newStore transactionWithRequestId:transaction1.requestId];
    
    XCTAssertNil(transaction2);
}

@end
