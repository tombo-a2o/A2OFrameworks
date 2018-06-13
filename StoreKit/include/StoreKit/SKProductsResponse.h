/*
 *  SKProductsResponse.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>

@interface SKProductsResponse : NSObject

// Response Information
@property(readonly) NSArray<SKProduct *> *products;
@property(readonly) NSArray *invalidProductIdentifiers;

// FIXME: move to private
- (instancetype)initWithProducts:(NSArray *)products invalidProductIdentifiers:(NSArray*)invalidProductIdentifiers;

@end
