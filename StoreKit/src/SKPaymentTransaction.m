/*
 *  SKPaymentTransaction.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <StoreKit/StoreKit.h>
#import "SKPaymentTransaction+Internal.h"
#import "SKPayment+Internal.h"

@implementation SKPaymentTransaction

- (instancetype)initWithPayment:(SKPayment *)payment
{
    if(!payment) return nil;

    _transactionIdentifier = nil;
    _payment = [payment copy];
    _transactionState = SKPaymentTransactionStatePurchasing;
    _transactionDate = nil;
    _error = nil;
    _requestId = [NSUUID UUID].UUIDString.lowercaseString;
    _requested = NO;

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    _transactionIdentifier = [decoder decodeObjectForKey:@"transactionIdentifier"];
    _payment = [decoder decodeObjectForKey:@"payment"];
    _transactionState = [decoder decodeIntForKey:@"transactionState"];
    _transactionDate = [decoder decodeObjectForKey:@"transactionDate"];
    _transactionReceipt = [decoder decodeObjectForKey:@"transactionReceipt"];
    _error = [decoder decodeObjectForKey:@"error"];
    _requestId = [decoder decodeObjectForKey:@"requestId"];
    _requested = [decoder decodeBoolForKey:@"requested"];
    _originalTransaction = [decoder decodeObjectForKey:@"originalTransaction"];


    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_transactionIdentifier forKey:@"transactionIdentifier"];
    [encoder encodeObject:_payment forKey:@"payment"];
    [encoder encodeInt:_transactionState forKey:@"transactionState"];
    [encoder encodeObject:_transactionDate forKey:@"transactionDate"];
    [encoder encodeObject:_transactionReceipt forKey:@"transactionReceipt"];
    [encoder encodeObject:_error forKey:@"error"];
    [encoder encodeObject:_requestId forKey:@"requestId"];
    [encoder encodeBool:_requested forKey:@"requested"];
    [encoder encodeObject:_originalTransaction forKey:@"originalTransaction"];
}

- (NSString*)description
{
    NSString *stateString = nil;
    switch(_transactionState) {
    case SKPaymentTransactionStatePurchasing:
        stateString = @"SKPaymentTransactionStatePurchasing";
        break;
    case SKPaymentTransactionStatePurchased:
        stateString = @"SKPaymentTransactionStatePurchased";
        break;
    case SKPaymentTransactionStateFailed:
        stateString = @"SKPaymentTransactionStateFailed";
        break;
    case SKPaymentTransactionStateRestored:
        stateString = @"SKPaymentTransactionStateRestored";
        break;
    case SKPaymentTransactionStateDeferred:
        stateString = @"SKPaymentTransactionStateDeferred";
        break;
    }
    return [NSString stringWithFormat:@"<%@ 0x%p> {%@, %@, %@, %@, %@, %d, %@}", NSStringFromClass([self class]), self, _transactionIdentifier, _payment, stateString, _transactionDate, _requestId, _requested, _error];
}

- (BOOL)isEqual:(id)object
{
    SKPaymentTransaction *transaction = (SKPaymentTransaction*)object;
    return [_requestId isEqual:transaction.requestId];
}

- (NSUInteger)hash {
    return [_requestId hash];
}

@end
