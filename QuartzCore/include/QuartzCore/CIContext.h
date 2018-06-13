/*
 *  CIContext.h
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

@class CIImage, NSDictionary;

@interface CIContext : NSObject {
    CGContextRef _cgContext;
}

+ (CIContext *)contextWithCGContext:(CGContextRef)cgContext options:(NSDictionary *)options;

- (void)drawImage:(CIImage *)image atPoint:(CGPoint)atPoint fromRect:(CGRect)fromRect;
- (void)drawImage:(CIImage *)image inRect:(CGRect)inRect fromRect:(CGRect)fromRect;

@end
