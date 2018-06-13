/*
 *  CAAnimationGroup.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CAAnimationGroup.h>

@implementation CAAnimationGroup

-(NSArray *)animations {
   return _animations;
}

-(void)setAnimations:(NSArray *)value {
   value=[value copy];
   [_animations release];
   _animations=value;
}

@end
