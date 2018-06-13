/*
 *  CAAnimation.h
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
#import <QuartzCore/CAMediaTiming.h>
#import <QuartzCore/CAAction.h>
#import <Foundation/NSArray.h>
#import <CoreGraphics/CoreGraphics.h>

@class CAMediaTimingFunction;

CA_EXPORT NSString *const kCATransitionFade;
CA_EXPORT NSString *const kCATransitionMoveIn;
CA_EXPORT NSString *const kCATransitionPush;
CA_EXPORT NSString *const kCATransitionReveal;

CA_EXPORT NSString *const kCATransitionFromLeft;
CA_EXPORT NSString *const kCATransitionFromRight;
CA_EXPORT NSString *const kCATransitionFromTop;
CA_EXPORT NSString *const kCATransitionFromBottom;

@interface CAAnimation : NSObject <NSCopying, CAMediaTiming, CAAction> {
    id _delegate;
    BOOL _removedOnCompletion;
    CAMediaTimingFunction *_timingFunction;
    BOOL _autoreverses;
    CFTimeInterval _beginTime;
    CFTimeInterval _duration;
    NSString *_fillMode;
    float _repeatCount;
    CFTimeInterval _repeatDuration;
    float _speed;
    CFTimeInterval _timeOffset;
}

+ animation;

@property(retain) id delegate;

@property(getter=isRemovedOnCompletion) BOOL removedOnCompletion;

@property(retain) CAMediaTimingFunction *timingFunction;

@end

@interface NSObject (CAAnimationDelegate)
- (void)animationDidStart:(CAAnimation *)animation;
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished;
@end

@interface CAPropertyAnimation : CAAnimation {
    NSString *_keyPath;
    BOOL _additive;
    BOOL _cumulative;
}

+ animationWithKeyPath:(NSString *)keyPath;
@property(copy) NSString *keyPath;
@property(getter=isAdditive) BOOL additive;
@property(getter=isCumulative) BOOL cumulative;

@end

@interface CABasicAnimation : CAPropertyAnimation {
    id _fromValue;
    id _toValue;
    id _byValue;
}

@property(retain) id fromValue;
@property(retain) id toValue;
@property(retain) id byValue;

@end

extern NSString * const kCAAnimationRotateAuto;
extern NSString * const kCAAnimationRotateAutoReverse;
extern NSString * const kCAAnimationLinear;
extern NSString * const kCAAnimationDiscrete;
extern NSString * const kCAAnimationPaced;
extern NSString * const kCAAnimationCubic;
extern NSString * const kCAAnimationCubicPaced;

@interface CAKeyframeAnimation : CAPropertyAnimation
@property(copy) NSArray *values;
@property CGPathRef path;
@property(copy) NSArray *keyTimes;
@property(copy) NSArray *timingFunctions;
@property(copy) NSString *calculationMode;
@property(copy) NSString *rotationMode;
@property(copy) NSArray  *tensionValues;
@property(copy) NSArray *continuityValues;
@property(copy) NSArray *biasValues;


@end

#import <QuartzCore/CATransition.h>
#import <QuartzCore/CAAnimationGroup.h>
