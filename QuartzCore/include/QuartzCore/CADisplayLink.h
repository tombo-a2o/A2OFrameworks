/*
 *  CADisplayLink.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

@interface CADisplayLink : NSObject
+ (CADisplayLink *)displayLinkWithTarget:(id)target selector:(SEL)sel;
- (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode;
- (void)removeFromRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode;
- (void)invalidate;
@property(readonly, nonatomic) CFTimeInterval duration;
@property(nonatomic) NSInteger frameInterval;
@property(getter=isPaused, nonatomic) BOOL paused;
@property(readonly, nonatomic) CFTimeInterval timestamp;
@end
