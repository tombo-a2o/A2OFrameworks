/*
 *  SKPayment.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <StoreKit/SKPayment.h>
#import "SKPayment+Internal.h"

@implementation SKPayment

- (instancetype)initWithProduct:(SKProduct*)product
{
    if(!product) return nil;

    self = [self init];
    if(self) {
        _product = product;
        _productIdentifier = [product.productIdentifier copy];
        _quantity = 1;
    }
    return self;
}

- (instancetype)initWithProductIdentifier:(NSString *)productIdentifier
{
    if(!productIdentifier) return nil;

    self = [self init];
    if(self) {
        _product = nil;
        _productIdentifier = [productIdentifier copy];
        _quantity = 1;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    _productIdentifier = [decoder decodeObjectForKey:@"productIdentifier"];
    _quantity = [decoder decodeIntForKey:@"quantity"];
    _requestData = [decoder decodeObjectForKey:@"requestData"];
    _applicationUsername = [decoder decodeObjectForKey:@"applicationUsername"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_productIdentifier forKey:@"productIdentifier"];
    [encoder encodeInt:_quantity forKey:@"quantity"];
    [encoder encodeObject:_requestData forKey:@"requestData"];
    [encoder encodeObject:_applicationUsername forKey:@"applicationUsername"];
}

// Returns a new payment for the specified product.
+ (instancetype)paymentWithProduct:(SKProduct *)product
{
    return [[self alloc] initWithProduct:product];
}

// Returns a new payment with the specified product identifier.
+ (id)paymentWithProductIdentifier:(NSString *)identifier
{
    return [[self alloc] initWithProductIdentifier:identifier];
}

- (id)copyWithZone:(NSZone *)zone
{
    SKPayment *payment = [[SKPayment allocWithZone:zone] init];
    payment->_productIdentifier = [_productIdentifier copyWithZone:zone];
    payment->_quantity = _quantity;
    payment->_requestData = [_requestData copy];
    payment->_applicationUsername = [_applicationUsername copy];
    return payment;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    SKMutablePayment *payment = [[SKMutablePayment allocWithZone:zone] init];
    payment.productIdentifier = [_productIdentifier mutableCopyWithZone:zone];
    payment.quantity = _quantity;
    payment.requestData = [_requestData copy];
    payment.applicationUsername = [_applicationUsername copy];
    return payment;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@ 0x%p> {productIdentifier:%@, quantity:%d}", NSStringFromClass([self class]), self, _productIdentifier, _quantity];
}

@end

@implementation SKMutablePayment

@dynamic productIdentifier;
@dynamic quantity;
@dynamic requestData;
@dynamic applicationUsername;

- (void)setProductIdentifier:(NSString*)productIdentifier
{
    _productIdentifier = productIdentifier;
}

- (void)setQuantity:(NSInteger)quantity
{
    _quantity = quantity;
}

- (void)setRequestData:(NSData*)requestData
{
    _requestData = requestData;
}

- (void)setApplicationUsername:(NSString*)applicationUsername
{
    _applicationUsername = applicationUsername;
}
@end
