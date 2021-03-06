/*
 *  NSPersistentStore.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreData/NSPersistentStore.h>
#import <CoreData/NSPersistentStoreCoordinator.h>
#import <Foundation/NSDictionary.h>
#import <CoreFoundation/CFUUID.h>
#import <assert.h>

#define NSInvalidAbstractInvocation() assert(0)
#define NSUnimplementedMethod() assert(0)

@implementation NSPersistentStore

+(NSDictionary *)metadataForPersistentStoreWithURL:(NSURL *)url error:(NSError **)error {
   NSInvalidAbstractInvocation();
   return nil;
}

+(BOOL)setMetadata:(NSDictionary *)metadata forPersistentStoreWithURL:(NSURL *)url error:(NSError **)error {
   NSInvalidAbstractInvocation();
   return 0;
}

+(Class)migrationManagerClass {
   NSUnimplementedMethod();
   return 0;
}

-initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)root configurationName:(NSString *)name URL:(NSURL *)url options:(NSDictionary *)options {
   _coordinator=root;
   _configurationName=[name copy];
   _url=[url copy];
   _options=[options copy];
   _isReadOnly=NO;
   CFUUIDRef uuid=CFUUIDCreate(NULL);
   _identifier=(NSString *)CFUUIDCreateString(NULL,uuid);
   CFRelease(uuid);

   return self;
}

-(void)dealloc {
   [_identifier release];
   [super dealloc];
}

-(NSString *)type {
   NSInvalidAbstractInvocation();
   return 0;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
   return _coordinator;
}

-(NSString *)configurationName {
   return _configurationName;
}

-(NSURL *)URL {
   return _url;
}

-(NSDictionary *)options {
   return _options;
}

-(BOOL)isReadOnly {
   return _isReadOnly;
}

-(NSString *)identifier {
   return _identifier;
}

-(NSDictionary *)metadata {
   return [NSDictionary dictionaryWithObjectsAndKeys:[self identifier],NSStoreUUIDKey,[self type],NSStoreTypeKey,nil];
}

-(void)setURL:(NSURL *)value {
   value=[value copy];
   [_url release];
   _url=value;
}

-(void)setReadOnly:(BOOL)value {
   NSUnimplementedMethod();
}

-(void)setIdentifier:(NSString *)value {
   value=[value copy];
   [_identifier release];
   _identifier=value;
}

-(void)setMetadata:(NSDictionary *)value {
   NSUnimplementedMethod();
}

-(BOOL)loadMetadata:(NSError **)error {
   NSUnimplementedMethod();
}

-(void)willRemoveFromPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator {
// Default implementation does nothing
}

-(void)didAddToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator {
// Default implementation does nothing
}

-(NSString *)description {
   return [NSString stringWithFormat:@"<%@ %p URL=%@>",isa,self,[self URL]];
}

@end
