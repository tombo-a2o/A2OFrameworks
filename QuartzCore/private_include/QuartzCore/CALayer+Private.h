#import <QuartzCore/CALayer.h>
#import <QuartzCore/CALayerContext.h>
#import <OpenGLES/ES2/gl.h>

@interface CALayer(private)
-(void)_setContext:(CALayerContext *)context;
-(void)_setTextureId:(GLuint)value;
-(GLuint)_textureId;
-(void)_setImageRef:(CGImageRef)value;
-(CGImageRef)_imageRef;
-(CGFloat)textureSize;
-(BOOL)_flipTexture;
-(void)_updateAnimations:(CFTimeInterval)currentTime;
-(void)_generatePresentationLayer;
-(NSArray*)_zOrderedSublayers;
@end
