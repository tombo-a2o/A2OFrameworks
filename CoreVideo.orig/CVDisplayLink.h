/*
 *  CVDisplayLink.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <CoreVideo/CVBase.h>
#import <CoreVideo/CVReturn.h>
#import <OpenGL/OpenGL.h>

@class CVDisplayLink;

typedef CVDisplayLink *CVDisplayLinkRef;

typedef CVReturn (*CVDisplayLinkOutputCallback)(CVDisplayLinkRef, const CVTimeStamp *, const CVTimeStamp *, CVOptionFlags, CVOptionFlags *, void *);

COREVIDEO_EXPORT CVReturn CVDisplayLinkCreateWithActiveCGDisplays(CVDisplayLinkRef *result);
COREVIDEO_EXPORT CVReturn CVDisplayLinkSetOutputCallback(CVDisplayLinkRef self, CVDisplayLinkOutputCallback callback, void *userInfo);
COREVIDEO_EXPORT CVReturn CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(CVDisplayLinkRef self, CGLContextObj cglContext, CGLPixelFormatObj cglPixelFormat);

COREVIDEO_EXPORT CVReturn CVDisplayLinkStart(CVDisplayLinkRef self);
COREVIDEO_EXPORT CVReturn CVDisplayLinkStop(CVDisplayLinkRef self);
COREVIDEO_EXPORT Boolean CVDisplayLinkIsRunning(CVDisplayLinkRef self);

COREVIDEO_EXPORT CVDisplayLinkRef CVDisplayLinkRetain(CVDisplayLinkRef self);
COREVIDEO_EXPORT void CVDisplayLinkRelease(CVDisplayLinkRef self);
