#import <QuartzCore/CAEAGLLayer.h>
#import <OpenGLES/ES2/gl.h>
#import <QuartzCore/CALayer+Private.h>

@implementation CAEAGLLayer
-(void)displayIfNeeded {
    // do nothing because EAGLContext set textureid directly
}
-(BOOL)_flipTexture {
    return YES;
}
-(GLuint)_textureId {
    if(self.modelLayer) {
        return [(CALayer*)self.modelLayer _textureId];
    } else {
        return [super _textureId];
    }
}
@end
