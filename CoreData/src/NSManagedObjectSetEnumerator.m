/*
 *  NSManagedObjectSetEnumerator.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import "NSManagedObjectSetEnumerator.h"
#import <CoreData/NSManagedObjectContext.h>

@implementation NSManagedObjectSetEnumerator

-initWithManagedObjectContext:(NSManagedObjectContext *)context objectEnumerator:(NSEnumerator *)enumerator {
   _context=[context retain];
   _enumerator=[enumerator retain];
   return self;
}

-(void)dealloc {
   [_context release];
   [_enumerator release];
   [super dealloc];
}

-nextObject {
   id objectID=[_enumerator nextObject];

   if(objectID==nil)
    return nil;

   return [_context objectWithID:objectID];
}

@end
