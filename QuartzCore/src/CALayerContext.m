#import <QuartzCore/CALayerContext.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CARenderer.h>
#import <Foundation/NSString.h>
#define GL_GLEXT_PROTOTYPES
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <emscripten.h>

@implementation CALayerContext

-initWithFrame:(CGRect)rect {
    _frame = rect;
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _renderer = [[CARenderer rendererWithEAGLContext:_glContext options:nil] retain];

   return self;
}

-(void)dealloc {
    [_glContext release];
    [_renderer release];
    [super dealloc];
}

-(void)setFrame:(CGRect)rect {
   _frame=rect;
}

-(void)setLayer:(CALayer *)layer {
   layer=[layer retain];
   [_layer release];
   _layer=layer;

   [_renderer setLayer:layer];
}

-(void)invalidate {
}

-(void)renderLayer:(CALayer *)layer {
    [EAGLContext setCurrentContext:_glContext];

    GLint framebuffer, cullFaceMode, program;
    GLint blendSrcRgb, blendSrcAlpha, blendDstRgb, blendDstAlpha;
    GLboolean blendEnabled, cullFaceEnabled;
    
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
    glBindVertexArrayOES(0);

    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    GLint width=_frame.size.width;
    GLint height=_frame.size.height;
    CGFloat contentsScale = layer.contentsScale;

    glViewport(0, 0, width * contentsScale, height * contentsScale);

    _renderer.bounds = CGRectMake(0, 0, width, height);
    [layer layoutIfNeeded];
    [_renderer render];

    // restore state
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

-(void)render {
   [self renderLayer:_layer];
}

@end
