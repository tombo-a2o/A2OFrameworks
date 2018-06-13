/*
 *  NSAtomicStoreCacheNode.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreData/NSAtomicStoreCacheNode.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>

@implementation NSAtomicStoreCacheNode

-initWithObjectID:(NSManagedObjectID *)objectID {
   _objectID=[objectID copy];
   _propertyCache=nil;
   return self;
}

-(void)dealloc {
   [_objectID release];
   [_propertyCache release];
   [super dealloc];
}

-(NSUInteger)hash {
   return [_objectID hash];
}

-(BOOL)isEqual:other {
   return [_objectID isEqual:other];
}

-(NSManagedObjectID *)objectID {
   return _objectID;
}

-(NSMutableDictionary *)propertyCache {
   return _propertyCache;
}

-(void)setPropertyCache:(NSMutableDictionary *)value {
   value=[value retain];
   [_propertyCache release];
   _propertyCache=value;
}

-(void)setValue:value forKey:(NSString *)key {
   if(_propertyCache==nil)
    _propertyCache=[[NSMutableDictionary alloc] init];

   if(value==nil)
    [_propertyCache removeObjectForKey:key];
   else {
    [_propertyCache setObject:value forKey:key];
   }
}

-valueForKey:(NSString *)key {
   return [_propertyCache objectForKey:key];
}

@end
