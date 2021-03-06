/*
 *  NSAtomicStore.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreData/NSAtomicStore.h>
#import <CoreData/NSManagedObject.h>
#import <CoreData/NSAtomicStoreCacheNode.h>
#import "NSManagedObjectID-Private.h"
#import "NSManagedObject-Private.h"
#import <Foundation/NSSet.h>
#import <Foundation/NSDictionary.h>
#include <assert.h>

#define NSInvalidAbstractInvocation() assert(0)

@implementation NSAtomicStore

-initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator configurationName:(NSString *)configurationName URL:(NSURL *)url options:(NSDictionary *)options {
   if([super initWithPersistentStoreCoordinator:coordinator configurationName:configurationName URL:url options:options]==nil)
    return nil;

   _metadata=[[NSDictionary alloc] init];
   _cacheNodes=[[NSMutableSet alloc] init];
   _objectIDToCacheNode=[[NSMutableDictionary alloc] init];
   _objectIDTable=[[NSMutableDictionary alloc] init];
   return self;
}

-(void)dealloc {
   [_metadata release];
   [_cacheNodes release];
   [_objectIDToCacheNode release];
   [_objectIDTable release];
   [super dealloc];
}

-(NSSet *)cacheNodes {
   return _cacheNodes;
}

-(NSDictionary *)metadata {
   return _metadata;
}

-(void)setMetadata:(NSDictionary *)value {
   value=[value copy];
   [_metadata release];
   _metadata=value;
}

-(void)addCacheNodes:(NSSet *)values {
   for(NSAtomicStoreCacheNode *node in values){

    [_objectIDToCacheNode setObject:node forKey:[node objectID]];
   }
   [_cacheNodes unionSet:values];
}

-(NSAtomicStoreCacheNode *)cacheNodeForObjectID:(NSManagedObjectID *)objectID {
   NSAtomicStoreCacheNode *result= [_objectIDToCacheNode objectForKey:objectID];

   return result;
}

-(NSAtomicStoreCacheNode *)newCacheNodeForManagedObject:(NSManagedObject *)managedObject {
   return [[NSAtomicStoreCacheNode alloc] initWithObjectID:[managedObject objectID]];
}

-(NSManagedObjectID *)objectIDForEntity:(NSEntityDescription *)entity referenceObject:referenceObject {
   NSMutableDictionary *refTable=[_objectIDTable objectForKey:[entity name]];

   if(refTable==nil){
    refTable=[NSMutableDictionary dictionary];
    [_objectIDTable setObject:refTable forKey:[entity name]];
   }

   NSManagedObjectID *result=[refTable objectForKey:referenceObject];

   if(result==nil){
    result=[[[NSManagedObjectID alloc] initWithEntity:entity] autorelease];

    [result setReferenceObject:referenceObject];
    [result setStoreIdentifier:[self identifier]];
    [result setPersistentStore:self];

    [refTable setObject:result forKey:referenceObject];
   }

   return result;
}

-(void)_uniqueObjectID:(NSManagedObjectID *)objectID {
   NSEntityDescription *entity=[objectID entity];
   NSMutableDictionary *refTable=[_objectIDTable objectForKey:[entity name]];

   if(refTable==nil){
    refTable=[NSMutableDictionary dictionary];
    [_objectIDTable setObject:refTable forKey:[entity name]];
   }

   id referenceObject=[objectID referenceObject];

   [refTable setObject:objectID forKey:referenceObject];
}

-referenceObjectForObjectID:(NSManagedObjectID *)objectID {
   return [objectID referenceObject];
}

-(void)willRemoveCacheNodes:(NSSet *)cacheNodes {
}

-newReferenceObjectForManagedObject:(NSManagedObject *)managedObject {
   NSInvalidAbstractInvocation();
   return 0;
}

-(void)updateCacheNode:(NSAtomicStoreCacheNode *)node fromManagedObject:(NSManagedObject *)managedObject {
   NSInvalidAbstractInvocation();
}

-(BOOL)load:(NSError **)error {
   NSInvalidAbstractInvocation();
   return 0;
}

-(BOOL)save:(NSError **)error {
   NSInvalidAbstractInvocation();
   return 0;
}

@end
