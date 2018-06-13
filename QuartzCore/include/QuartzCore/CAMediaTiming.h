/*
 *  CAMediaTiming.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CABase.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

@protocol CAMediaTiming

@property BOOL autoreverses;

@property CFTimeInterval beginTime;

@property CFTimeInterval duration;

@property(copy) NSString *fillMode;

@property float repeatCount;

@property CFTimeInterval repeatDuration;

@property float speed;

@property CFTimeInterval timeOffset;

@end

extern NSString * const kCAFillModeRemoved;
extern NSString * const kCAFillModeForwards;
extern NSString * const kCAFillModeBackwards;
extern NSString * const kCAFillModeBoth;
extern NSString * const kCAFillModeFrozen;
