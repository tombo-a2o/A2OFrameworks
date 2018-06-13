/*
 *  gltypes.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#ifndef __OPENGL_FRAMEWORKS_GL_TYPES__
#define __OPENGL_FRAMEWORKS_GL_TYPES__

#include <KHR/khrplatform.h>
typedef void             GLvoid;
typedef char             GLchar;
typedef unsigned int     GLenum;
typedef unsigned char    GLboolean;
typedef unsigned int     GLbitfield;
typedef khronos_int8_t   GLbyte;
typedef short            GLshort;
typedef int              GLint;
typedef int              GLsizei;
typedef khronos_uint8_t  GLubyte;
typedef unsigned short   GLushort;
typedef unsigned int     GLuint;
typedef khronos_float_t  GLfloat;
typedef khronos_float_t  GLclampf;
typedef khronos_int32_t  GLfixed;
typedef khronos_int32_t  GLclampx;

typedef khronos_intptr_t GLintptr;
typedef khronos_ssize_t  GLsizeiptr;

typedef struct __GLsync *GLsync;
typedef khronos_int64_t GLint64;
typedef khronos_uint64_t GLuint64;
#endif
