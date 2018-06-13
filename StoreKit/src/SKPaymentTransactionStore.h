/*
 *  SKPaymentTransactionStore.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <StoreKit/SKBase.h>
#import <Foundation/Foundation.h>

@class SKPaymentTransaction;

@interface SKPaymentTransactionStore : NSObject
+ (instancetype)defaultStore;
- (void)insert:(SKPaymentTransaction*)transaction;
- (void)update:(SKPaymentTransaction*)transaction;
- (void)remove:(SKPaymentTransaction*)transaction;
- (SKPaymentTransaction*)transactionWithRequestId:(NSString*)requestId;
- (SKPaymentTransaction*)incompleteTransaction;
- (NSArray<SKPaymentTransaction*>*)incompleteTransactions;
- (NSArray<SKPaymentTransaction*>*)allTransactions;
@end
