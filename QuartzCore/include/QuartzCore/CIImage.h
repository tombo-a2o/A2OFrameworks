/*
 *  CIImage.h
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

@class CIFilter;

@interface CIImage : NSObject {
    CGImageRef _cgImage;
    CIFilter *_filter;
}

+ (CIImage *)emptyImage;

- initWithCGImage:(CGImageRef)cgImage;
- (CGRect)extent;

@end
