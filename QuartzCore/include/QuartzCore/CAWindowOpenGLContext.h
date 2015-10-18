#import <QuartzCore/CARenderer.h>
#import <OpenGLES/EAGL.h>

@interface CAWindowOpenGLContext : NSObject {
    EAGLContext *_eaglContext;
}

- initWithEAGLContext:(EAGLContext*)eaglContext;

- (void)prepareViewportWidth:(int)width height:(int)height;

- (void)renderSurface:(O2Surface *)surface;

@end
