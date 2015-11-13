#import <QuartzCore/CALayerContext.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CARenderer.h>
#import <Foundation/NSString.h>
#import <OpenGLES/ES2/gl.h>
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

   [_layer _setContext:self];
   [_renderer setLayer:layer];
}

-(void)invalidate {
}

-(void)renderLayer:(CALayer *)layer {
    [EAGLContext setCurrentContext:_glContext];

    GLint framebuffer;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    GLint width=_frame.size.width;
    GLint height=_frame.size.height;
    CGFloat contentsScale = layer.contentsScale;

    glViewport(0, 0, width * contentsScale, height * contentsScale);

    _renderer.bounds = CGRectMake(0, 0, width, height);
    [_renderer render];

    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
}

-(void)render {
   [self renderLayer:_layer];
}

@end
