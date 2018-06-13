/*
 *  NSPersistentStore.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>

@class NSPersistentStoreCoordinator, NSURL, NSDictionary, NSError;

@interface NSPersistentStore : NSObject {
    NSPersistentStoreCoordinator *_coordinator;
    NSString *_configurationName;
    NSURL *_url;
    NSDictionary *_options;
    BOOL _isReadOnly;
    NSString *_identifier;
}

+ (NSDictionary *)metadataForPersistentStoreWithURL:(NSURL *)url error:(NSError **)error;
+ (BOOL)setMetadata:(NSDictionary *)metadata forPersistentStoreWithURL:(NSURL *)url error:(NSError **)error;

+ (Class)migrationManagerClass;

- initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)root configurationName:(NSString *)name URL:(NSURL *)url options:(NSDictionary *)options;

- (NSString *)type;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSString *)configurationName;
- (NSURL *)URL;
- (NSDictionary *)options;

- (BOOL)isReadOnly;
- (NSString *)identifier;
- (NSDictionary *)metadata;

- (void)setURL:(NSURL *)value;
- (void)setReadOnly:(BOOL)value;
- (void)setIdentifier:(NSString *)value;
- (void)setMetadata:(NSDictionary *)value;

- (BOOL)loadMetadata:(NSError **)error;

- (void)willRemoveFromPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (void)didAddToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

@end
