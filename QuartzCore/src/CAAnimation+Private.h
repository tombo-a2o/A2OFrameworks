#import <QuartzCore/CAAnimation.h>

@interface CAAnimation(Rendering)
-(float)_scale;
-(BOOL)_isFinished;
-(void)_updateLayer:(CALayer*)layer currentTime:(CFTimeInterval)currentTime;
@end

@interface CAPropertyAnimation(Rendering)
-(NSValue*)_interpolate:(NSValue*)x with:(NSValue*)y ratio:(float)ratio type:(const char*)type;
-(void)_updateProperty:(CALayer*)layer withValue:(id)value;
@end

@interface CABasicAnimation(Rendering)
@end
