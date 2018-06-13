/*
 *  CGGradient.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreGraphics/CoreGraphicsExport.h>
#import <CoreGraphics/CGGeometry.h>
#import <CoreGraphics/CGColorSpace.h>
#import <CoreFoundation/CFArray.h>

typedef struct CGGradient *CGGradientRef;

enum CGGradientDrawingOptions {
    kCGGradientDrawsBeforeStartLocation = 0x01,
    kCGGradientDrawsAfterEndLocation = 0x02
};
typedef enum CGGradientDrawingOptions CGGradientDrawingOptions;

CGGradientRef CGGradientCreateWithColorComponents(CGColorSpaceRef colorSpace, const CGFloat components[], const CGFloat locations[], size_t count);
CGGradientRef CGGradientCreateWithColors(CGColorSpaceRef colorSpace, CFArrayRef colors, const CGFloat locations[]);

void CGGradientRelease(CGGradientRef self);
CGGradientRef CGGradientRetain(CGGradientRef self);
