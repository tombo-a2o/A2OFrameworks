/*
 *  NSManagedObjectMutableSet.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import "NSManagedObjectMutableSet.h"
#import <CoreData/NSManagedObject.h>
#import <CoreData/NSManagedObjectContext.h>
#import <assert.h>

#define NSUnimplementedMethod() assert(0);

@implementation NSManagedObjectMutableSet

-initWithManagedObject:(NSManagedObject *)object key:(NSString *)key {
   _object=[object retain];
   _key=[key copy];
   return self;
}

-(void)dealloc {
   [_object release];
   [_key release];
   [super dealloc];
}

-(NSUInteger)count {
   return [[_object valueForKey:_key] count];
}

-member:object {
   return [[_object valueForKey:_key] member:[object objectID]];
}

-(NSEnumerator *)objectEnumerator {
   NSUnimplementedMethod();
   return nil;
}

-(void)addObject:object {
   NSMutableSet *set=[NSMutableSet setWithSet:[_object valueForKey:_key]];

   [set addObject:object];

   [_object setValue:set forKey:_key];
}

-(void)removeObject:object {
   NSMutableSet *set=[NSMutableSet setWithSet:[_object valueForKey:_key]];

   [set removeObject:object];

   [_object setValue:set forKey:_key];
}

@end
