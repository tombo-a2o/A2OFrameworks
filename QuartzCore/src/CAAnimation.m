#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CATransaction.h>
#import <AppKit/NSRaise.h>

NSString *const kCATransitionFade = @"fade";
NSString *const kCATransitionMoveIn = @"movein";
NSString *const kCATransitionPush = @"push";
NSString *const kCATransitionReveal = @"reveal";

NSString *const kCATransitionFromLeft = @"left";
NSString *const kCATransitionFromRight = @"right";
NSString *const kCATransitionFromTop = @"top";
NSString *const kCATransitionFromBottom = @"bottom";

@implementation CAAnimation

+animation {
   return [[[self alloc] init] autorelease];
}

-init {
   _duration=[CATransaction animationDuration];
   _timingFunction=[[CATransaction animationTimingFunction] retain];
   _removedOnCompletion=YES;
   return self;
}

-(void)dealloc {
   [_timingFunction release];
   [super dealloc];
}

-copyWithZone:(NSZone *)zone {
   NSUnimplementedMethod();
   return nil;
}

-delegate {
   return _delegate;
}

-(void)setDelegate:object {
   object=[object retain];
   [_delegate release];
   _delegate=object;
}

-(BOOL)isRemovedOnCompletion {
   return _removedOnCompletion;
}

-(void)setRemovedOnCompletion:(BOOL)value {
   _removedOnCompletion=value;
}

-(CAMediaTimingFunction *)timingFunction {
   return _timingFunction;
}

-(void)setTimingFunction:(CAMediaTimingFunction *)value {
   value=[value retain];
   [_timingFunction release];
   _timingFunction=value;
}

-(BOOL)autoreverses {
   return _autoreverses;
}

-(void)setAutoreverses:(BOOL)value {
   _autoreverses=value;
}

-(CFTimeInterval)beginTime {
   return _beginTime;
}

-(void)setBeginTime:(CFTimeInterval)value {
   _beginTime=value;
}

-(CFTimeInterval)duration {
   return _duration;
}

-(void)setDuration:(CFTimeInterval)value {
   _duration=value;
}

-(NSString *)fillMode {
   return _fillMode;
}

-(void)setFillMode:(NSString *)value {
   value=[value copy];
   [_fillMode release];
   _fillMode=value;
}

-(float)repeatCount {
   return _repeatCount;
}

-(void)setRepeatCount:(float)value {
   _repeatCount=value;
}

-(CFTimeInterval)repeatDuration {
   return _repeatDuration;
}

-(void)setRepeatDuration:(CFTimeInterval)value {
   _repeatDuration=value;
}

-(float)speed {
   return _speed;
}

-(void)setSpeed:(float)value {
   _speed=value;
}

-(CFTimeInterval)timeOffset {
   return _timeOffset;
}

-(void)setTimeOffset:(CFTimeInterval)value {
   _timeOffset=value;
}

-(CFTimeInterval)_computedDuration
{
    CFTimeInterval duration = self.duration;
    float repeatCount = self.repeatCount;
    CFTimeInterval repeatDuration = self.repeatDuration;
    BOOL autoreverses = self.autoreverses;
    
    if(repeatCount != 0.0) {
        duration *= repeatCount;
    }
    if(repeatDuration != 0.0) {
        duration = repeatDuration;
    }
    if(autoreverses) {
        duration *= 2;
    }
    return duration;
}

@end
