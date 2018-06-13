/*
 *  EAGLDrawable.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>
#import <OpenGLES/EAGL.h>

@protocol EAGLDrawable
@property(copy) NSDictionary *drawableProperties;
@end

extern NSString * const kEAGLDrawablePropertyColorFormat;
extern NSString * const kEAGLDrawablePropertyRetainedBacking;
extern NSString * const kEAGLColorFormatRGB565;
extern NSString * const kEAGLColorFormatRGBA8;

@interface EAGLContext (EAGLDrawableAddition)
-(BOOL)renderbufferStorage:(NSUInteger)target fromDrawable:(id<EAGLDrawable>)drawable;
@end
