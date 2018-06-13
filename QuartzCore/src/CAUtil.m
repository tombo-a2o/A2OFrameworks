/*
 *  CAUtil.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CAUtil.h"
#import <assert.h>

GLuint loadShader(const char *source, GLenum type)
{
    GLuint shader = glCreateShader(type);
    if(shader) {
        glShaderSource(shader, 1, &source, NULL);
        glCompileShader(shader);
        GLint stat = 0;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &stat);
        if(!stat) {
            char message[256];
            GLsizei length;
            glGetShaderInfoLog(shader, sizeof(message), &length, message);
            NSLog(@"Cound not compile shader %d %s %s", type, source, message);
            glDeleteShader(shader);
            shader = 0;
        }
    }
    return shader;
}

GLuint linkProgram(GLuint vertexShader, GLuint fragmentShader) {
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);

    glLinkProgram(program);
    GLint stat = 0;
    glGetProgramiv(program, GL_LINK_STATUS, &stat);
    if (stat != GL_TRUE) {
        char message[256];
        GLsizei length = 0;
		glGetProgramInfoLog(program, sizeof(message), &length, message);
		NSLog(@"Could not link program %s", message);
		glDeleteProgram(program);
		program = 0;
    }
    return program;
}

GLuint loadAndLinkShader(const char *vertexShaderSource, const char *fragmentShaderSource)
{
    GLuint vs = loadShader(vertexShaderSource, GL_VERTEX_SHADER);
    GLuint fs = loadShader(fragmentShaderSource, GL_FRAGMENT_SHADER);
    assert(vs);
    assert(fs);
    GLuint program = linkProgram(vs, fs);
    assert(program);
    glDeleteShader(vs);
    glDeleteShader(fs);

    return program;
}
