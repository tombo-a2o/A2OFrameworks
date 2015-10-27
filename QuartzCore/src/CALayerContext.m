#import <QuartzCore/CALayerContext.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CARenderer.h>
#import <Foundation/NSString.h>
#import <OpenGLES/ES2/gl.h>

@interface CALayer(private)
-(void)_setContext:(CALayerContext *)context;
-(NSNumber *)_textureId;
-(void)_setTextureId:(NSNumber *)value;
@end

@implementation CALayerContext

-initWithFrame:(CGRect)rect {
    _frame = rect;
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _renderer = [[CARenderer rendererWithEAGLContext:_glContext options:nil] retain];

#if 0
    [EAGLContext setCurrentContext:_glContext];

    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);

    assert(_framebuffer);

    GLint width=rect.size.width;
    GLint height=rect.size.height;

    //NSLog(@"w=%d, h=%d", width, height);

    GLuint colorRenderbuffer;
    glGenRenderbuffers(1, &colorRenderbuffer);
    assert(colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);

    GLuint depthRenderbuffer;
    glGenRenderbuffers(1, &depthRenderbuffer);
    assert(depthRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);

    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    // GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    // if(status != GL_FRAMEBUFFER_COMPLETE) {
    //     NSLog(@"failed to make complete framebuffer object %x", status);
    //     return nil;
    // }
#endif

#if 0
   CGLError error;

   CGLPixelFormatAttribute attributes[1]={
    0,
   };
   GLint numberOfVirtualScreens;

   CGLChoosePixelFormat(attributes,&_pixelFormat,&numberOfVirtualScreens);

   if((error=CGLCreateContext(_pixelFormat,NULL,&_glContext))!=kCGLNoError)
    NSLog(@"CGLCreateContext failed with %d in %s %d",error,__FILE__,__LINE__);

   _frame=rect;

   GLint width=rect.size.width;
   GLint height=rect.size.height;

   GLint backingOrigin[2]={rect.origin.x,rect.origin.y};
   GLint backingSize[2]={width,height};

   CGLSetParameter(_glContext,kCGLCPSurfaceBackingOrigin,backingOrigin);
   CGLSetParameter(_glContext,kCGLCPSurfaceBackingSize,backingSize);

   GLint opacity=0;
   CGLSetParameter(_glContext,kCGLCPSurfaceOpacity,&opacity);

   _renderer=[[CARenderer rendererWithCGLContext:_glContext options:nil] retain];
#endif

   return self;
}

-(void)dealloc {
   [_timer invalidate];
   [_timer release];
   [super dealloc];
}

-(void)setFrame:(CGRect)rect {
   _frame=rect;

   GLint width=rect.size.width;
   GLint height=rect.size.height;

#if 1
    assert(0);
#else
    GLint backingOrigin[2]={rect.origin.x,rect.origin.y};
    GLint backingSize[2]={width,height};

    CGLSetParameter(_glContext,kCGLCPSurfaceBackingOrigin,backingOrigin);
    CGLSetParameter(_glContext,kCGLCPSurfaceBackingSize,backingSize);
#endif
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

-(void)assignTextureIdsToLayerTree:(CALayer *)layer {

    if([layer _textureId]==nil){
        GLuint texture;

        glGenTextures(1,&texture);
        [layer _setTextureId:[NSNumber numberWithUnsignedInt:texture]];
    }

    for(CALayer *child in layer.sublayers)
        [self assignTextureIdsToLayerTree:child];
}

-(void)renderLayer:(CALayer *)layer {
    [EAGLContext setCurrentContext:_glContext];

    glEnable(GL_DEPTH_TEST);

    GLint width=_frame.size.width;
    GLint height=_frame.size.height;

    glViewport(0, 0, width, height);

#warning TODO
#if 0
   CGLSetCurrentContext(_glContext);

   glEnable(GL_DEPTH_TEST);
   glShadeModel(GL_SMOOTH);

   GLint width=_frame.size.width;
   GLint height=_frame.size.height;

   glViewport(0,0,width,height);
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   glOrtho (0, width, 0, height, -1, 1);
#endif

    GLsizei i=0;
    GLuint deleteIds[[_deleteTextureIds count]];
    for(NSNumber *number in _deleteTextureIds)
        deleteIds[i++]=[number unsignedIntValue];

    if(i > 0) {
        glDeleteTextures(i, deleteIds);
    }

    [_deleteTextureIds removeAllObjects];

    [self assignTextureIdsToLayerTree:layer];

    _renderer.bounds = CGRectMake(0, 0, width, height);
    [_renderer render];
}

-(void)render {
   [self renderLayer:_layer];
}

-(void)timer:(NSTimer *)timer {
   [_renderer beginFrameAtTime:CACurrentMediaTime() timeStamp:NULL];

   [self render];

   [_renderer endFrame];
}

-(void)startTimerIfNeeded {
   if(_timer==nil)
    _timer=[[NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES] retain];
}

-(void)deleteTextureId:(NSNumber *)textureId {
   [_deleteTextureIds addObject:textureId];
}

@end
