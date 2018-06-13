/*
 *  SKPaymentTransaction.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

typedef NSInteger SKPaymentTransactionState;

@class SKPayment;

@interface SKPaymentTransaction : NSObject

// Getting Information About the Transaction
@property(nonatomic, readonly) NSError *error;
@property(nonatomic, readonly) SKPayment *payment;
@property(nonatomic, readonly) SKPaymentTransactionState transactionState;
@property(nonatomic, readonly) NSString *transactionIdentifier;
@property(nonatomic, readonly) NSDate *transactionDate;
@property(nonatomic, readonly) NSData *transactionReceipt;

// Getting Information about the Transaction's Downloadable Content
@property(nonatomic, readonly) NSArray *downloads;

// Restored Transactions
@property(nonatomic, readonly) SKPaymentTransaction *originalTransaction;
@end

// Constants
enum {
    SKPaymentTransactionStatePurchasing,
    SKPaymentTransactionStatePurchased,
    SKPaymentTransactionStateFailed,
    SKPaymentTransactionStateRestored,
    SKPaymentTransactionStateDeferred,
};
