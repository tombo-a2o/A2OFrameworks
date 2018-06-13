/*
 *  SKPayment.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <StoreKit/SKProduct.h>

@interface SKPayment : NSObject <NSCopying, NSMutableCopying> {
    NSString *_productIdentifier;
    NSInteger _quantity;
    NSData *_requestData;
    NSString *_applicationUsername;
}

// Creating Instances
+ (instancetype)paymentWithProduct:(SKProduct *)product;
+ (id)paymentWithProductIdentifier:(NSString *)identifier;

// Getting Attributes
@property(nonatomic, copy, readonly) NSString *productIdentifier;
@property(nonatomic, readonly) NSInteger quantity;
@property(nonatomic, copy, readonly) NSData *requestData;
@property(nonatomic, copy, readonly) NSString *applicationUsername;

@end

@interface SKMutablePayment : SKPayment

// Getting and Settings Attributes
@property(nonatomic, copy, readwrite) NSString *productIdentifier;
@property(nonatomic, readwrite) NSInteger quantity;
@property(nonatomic, copy, readwrite) NSData *requestData;
@property(nonatomic, copy, readwrite) NSString *applicationUsername;
@end
