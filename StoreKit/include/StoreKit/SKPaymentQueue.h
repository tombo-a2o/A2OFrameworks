/*
 *  SKPaymentQueue.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentTransaction.h>

@class SKPaymentQueue;

@protocol SKPaymentTransactionObserver <NSObject>

// Handing Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions;
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions;

// Handling Restored Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue;

// Handling Download Actions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads;

@end

@interface SKPaymentQueue : NSObject

// Determining Whether the User Can Make Payments
+ (BOOL)canMakePayments;

// Getting the Queue
+ (instancetype)defaultQueue;

// Adding and Removing the Observer
- (void)addTransactionObserver:(id<SKPaymentTransactionObserver>)observer;
- (void)removeTransactionObserver:(id<SKPaymentTransactionObserver>)observer;

// Managing Transactions
@property(nonatomic, readonly) NSArray *transactions;
- (void)addPayment:(SKPayment *)payment;
- (void)finishTransaction:(SKPaymentTransaction *)transaction;

// Restoring Purchases
- (void)restoreCompletedTransactions;
- (void)restoreCompletedTransactionsWithApplicationUsername:(NSString *)username;

// Downloading Content
- (void)startDownloads:(NSArray<SKDownload *>*)downloads;
- (void)cancelDownloads:(NSArray<SKDownload *>*)downloads;
- (void)pauseDownloads:(NSArray<SKDownload *>*)downloads;
- (void)resumeDownloads:(NSArray<SKDownload *> *)downloads;
@end
