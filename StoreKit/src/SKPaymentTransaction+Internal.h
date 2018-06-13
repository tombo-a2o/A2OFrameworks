/*
 *  SKPaymentTransaction+Internal.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <StoreKit/SKPaymentTransaction.h>

@interface SKPaymentTransaction() <NSCoding>
- (instancetype)initWithPayment:(SKPayment *)payment;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@property(nonatomic, readwrite) NSError *error;
@property(nonatomic, readwrite) SKPayment *payment;
@property(nonatomic, readwrite) SKPaymentTransactionState transactionState;
@property(nonatomic, readwrite) NSString *transactionIdentifier;
@property(nonatomic, readwrite) NSDate *transactionDate;
@property(nonatomic, readwrite) NSData *transactionReceipt;

@property(nonatomic, readwrite) NSString *requestId;
@property(nonatomic, readwrite) SKPaymentTransaction *originalTransaction;
@property(nonatomic, readwrite) BOOL requested;
@end
