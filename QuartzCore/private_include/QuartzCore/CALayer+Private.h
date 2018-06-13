/*
 *  CALayer+Private.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CALayer.h>
#import <OpenGLES/ES2/gl.h>

@interface CALayer(private)
-(void)_setTextureId:(GLuint)value;
-(GLuint)_textureId;
-(void)_setVertexObject:(GLuint)value;
-(GLuint)_vertexObject;
-(BOOL)_needsUpdateVertexObject;
-(void)_clearNeedsUpdateVertexObject;
-(CGFloat)textureSize;
-(BOOL)_flipTexture;
-(void)_updateAnimations:(CFTimeInterval)currentTime;
-(BOOL)_generatePresentationLayer;
-(NSArray*)_zOrderedSublayers;
-(void)_dispatchTransactionCompletionBlock:(CAAnimation*)animation;
-(CGSize)_contentsSize;
@end
