/*
 *  SKPaymentTransactionStore.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <StoreKit/StoreKit.h>
#import "SKPaymentTransactionStore.h"
#import "SKPaymentTransaction+Internal.h"

@implementation SKPaymentTransactionStore {
    NSString *_path;
    NSMutableArray<SKPaymentTransaction*>* _transactions;
}

+ (instancetype)defaultStore
{
    return [[SKPaymentTransactionStore alloc] initWithStoragePath:[NSHomeDirectory() stringByAppendingPathComponent:@"transactions"]];
}

- (instancetype)initWithStoragePath:(NSString*)path
{
    SKDebugLog(@"path %@", path);

    self = [super init];

    _path = path;
    _transactions = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];

    if(!_transactions) {
        _transactions = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)saveToFile
{
    BOOL success = [NSKeyedArchiver archiveRootObject:_transactions toFile:_path];
    SKDebugLog(@"success = %d", success);
}

- (void)insert:(SKPaymentTransaction*)transaction
{
    SKDebugLog(@"%@", transaction);
    [_transactions addObject:transaction];
    [self saveToFile];
}

- (void)update:(SKPaymentTransaction*)transaction
{
    SKDebugLog(@"%@", transaction);
    [_transactions replaceObjectAtIndex:[_transactions indexOfObject:transaction] withObject:transaction];
    [self saveToFile];
}

-(void)remove:(SKPaymentTransaction*)transaction
{
    SKDebugLog(@"%@", transaction);
    [_transactions removeObject:transaction];
    [self saveToFile];
}

- (SKPaymentTransaction*)transactionWithRequestId:(NSString*)requestId
{
    for(SKPaymentTransaction *transaction in _transactions) {
        if([transaction.requestId isEqualToString:requestId]) {
            return transaction;
        }
    }
    return nil;
}

- (SKPaymentTransaction*)incompleteTransaction
{
    return [self incompleteTransactions].firstObject;
}

- (NSArray<SKPaymentTransaction*>*)incompleteTransactions
{
    return [_transactions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"transactionState == 0 AND requested == YES"]];
}

- (NSArray*)allTransactions
{
    return [_transactions copy];
}

@end
