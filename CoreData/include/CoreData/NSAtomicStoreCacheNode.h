/*
 *  NSAtomicStoreCacheNode.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>

@class NSManagedObjectID, NSMutableDictionary;

@interface NSAtomicStoreCacheNode : NSObject {
    NSManagedObjectID *_objectID;
    NSMutableDictionary *_propertyCache;
}

- initWithObjectID:(NSManagedObjectID *)objectID;

- (NSManagedObjectID *)objectID;

- (NSMutableDictionary *)propertyCache;

- (void)setPropertyCache:(NSMutableDictionary *)value;

- (void)setValue:value forKey:(NSString *)key;

- valueForKey:(NSString *)key;

@end
