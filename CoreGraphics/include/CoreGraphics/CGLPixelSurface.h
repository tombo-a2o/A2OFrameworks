/*
 *  CGLPixelSurface.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>
#import <Onyx2D/O2Geometry.h>
#import <OpenGLES/ES2/gl.h>

@class O2Surface, CGWindow;

@interface CGLPixelSurface : NSObject {
    int _width, _height;
    BOOL _isOpaque, _validBuffers;
    int _numberOfBuffers;
    int _rowsPerBuffer;
    GLuint *_bufferObjects;
    void **_readPixels;
    void **_staticPixels;

    O2Surface *_surface;
}

- initWithSize:(O2Size)size;

- (void)setFrameSize:(O2Size)value;
- (void)setOpaque:(BOOL)value;

- (void)readBuffer;

- (O2Surface *)validSurface;

@end
