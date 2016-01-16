#import <QuartzCore/CAAnimation.h>

@interface CAAnimation(Rendering)
-(float)_scale;
-(BOOL)_isFinished;
-(void)_updateTime:(CFTimeInterval)currentTime;
@end

@interface CAPropertyAnimation(Rendering)
@end

@interface CABasicAnimation(Rendering)
@end
