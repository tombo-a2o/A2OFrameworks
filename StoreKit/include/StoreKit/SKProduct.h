/*
 *  SKProduct.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

@interface SKProduct : NSObject

// Getting Product Attributes
@property(readonly) NSString *localizedDescription;
@property(readonly) NSString *localizedTitle;
@property(readonly) NSDecimalNumber *price;
@property(readonly) NSLocale *priceLocale;
@property(readonly) NSString *productIdentifier;

// Getting Downloadable Content Information
@property(readonly) BOOL downloadable;
@property(nonatomic, readonly) NSArray<NSNumber *> *downloadContentLengths;
@property(nonatomic, readonly) NSString *downloadContentVersion;

// FIXME: move to private
- (instancetype)initWithProductIdentifier:(NSString *)productIdentifier localizedTitle:(NSString *)localizedTitle localizedDescription:(NSString *)localizedDescription price:(NSDecimalNumber *)price priceLocale:(NSLocale *)priceLocale;

@end
