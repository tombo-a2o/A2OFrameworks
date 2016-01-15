#import <QuartzCore/CAAnimation.h>

@interface CAAnimation(Rendering)
-(float)_scale;
-(BOOL)_isFinished;
-(void)_updateCurrentTime:(CFTimeInterval)currentTime;
@end

@interface CAPropertyAnimation(Rendering)
-(void)_updateProperty:(CALayer*)layer;
-(CGFloat)_interpolateFloat:(float)scale;
-(CATransform3D)_interpolateTransform3D:(float)scale;
-(CGAffineTransform)_interpolateAffineTransform:(float)scale;
-(CGSize)_interpolateSize:(float)scale;
-(CGPoint)_interpolatePoint:(float)scale;
-(CGRect)_interpolateRect:(float)scale;
@end

@interface CABasicAnimation(Rendering)
@end
