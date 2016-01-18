#import <QuartzCore/CAAnimation.h>

@interface CAAnimation(Rendering)
-(float)_scale;
-(BOOL)_isFinished;
-(void)_updateTime:(CFTimeInterval)currentTime;
@end

@interface CAPropertyAnimation(Rendering)
-(NSValue*)_interpolate:(NSValue*)x with:(NSValue*)y ratio:(float)ratio;
-(void)_updateProperty:(id)value;
@end

@interface CABasicAnimation(Rendering)
@end
