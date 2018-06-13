/*
 *  UIStepper.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIStepper.h>
#import <UIKit/UIImage.h>

@implementation UIStepper

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)setDividerImage:(UIImage *)image forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState;
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)setIncrementImage:(UIImage *)image forState:(UIControlState)state
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)setDecrementImage:(UIImage *)image forState:(UIControlState)state
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
