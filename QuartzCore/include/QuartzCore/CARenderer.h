#import <Foundation/NSObject.h>
#import <Foundation/NSDictionary.h>
#import <CoreGraphics/CoreGraphics.h>
//#import <CoreVideo/CoreVideo.h>

@class CALayer, O2Surface;

@interface CARenderer : NSObject {
    void *_eaglContext;
    CGRect _bounds;
    CALayer *_rootLayer;
}

@property(assign) CGRect bounds;
@property(retain) CALayer *layer;

+ (CARenderer *)rendererWithEAGLContext:(void *)eaglContext options:(NSDictionary *)options;

- (void)render;

- (void)endFrame;

@end
