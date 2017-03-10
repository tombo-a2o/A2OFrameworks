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


