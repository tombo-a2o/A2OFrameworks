#import <QuartzCore/CALayerContext.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CARenderer.h>
#import <Foundation/NSString.h>
#define GL_GLEXT_PROTOTYPES
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <emscripten.h>
#import "CAUtil.h"

@implementation CALayerContext

-initWithLayer:(CALayer*)layer {
    _layer = layer;
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _renderer = [[CARenderer renderer] retain];

   return self;
}

-(void)dealloc {
    [_glContext release];
    [_renderer release];
    [super dealloc];
}

static void displayTree(CALayer *layer) {
    [layer displayIfNeeded];
    for(CALayer *child in layer.sublayers) {
        displayTree(child);
    }
}

extern int _legacyGLEmulationEnabled(void);

-(void)render {
    [EAGLContext setCurrentContext:_glContext];
    [_layer layoutIfNeeded];
    displayTree(_layer);
    // NSLog(@"%s begin -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=", __FUNCTION__);

    GLint framebuffer, program, texture;
    GLboolean blendEnabled, cullFaceEnabled, depthTestEnabled;
    GLint blendSrcRgb, blendSrcAlpha, blendDstRgb, blendDstAlpha;
    GLint cullFaceMode, depthFunc;
    GLboolean vertexArray, textureCoordArray, normalArray, colorArray;
    GLint viewport[4];
    
    // save state
    glGetIntegerv(GL_CURRENT_PROGRAM, &program);
    GL_ASSERT();
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &framebuffer);
    GL_ASSERT();
    glGetIntegerv(GL_TEXTURE_BINDING_2D, &texture);
    GL_ASSERT();
    blendEnabled = glIsEnabled(GL_BLEND);
    GL_ASSERT();
    if(blendEnabled) {
        glGetIntegerv(GL_BLEND_SRC_RGB, &blendSrcRgb);
        GL_ASSERT();
        glGetIntegerv(GL_BLEND_SRC_ALPHA, &blendSrcAlpha);
        GL_ASSERT();
        glGetIntegerv(GL_BLEND_DST_RGB, &blendDstRgb);
        GL_ASSERT();
        glGetIntegerv(GL_BLEND_DST_ALPHA, &blendDstAlpha);
        GL_ASSERT();
    }
    cullFaceEnabled = glIsEnabled(GL_CULL_FACE);
    GL_ASSERT();
    if(cullFaceEnabled) {
        glGetIntegerv(GL_CULL_FACE_MODE, &cullFaceMode);
        GL_ASSERT();
    }
    depthTestEnabled = glIsEnabled(GL_DEPTH_TEST);
    GL_ASSERT();
    if(depthTestEnabled) {
        glGetIntegerv(GL_DEPTH_FUNC, &depthFunc);
        GL_ASSERT();
    }
    if(_legacyGLEmulationEnabled()) {
        glGetBooleanv(GL_VERTEX_ARRAY, &vertexArray);
        GL_ASSERT();
        glGetBooleanv(GL_TEXTURE_COORD_ARRAY, &textureCoordArray);
        GL_ASSERT();
        glGetBooleanv(GL_NORMAL_ARRAY, &normalArray);
        GL_ASSERT();
        glGetBooleanv(GL_COLOR_ARRAY, &colorArray);
        GL_ASSERT();
    }
    glGetIntegerv(GL_VIEWPORT, viewport);
    GL_ASSERT();
    glBindVertexArrayOES(0);
    GL_ASSERT();

    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    GL_ASSERT();

    CGRect frame = _layer.frame;
    GLint width = frame.size.width;
    GLint height = frame.size.height;
    CGFloat contentsScale = _layer.contentsScale;

    glViewport(0, 0, width * contentsScale, height * contentsScale);
    GL_ASSERT();

    [_renderer render:_layer];

    // restore state
    if(_legacyGLEmulationEnabled()) {
        if(vertexArray) {
            glEnableClientState(GL_VERTEX_ARRAY);
            GL_ASSERT();
        }
        if(textureCoordArray) {
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
            GL_ASSERT();
        }
        if(normalArray) {
            glEnableClientState(GL_NORMAL_ARRAY);
            GL_ASSERT();
        }
        if(colorArray) {
            glEnableClientState(GL_COLOR_ARRAY);
            GL_ASSERT();
        }
    }
    glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);
    GL_ASSERT();
    if(blendEnabled) {
        glEnable(GL_BLEND);
        GL_ASSERT();
        glBlendFuncSeparate(blendSrcRgb, blendDstRgb, blendSrcAlpha, blendDstAlpha);
        GL_ASSERT();
    } else {
        glDisable(GL_BLEND);
        GL_ASSERT();
    }
    if(cullFaceEnabled) {
        glEnable(GL_CULL_FACE);
        GL_ASSERT();
        glCullFace(cullFaceMode);
        GL_ASSERT();
    } else {
        glDisable(GL_CULL_FACE);
        GL_ASSERT();
    }
    if(depthTestEnabled) {
        glEnable(GL_DEPTH_TEST);
        GL_ASSERT();
        glDepthFunc(depthFunc);
        GL_ASSERT();
    } else {
        glDisable(GL_DEPTH_TEST);
        GL_ASSERT();
    }
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    GL_ASSERT();
    glUseProgram(program);
    GL_ASSERT();
    glBindTexture(GL_TEXTURE_2D, texture);
    GL_ASSERT();
    // NSLog(@"%s end -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=", __FUNCTION__);
}

@end
