/*
 *  NSManagedObjectSet.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import "NSManagedObjectSet.h"
#import "NSManagedObjectSetEnumerator.h"
#import <CoreData/NSManagedObjectContext.h>
#import <CoreData/NSManagedObject.h>

@implementation NSManagedObjectSet

-initWithManagedObjectContext:(NSManagedObjectContext *)context set:(NSSet *)set {
   _context=[context retain];
   _set=[set retain];
   return self;
}

-(void)dealloc {
   [_context release];
   [_set release];
   [super dealloc];
}

-(NSUInteger)count {
   return [_set count];
}

-member:object {
   return [_set member:[object objectID]];
}

-(NSEnumerator *)objectEnumerator {
   NSEnumerator *state=[_set objectEnumerator];

   if(state==nil)
    return nil;

   return [[[NSManagedObjectSetEnumerator alloc] initWithManagedObjectContext:_context objectEnumerator:state] autorelease];
}

@end
