/*
 *  NSManagedObjectID-Private.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreData/NSManagedObjectID.h>

@interface NSManagedObjectID (private)
- initWithEntity:(NSEntityDescription *)entity;
- (NSString *)storeIdentifier;

// Do not use referenceObject directly except for debugging
// Use -[NSAtomicStore referenceObjectForUniqueID:] as this needs to unique the ID
- referenceObject;

- (void)setStoreIdentifier:(NSString *)storeIdentifier;
- (void)setReferenceObject:value;
- (void)setPersistentStore:(NSPersistentStore *)store;
@end
