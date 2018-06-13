/*
 *  UIAnimation.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/QuartzCore.h>
#import "UIAnimation.h"

@implementation UIAnimation
+(CAKeyframeAnimation*)baseAnimation
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.5;
    anim.calculationMode = kCAAnimationDiscrete;
    return anim;
}

#define STEP 36

NSArray *values[2][2] = {};
static NSArray* getValues(int f2b, int clockwise)
{
    if(!values[f2b][clockwise]) {
        NSMutableArray *arr = [NSMutableArray array];
        double start = f2b ? 0 : M_PI;
        double delta = clockwise ? -M_PI/STEP : M_PI/STEP;
        double tz = clockwise ? 160 : -160;
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = -1.0/1000;

        for(int i = 0; i < STEP; i++) {
            CATransform3D rotation = CATransform3DMakeRotation(start + delta * i, 0, 1, 0);
            CATransform3D translation = CATransform3DMakeTranslation(0, 0, tz * sinf(delta*i));
            CATransform3D t = CATransform3DConcat(rotation, translation);
            t = CATransform3DConcat(t, perspective);
            [arr addObject:[NSValue valueWithCATransform3D:t]];
        }

        values[f2b][clockwise] = [arr copy];
    }
    return values[f2b][clockwise];
}


+(CAAnimation*)frontToBackClockwise
{
    CAKeyframeAnimation *anim = [self baseAnimation];
    anim.values = getValues(1, 1);
    return anim;
}

+(CAAnimation*)frontToBackCounterClockwise
{
    CAKeyframeAnimation *anim = [self baseAnimation];
    anim.values = getValues(1, 0);
    return anim;
}

+(CAAnimation*)backToFrontClockwise
{
    CAKeyframeAnimation *anim = [self baseAnimation];
    anim.values = getValues(0, 1);
    return anim;
}

+(CAAnimation*)backToFrontCounterClockwise
{
    CAKeyframeAnimation *anim = [self baseAnimation];
    anim.values = getValues(0, 0);
    return anim;
}

+(CATransform3D)perspective
{
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/1000;
    return perspective;
}
@end
