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

extern int _legacyGLEmulationEnabled(void);

-(void)render {
    [EAGLContext setCurrentContext:_glContext];

    GLint framebuffer, cullFaceMode, program;
    GLint blendSrcRgb, blendSrcAlpha, blendDstRgb, blendDstAlpha;
    GLboolean blendEnabled, cullFaceEnabled;
    GLboolean vertexArray, textureCoordArray;
    GLint viewport[4];
    
    // save state
    glGetIntegerv(GL_CURRENT_PROGRAM, &program);
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &framebuffer);
    blendEnabled = glIsEnabled(GL_BLEND);
    if(blendEnabled) {
        glGetIntegerv(GL_BLEND_SRC_RGB, &blendSrcRgb);
        glGetIntegerv(GL_BLEND_SRC_ALPHA, &blendSrcAlpha);
        glGetIntegerv(GL_BLEND_DST_RGB, &blendDstRgb);
        glGetIntegerv(GL_BLEND_DST_ALPHA, &blendDstAlpha);
    }
    cullFaceEnabled = glIsEnabled(GL_CULL_FACE);
    if(cullFaceEnabled) {
        glGetIntegerv(GL_CULL_FACE_MODE, &cullFaceMode);
    }
    if(_legacyGLEmulationEnabled()) {
        glGetBooleanv(GL_VERTEX_ARRAY, &vertexArray);
        glGetBooleanv(GL_TEXTURE_COORD_ARRAY, &textureCoordArray);
    }
    glGetIntegerv(GL_VIEWPORT, viewport);
    glBindVertexArrayOES(0);

    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    CGRect frame = _layer.frame;
    GLint width = frame.size.width;
    GLint height = frame.size.height;
    CGFloat contentsScale = _layer.contentsScale;

    glViewport(0, 0, width * contentsScale, height * contentsScale);

    [_layer layoutIfNeeded];
    [_renderer render:_layer];

    // restore state
    if(_legacyGLEmulationEnabled()) {
        if(vertexArray) {
            glEnableClientState(GL_VERTEX_ARRAY);
        }
        if(textureCoordArray) {
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        }
    }
    glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);
    if(blendEnabled) {
        glEnable(GL_BLEND);
        glBlendFuncSeparate(blendSrcRgb, blendDstRgb, blendSrcAlpha, blendDstAlpha);
    } else {
        glDisable(GL_BLEND);
    }
    if(cullFaceEnabled) {
        glEnable(GL_CULL_FACE);
        glCullFace(cullFaceMode);
    } else {
        glDisable(GL_CULL_FACE);
    }
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glUseProgram(program);
}

@end
