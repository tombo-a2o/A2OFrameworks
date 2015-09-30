#import <Foundation/NSObject.h>
#import <OpenGLES/OpenGLES.h>
#import <CoreGraphics/CGGeometry.h>

@class CARenderer, CALayer, CGLPixelSurface, NSTimer, NSMutableArray, NSNumber;
@class CGLPixelFormat, CGLContext;
typedef CGLContext *CGLContextObj;
typedef CGLPixelFormat *CGLPixelFormatObj;

@interface CALayerContext : NSObject {
    CGRect _frame;
    CGLPixelFormatObj _pixelFormat;
    CGLContextObj _glContext;
    CALayer *_layer;
    CARenderer *_renderer;

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
