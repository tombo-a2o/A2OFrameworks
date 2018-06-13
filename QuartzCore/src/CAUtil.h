/*
 *  CAUtil.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#if defined(DEBUG)
#define GL_ASSERT() { GLenum err = glGetError(); if(err != GL_NO_ERROR) { fprintf(stderr, "%s(%d) err = 0x%04x\n", __FILE__, __LINE__, err); assert(0);}}
#else
#define GL_ASSERT()
#endif

extern GLuint loadShader(const char *source, GLenum type);
extern GLuint linkProgram(GLuint vertexShader, GLuint fragmentShader);
extern GLuint loadAndLinkShader(const char *vertexShaderSource, const char *fragmentShaderSource);
