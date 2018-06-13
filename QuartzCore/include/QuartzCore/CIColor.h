/*
 *  CIColor.h
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

@interface CIColor : NSObject {
    CGColorRef _cgColor;
}

+ (CIColor *)colorWithCGColor:(CGColorRef)cgColor;

+ (CIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (CIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- initWithCGColor:(CGColorRef)cgColor;

- (size_t)numberOfComponents;
- (CGColorSpaceRef)colorSpace;
- (const CGFloat *)components;

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

@end
