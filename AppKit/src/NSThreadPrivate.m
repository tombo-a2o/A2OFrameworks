/*
 *  NSThreadPrivate.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import "NSThreadPrivate.h"

static inline id _NSThreadSharedInstance(NSThread *thread,NSString *className,BOOL create) {
   NSMutableDictionary *shared=thread.threadDictionary;
   if(!shared)
      return nil;
	id result=nil;
//   [thread->_sharedObjectLock lock];
   result=[shared objectForKey:className];
//   [thread->_sharedObjectLock unlock];

   if(result==nil && create){
      // do not hold lock during object allocation
      result=[NSClassFromString(className) new];
//      [thread->_sharedObjectLock lock];
      [shared setObject:result forKey:className];
//      [thread->_sharedObjectLock unlock];
      [result release];
   }

   return result;
}

FOUNDATION_EXPORT id NSThreadSharedInstance(NSString *className) {
   return _NSThreadSharedInstance([NSThread currentThread],className,YES);
}

FOUNDATION_EXPORT id NSThreadSharedInstanceDoNotCreate(NSString *className) {
   return _NSThreadSharedInstance([NSThread currentThread],className,NO);
}


