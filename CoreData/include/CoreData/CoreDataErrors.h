/*
 *  CoreDataErrors.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSString.h>
#import <CoreData/CoreDataExports.h>

COREDATA_EXPORT NSString *const NSAffectedStoresErrorKey;
COREDATA_EXPORT NSString *const NSDetailedErrorsKey;

enum {
    NSPersistentStoreInvalidTypeError = 134000,
    NSPersistentStoreTypeMismatchError = 134010,
    NSPersistentStoreIncompatibleSchemaError = 134020,
    NSPersistentStoreSaveError = 134030,
    NSPersistentStoreIncompleteSaveError = 134040,
    NSPersistentStoreOperationError = 134070,
    NSPersistentStoreOpenError = 134080,
    NSPersistentStoreTimeoutError = 134090,
    NSPersistentStoreIncompatibleVersionHashError = 134100,
};
