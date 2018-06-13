/*
 *  CAEAGLLayer.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CAEAGLLayer.h>
#import <OpenGLES/ES2/gl.h>
#import <QuartzCore/CALayer+Private.h>

@implementation CAEAGLLayer
-(void)displayIfNeeded {
    // do nothing because EAGLContext set textureid directly
}
-(BOOL)_flipTexture {
    return YES;
}
-(GLuint)_textureId {
    if(self.modelLayer) {
        return [(CALayer*)self.modelLayer _textureId];
    } else {
        return [super _textureId];
    }
}
@end
