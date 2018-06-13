/*
 *  CIFilter.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>

@class NSMutableDictionary;

@interface CIFilter : NSObject {
    NSMutableDictionary *_keyValues;
}

+ (CIFilter *)filterWithName:(NSString *)name;
- (void)setDefaults;

- valueForKey:(NSString *)key;
- (void)setValue:value forKey:(NSString *)key;

@end
