/*
 *  NSPersistentStoreCoordinator-Private.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreData/NSPersistentStoreCoordinator.h>

@class NSManagedObjectID;

@interface NSPersistentStoreCoordinator (private)
- (NSPersistentStore *)_persistentStoreWithIdentifier:(NSString *)identifier;
- (NSPersistentStore *)_persistentStoreForObjectID:(NSManagedObjectID *)object;
- (NSPersistentStore *)_persistentStoreForObject:(NSManagedObject *)object;
@end
