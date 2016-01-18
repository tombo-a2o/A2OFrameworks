#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CATransaction.h>
#import <QuartzCore/CALayer.h>
#import <AppKit/NSRaise.h>

#import "CAMediaTimingFunction+Private.h"

NSString *const kCATransitionFade = @"fade";
NSString *const kCATransitionMoveIn = @"movein";
NSString *const kCATransitionPush = @"push";
NSString *const kCATransitionReveal = @"reveal";

NSString *const kCATransitionFromLeft = @"left";
NSString *const kCATransitionFromRight = @"right";
NSString *const kCATransitionFromTop = @"top";
NSString *const kCATransitionFromBottom = @"bottom";

@implementation CAAnimation {
    float _scale;
    CFTimeInterval _currentTime;
    CFTimeInterval _totalDuration;
    BOOL _started;
}

+animation {
   return [[[self alloc] init] autorelease];
}

-init {
   _duration = [CATransaction animationDuration];
   _timingFunction = [[CATransaction animationTimingFunction] retain];
   _removedOnCompletion = YES;
   _started = NO;
   [self _updateTotalDuration];
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
   value = [value retain];
   [_timingFunction release];
   _timingFunction = value;
}

-(BOOL)autoreverses {
   return _autoreverses;
}

-(void)setAutoreverses:(BOOL)value {
   _autoreverses=value;
   [self _updateTotalDuration];
}

-(CFTimeInterval)beginTime {
   return _beginTime;
}

-(void)setBeginTime:(CFTimeInterval)value {
   _beginTime = value;
}

-(CFTimeInterval)duration {
   return _duration;
}

-(void)setDuration:(CFTimeInterval)value {
   _duration = value;
   [self _updateTotalDuration];
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
   _repeatCount = value;
   [self _updateTotalDuration];
}

-(CFTimeInterval)repeatDuration {
   return _repeatDuration;
}

-(void)setRepeatDuration:(CFTimeInterval)value {
   _repeatDuration = value;
   [self _updateTotalDuration];
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

- (void)runActionForKey:(NSString *)key object:(id)object arguments:(NSDictionary *)dict {
    CALayer *layer = (CALayer*)object;
    
    [layer addAnimation:self forKey:key];
}

-(void)_updateLayer:(CALayer*)layer currentTime:(CFTimeInterval)currentTime {
    assert(_currentTime < currentTime);
    
    if(_beginTime == 0.0) {
        _beginTime = currentTime;
    }
    
    _currentTime = currentTime;
    [self _updateScale];
}

-(void)_updateTotalDuration
{
    _totalDuration = _duration;
    
    if(_repeatCount != 0.0) {
        _totalDuration *= _repeatCount;
    }
    if(_repeatDuration != 0.0) {
        _totalDuration = _repeatDuration;
    }
    if(_autoreverses) {
        _totalDuration *= 2;
    }
}

-(float)_scale
{
    return _scale;
}

-(void)_updateScale
{
    CFTimeInterval delta = _currentTime - _beginTime;
    
    if(!_started) {
        _started = YES;
        if([self.delegate respondsToSelector:@selector(animationDidStart:)]) {
            [self.delegate animationDidStart:self];
        }
    }
    
    if(delta > _totalDuration) {
        _scale = 1.0;
        _fillMode = kCAFillModeRemoved;
        if([self.delegate respondsToSelector:@selector(animationDidStop:finished:)]) {
            [self.delegate animationDidStop:self finished:YES];
        }
        return;
    }
    
    double zeroToOne = delta / _duration;
    int count = (int)zeroToOne;
    zeroToOne -= count;
    if(_autoreverses && (count % 2) == 1) {
        zeroToOne = 1 - zeroToOne;
    }
    
    CAMediaTimingFunction *function = _timingFunction;
    if(function == nil) {
        function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
    
    _scale = [function _solveYFor:zeroToOne];
}

-(BOOL)_isFinished
{
    return _fillMode == kCAFillModeRemoved;
}
@end
