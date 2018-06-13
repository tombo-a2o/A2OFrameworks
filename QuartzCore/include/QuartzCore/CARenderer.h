/*
 *  CARenderer.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>
#import <Foundation/NSDictionary.h>
#import <CoreGraphics/CoreGraphics.h>
//#import <CoreVideo/CoreVideo.h>

@class CALayer, O2Surface;

@interface CARenderer : NSObject

+ (CARenderer *)renderer;

- (void)render:(CALayer*)rootLayer;

@end
