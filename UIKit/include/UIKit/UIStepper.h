/*
 *  UIStepper.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIControl.h>

@class UIImage;

@interface UIStepper : UIControl
@property(nonatomic) double value;
@property(nonatomic) double minimumValue;
@property(nonatomic) double maximumValue;
@property(nonatomic) double stepValue;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setDividerImage:(UIImage *)image forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState;
- (void)setIncrementImage:(UIImage *)image forState:(UIControlState)state;
- (void)setDecrementImage:(UIImage *)image forState:(UIControlState)state;
@end
