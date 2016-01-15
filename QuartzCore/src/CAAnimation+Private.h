#import <QuartzCore/CAAnimation.h>

@interface CAAnimation(Rendering)
-(CFTimeInterval)_computedDuration;
-(float)_calcScale:(CFTimeInterval)currentTime;
@end

@interface CAPropertyAnimation(Rendering)
-(void)_updateProperty:(CALayer*)layer currentTime:(CFTimeInterval)currentTime;
-(CGFloat)_interpolateFloat:(float)scale;
-(CATransform3D)_interpolateTransform3D:(float)scale;
-(CGAffineTransform)_interpolateAffineTransform:(float)scale;
-(CGSize)_interpolateSize:(float)scale;
-(CGPoint)_interpolatePoint:(float)scale;
-(CGRect)_interpolateRect:(float)scale;
@end

@interface CABasicAnimation(Rendering)
@end
