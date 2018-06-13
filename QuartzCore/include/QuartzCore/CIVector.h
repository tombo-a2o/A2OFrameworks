/*
 *  CIVector.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CIVector : NSObject {
    size_t _count;
    CGFloat *_values;
}

+ (CIVector *)vectorWithValues:(const CGFloat *)values count:(size_t)count;

+ (CIVector *)vectorWithX:(CGFloat)x;
+ (CIVector *)vectorWithX:(CGFloat)x Y:(CGFloat)y;
+ (CIVector *)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
+ (CIVector *)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z W:(CGFloat)w;

- initWithValues:(const CGFloat *)values count:(size_t)count;
- initWithX:(CGFloat)x;
- initWithX:(CGFloat)x Y:(CGFloat)y;
- initWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
- initWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z W:(CGFloat)w;

- (size_t)count;
- (CGFloat)valueAtIndex:(size_t)index;

- (CGFloat)X;
- (CGFloat)Y;
- (CGFloat)Z;
- (CGFloat)W;

@end
