#import <QuartzCore/CAAnimation.h>

@interface CAAnimation(Rendering)
-(CFTimeInterval)_computedDuration;
@end

@interface CAPropertyAnimation(Rendering)
-(void)_updateProperty:(CALayer*)layer;
@end

@interface CABasicAnimation(Rendering)
-(CGFloat)_interpolateFloat:(CFTimeInterval)currentTime;
-(CATransform3D)_interpolateTransform3D:(CFTimeInterval)currentTime;
-(CGAffineTransform)_interpolateAffineTransform:(CFTimeInterval)currentTime;
-(CGSize)_interpolateSize:(CFTimeInterval)currentTime;
-(CGPoint)_interpolatePoint:(CFTimeInterval)currentTime;
-(CGRect)_interpolateRect:(CFTimeInterval)currentTime;
@end
