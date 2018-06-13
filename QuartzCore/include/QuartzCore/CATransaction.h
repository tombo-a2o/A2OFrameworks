/*
 *  CATransaction.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>
#import <QuartzCore/CABase.h>

@class CAMediaTimingFunction;

CA_EXPORT NSString *const kCATransactionAnimationDuration;
CA_EXPORT NSString *const kCATransactionDisableActions;
CA_EXPORT NSString *const kCATransactionAnimationTimingFunction;
CA_EXPORT NSString *const kCATransactionCompletionBlock;

@interface CATransaction : NSObject

+ (BOOL)disableActions;
+ (CFTimeInterval)animationDuration;
+ (CAMediaTimingFunction *)animationTimingFunction;
+ (void (^)(void))completionBlock;
+ valueForKey:(NSString *)key;

+ (void)setAnimationDuration:(CFTimeInterval)value;
+ (void)setAnimationTimingFunction:(CAMediaTimingFunction *)value;
+ (void)setCompletionBlock:(void (^)(void))value;
+ (void)setDisableActions:(BOOL)value;
+ (void)setValue:value forKey:(NSString *)key;

+ (void)begin;
+ (void)commit;
+ (void)flush;

+ (void)lock;
+ (void)unlock;

@end
