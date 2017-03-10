#import <Foundation/NSObject.h>
#import <Foundation/NSDictionary.h>
#import <CoreGraphics/CoreGraphics.h>
//#import <CoreVideo/CoreVideo.h>

@class CALayer, O2Surface;

@interface CARenderer : NSObject

+ (CARenderer *)renderer;

- (void)render:(CALayer*)rootLayer;

@end
