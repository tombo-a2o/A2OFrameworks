/*
 *  CAWindowOpenGLContext.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CAWindowOpenGLContext.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <Onyx2D/O2Surface.h>
#import "CAUtil.h"

@implementation CAWindowOpenGLContext {
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint program;
}

-initWithEAGLContext:(EAGLContext*)eaglContext {
   _eaglContext = [eaglContext retain];
   return self;
}

-(void)dealloc {
    [_eaglContext release];
    [super dealloc];
}

const char *vertexShaderSource =
    "attribute vec4 position;\n"
    "attribute vec2 texcoord;\n"
    "varying vec2 texcoordVarying;\n"
    "void main() { \n"
    "   gl_Position = position;\n"
    "   texcoordVarying = texcoord;\n"
    "}\n";
const char *fragmentShaderSource =
    "precision mediump float;\n"
    "varying vec2 texcoordVarying;\n"
    "uniform sampler2D texture;\n"
    "void main() {\n"
    "   gl_FragColor = texture2D(texture, texcoordVarying);\n"
    "}\n";

-(void)prepareViewportWidth:(int)width height:(int)height {
// prepare

    if(![EAGLContext setCurrentContext:_eaglContext]) {
        NSLog(@"EAGLContext +setCurrentContext failed in %s %d",__FILE__,__LINE__);
    }

    glViewport(0, 0, width, height);

    vertexShader = loadShader(vertexShaderSource, GL_VERTEX_SHADER);
    fragmentShader = loadShader(fragmentShaderSource, GL_FRAGMENT_SHADER);

    assert(vertexShader);
    assert(fragmentShader);

    program = linkProgram(vertexShader, fragmentShader);

    assert(program);
}

const float vertices[] = {
	-1.0f,  1.0f, 0.0f,
	-1.0f, -1.0f, 0.0f,
	 1.0f,  1.0f, 0.0f,
	 1.0f, -1.0f, 0.0f
};

const float texcoords[] = {
	0.0f, 0.0f,
	0.0f, 1.0f,
	1.0f, 0.0f,
	1.0f, 1.0f
};



-(void)renderSurface:(O2Surface *)surface {
    return;

    size_t width=O2ImageGetWidth(surface);
    size_t height=O2ImageGetHeight(surface);

    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);

    glUseProgram(program);

    GLuint position = glGetAttribLocation(program, "position");
    glEnableVertexAttribArray(position);

    GLuint texcoord = glGetAttribLocation(program, "texcoord");
	glEnableVertexAttribArray(texcoord);

    GLuint texture;
    texture = glGetUniformLocation(program, "texture");
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA,
        GL_UNSIGNED_BYTE, [surface pixelBytes]);

    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    glVertexAttribPointer(texcoord, 2, GL_FLOAT, GL_FALSE, 0, texcoords);
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 0, vertices);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
#if 0
// prepare
   glEnable(GL_DEPTH_TEST);
   glShadeModel(GL_SMOOTH);

// reshape
   glViewport(0,0,width,height);
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   glOrtho (0, width, 0, height, -1, 1);


// render
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();

   glClearColor(0, 0, 0, 0);
   glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

   glEnable( GL_TEXTURE_2D );
   glEnableClientState(GL_VERTEX_ARRAY);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);

   glEnable (GL_BLEND);
   glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

   width=O2ImageGetWidth(surface);
   height=O2ImageGetHeight(surface);

   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, [surface pixelBytes]);

   glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

   GLfloat vertices[4*2];
   GLfloat texture[4*2];

   vertices[0]=0;
   vertices[1]=0;
   vertices[2]=width;
   vertices[3]=0;
   vertices[4]=0;
   vertices[5]=height;
   vertices[6]=width;
   vertices[7]=height;

   texture[0]=0;
   texture[1]=1;
   texture[2]=1;
   texture[3]=1;
   texture[4]=0;
   texture[5]=0;
   texture[6]=1;
   texture[7]=0;

   glPushMatrix();
 //  glTranslatef(width/2,height/2,0);
   glTexCoordPointer(2, GL_FLOAT, 0, texture);
   glVertexPointer(2, GL_FLOAT, 0, vertices);
 //  glTranslatef(center.x,center.y,0);
 //  glRotatef(1,0,0,1);
   glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
   glPopMatrix();

   glFlush();
#endif
}

@end
