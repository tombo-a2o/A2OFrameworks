/*
 *  CTCarrier.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>

@interface CTCarrier : NSObject
@property(nonatomic, readonly, assign) BOOL allowsVOIP;
@property(nonatomic, readonly, retain) NSString *carrierName;
@property(nonatomic, readonly, retain) NSString *isoCountryCode;
@property(nonatomic, readonly, retain) NSString *mobileCountryCode;
@property(nonatomic, readonly, retain) NSString *mobileNetworkCode;
@end
