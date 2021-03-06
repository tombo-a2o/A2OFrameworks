/*
 *  CAShapeLayer.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CALayer.h>

CA_EXPORT NSString *const kCALineJoinMiter;
CA_EXPORT NSString *const kCALineJoinRound;
CA_EXPORT NSString *const kCALineJoinBevel;

CA_EXPORT NSString *const kCALineCapButt;
CA_EXPORT NSString *const kCALineCapRound;
CA_EXPORT NSString *const kCALineCapSquare;

CA_EXPORT NSString *const kCAFillRuleNonZero;
CA_EXPORT NSString *const kCAFillRuleEvenOdd;

@interface CAShapeLayer : CALayer
@property CGPathRef path;
@property CGColorRef fillColor;
@property(copy) NSString *fillRule;
@property(copy) NSString *lineCap;
@property(copy) NSArray *lineDashPattern;
@property CGFloat lineDashPhase;
@property(copy) NSString *lineJoin;
@property CGFloat lineWidth;
@property CGFloat miterLimit;
@property CGColorRef strokeColor;
@property CGFloat strokeStart;
@property CGFloat strokeEnd;
@end
