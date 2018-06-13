/*
 *  CATransactionGroup.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import "CATransactionGroup.h"
#import <QuartzCore/CATransaction.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSDictionary.h>

@implementation CATransactionGroup

-init {
   _values=[[NSMutableDictionary alloc] init];
   [_values setObject:[NSNumber numberWithFloat:0.25] forKey:kCATransactionAnimationDuration];
   [_values setObject:[NSNumber numberWithBool:NO] forKey:kCATransactionDisableActions];
   // kCATransactionAnimationTimingFunction default is nil
   // kCATransactionCompletionBlock default is nil
   return self;
}

-valueForKey:(NSString *)key {
   return [_values objectForKey:key];
}

-(void)setValue:value forKey:(NSString *)key {
   [_values setObject:value forKey:key];
}

@end
