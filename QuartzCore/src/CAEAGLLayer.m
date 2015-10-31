#import <QuartzCore/CAEAGLLayer.h>

@implementation CAEAGLLayer
-(void)displayIfNeeded {
    // do nothing because EAGLContext set textureid directly
}
-(BOOL)_flipTexture {
    return YES;
}
@end
