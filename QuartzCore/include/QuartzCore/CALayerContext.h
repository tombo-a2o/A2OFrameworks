#import <Foundation/NSObject.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <CoreGraphics/CGGeometry.h>

@class CARenderer, CALayer;

@interface CALayerContext : NSObject {
    EAGLContext *_glContext;
    CALayer *_layer;
    CARenderer *_renderer;
}

- (instancetype)initWithLayer:(CALayer*)layer;

- (void)render;

@end
