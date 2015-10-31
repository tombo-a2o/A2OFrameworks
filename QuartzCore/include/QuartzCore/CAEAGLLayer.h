#import <QuartzCore/CALayer.h>
#import <OpenGLES/EAGLDrawable.h>

@interface CAEAGLLayer : CALayer<EAGLDrawable>
@property(copy) NSDictionary *drawableProperties;
@end
