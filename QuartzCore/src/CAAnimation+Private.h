/*
 *  CAAnimation+Private.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CATransaction.h>

@interface CAAnimation(Rendering)
-(float)_scale;
-(BOOL)_isFinished;
-(void)_updateLayer:(CALayer*)layer currentTime:(CFTimeInterval)currentTime;
-(void)_setCompletionBlock:(void (^)(void))value;
-(void (^)(void))_completionBlock;
@end

@interface CAPropertyAnimation(Rendering)
-(NSValue*)_interpolate:(NSValue*)x with:(NSValue*)y ratio:(float)ratio type:(const char*)type;
-(void)_updateProperty:(CALayer*)layer withValue:(id)value;
@end

@interface CABasicAnimation(Rendering)
@end

@interface CATransaction(CompletionBlockCounting)
+(void)_retainCompletionBlock:(void (^)(void))block;
+(int)_releaseCompletionBlock:(void (^)(void))block;
@end
