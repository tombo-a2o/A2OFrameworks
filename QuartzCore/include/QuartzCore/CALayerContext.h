#import <Foundation/NSObject.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <CoreGraphics/CGGeometry.h>

@class CARenderer, CALayer, CGLPixelSurface, NSMutableArray, NSNumber;
//@class CGLPixelFormat, ESGLContext;
//typedef CGLPixelFormat *CGLPixelFormatObj;

@interface CALayerContext : NSObject {
    CGRect _frame;
//    CGLPixelFormatObj _pixelFormat;
    EAGLContext *_glContext;
    CALayer *_layer;
    CARenderer *_renderer;
    GLuint _framebuffer;
}

- initWithFrame:(CGRect)rect;

- (void)setFrame:(CGRect)value;
- (void)setLayer:(CALayer *)layer;

- (void)invalidate;

- (void)render;

@end
