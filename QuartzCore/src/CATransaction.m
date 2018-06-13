/*
 *  CATransaction.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CATransaction.h>
#import <QuartzCore/CALayerContext.h>
#import <Foundation/Foundation.h>
//#import <Foundation/NSThread-Private.h>
#import "CATransactionGroup.h"

NSString * const kCATransactionAnimationDuration=@"kCATransactionAnimationDuration";
NSString * const kCATransactionDisableActions=@"kCATransactionDisableActions";
NSString * const kCATransactionAnimationTimingFunction=@"kCATransactionAnimationTimingFunction";
NSString * const kCATransactionCompletionBlock=@"kCATransactionCompletionBlock";

@implementation CATransaction

static NSMutableArray *transactionStack(){
   NSMutableDictionary *shared=[[NSThread currentThread] threadDictionary];
   id                   stack=[shared objectForKey:@"CATransactionStack"];

   if(stack==nil){
    stack=[NSMutableArray array];
    [shared setObject:stack forKey:@"CATransactionStack"];
   }

   return stack;
}

static CATransactionGroup *currentTransactionGroup(){
   id stack=transactionStack();

   CATransactionGroup *result=[stack lastObject];

   return result;
}

static CATransactionGroup *createImplicitTransactionGroupIfNeeded(){
   CATransactionGroup *check=currentTransactionGroup();

   if(check==nil){
    check=[[CATransactionGroup alloc] init];

    [transactionStack() addObject:check];
    [check release];
    [[NSRunLoop currentRunLoop] performSelector:@selector(commit) target:[CATransaction class] argument:nil order:0 modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
   }

   return check;
}


+(BOOL)disableActions {
   return [[self valueForKey:kCATransactionDisableActions] boolValue];
}

+(CFTimeInterval)animationDuration {
   return [[self valueForKey:kCATransactionAnimationDuration] doubleValue];
}

+(CAMediaTimingFunction *)animationTimingFunction {
   return [self valueForKey:kCATransactionAnimationTimingFunction];
}

+(void (^)(void))completionBlock {
    return [self valueForKey:kCATransactionCompletionBlock];
}

+valueForKey:(NSString *)key {
   CATransactionGroup *group=createImplicitTransactionGroupIfNeeded();

   return [group valueForKey:key];
}

+(void)setAnimationDuration:(CFTimeInterval)value {
   [self setValue:[NSNumber numberWithDouble:value] forKey:kCATransactionAnimationDuration];
}

+(void)setAnimationTimingFunction:(CAMediaTimingFunction *)value {
   [self setValue:value forKey:kCATransactionAnimationDuration];
}

+(void)setCompletionBlock:(void (^)(void))value {
    [self setValue:[value copy] forKey:kCATransactionCompletionBlock];
}

+(void)setDisableActions:(BOOL)value {
   [self setValue:[NSNumber numberWithBool:value] forKey:kCATransactionDisableActions];
}

+(void)setValue:value forKey:(NSString *)key {
   CATransactionGroup *group=createImplicitTransactionGroupIfNeeded();

   [group setValue:value forKey:key];
}

+(void)begin {
   CATransactionGroup *group=[[CATransactionGroup alloc] init];

   [transactionStack() addObject:group];
   [group release];
}

+(void)commit {
   void (^block)(void) = [self completionBlock];
   if(block && [self _retainCountCompletionBlock:block] == 0) {
       block();
   }

   [transactionStack() removeLastObject];
}

+(void)flush {
}

+(void)lock {
}

+(void)unlock {
}

static NSMutableDictionary *dict;

+(void)_retainCompletionBlock:(void (^)(void))block {
    if(!dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    NSNumber *num = [dict objectForKey:block];
    if(num) {
        [dict setObject:[NSNumber numberWithInt:[num intValue]+1] forKey:block];
    } else {
        [dict setObject:@1 forKey:block];
    }
}

+(int)_retainCountCompletionBlock:(void (^)(void))block {
    NSNumber *num = [dict objectForKey:block];
    if(num) {
        return [num intValue];
    } else {
        return 0;
    }
}

+(int)_releaseCompletionBlock:(void (^)(void))block {
    NSNumber *num = [dict objectForKey:block];
    if(num) {
        int number = [num intValue] - 1;
        if(number) {
            [dict setObject:[NSNumber numberWithInt:number] forKey:block];
        } else {
            [dict removeObjectForKey:block];
        }
        return number;
    } else {
        return 0;
    }
}

@end
