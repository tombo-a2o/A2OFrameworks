#import <Foundation/NSObject.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <CoreGraphics/CGGeometry.h>

@class CARenderer, CALayer, CGLPixelSurface, NSTimer, NSMutableArray, NSNumber;
//@class CGLPixelFormat, ESGLContext;
//typedef CGLPixelFormat *CGLPixelFormatObj;

@interface CALayerContext : NSObject {
    CGRect _frame;
//    CGLPixelFormatObj _pixelFormat;
    EAGLContext *_glContext;
    CALayer *_layer;
    CARenderer *_renderer;
    GLuint _framebuffer;

    NSMutableArray *_deleteTextureIds;

    NSTimer *_timer;
}

- initWithFrame:(CGRect)rect;

- (void)setFrame:(CGRect)value;
- (void)setLayer:(CALayer *)layer;

- (void)invalidate;

- (void)render;

- (void)startTimerIfNeeded;

- (void)deleteTextureId:(NSNumber *)textureId;

@end
