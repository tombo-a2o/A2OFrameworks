/*
 *  NSInMemoryPersistentStore.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import "NSInMemoryPersistentStore.h"
#import <CoreData/NSPersistentStoreCoordinator.h>

@implementation NSInMemoryPersistentStore

+(NSDictionary *)metadataForPersistentStoreWithURL:(NSURL *)url error:(NSError **)error {
   return nil;
}

-(NSString *)type {
   return NSInMemoryStoreType;
}

-(BOOL)load:(NSError **)errorp {
   return YES;
}

-(BOOL)save:(NSError **)error {
   return YES;
}

@end
