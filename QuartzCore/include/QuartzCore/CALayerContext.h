/*
 *  CALayerContext.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <CoreGraphics/CGGeometry.h>

@class CARenderer, CALayer;

@interface CALayerContext : NSObject {
    EAGLContext *_glContext;
    CALayer *_layer;
    CARenderer *_renderer;
}

- (instancetype)initWithLayer:(CALayer*)layer;

- (void)render;

@end
