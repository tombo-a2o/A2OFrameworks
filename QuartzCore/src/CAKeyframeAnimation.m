#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CALayer.h>
#import "CAAnimation+Private.h"

NSString * const kCAAnimationRotateAuto = @"kCAAnimationRotateAuto";
NSString * const kCAAnimationRotateAutoReverse = @"kCAAnimationRotateAutoReverse";
NSString * const kCAAnimationLinear = @"kCAAnimationLinear";
NSString * const kCAAnimationDiscrete = @"kCAAnimationDiscrete";
NSString * const kCAAnimationPaced = @"kCAAnimationPaced";
NSString * const kCAAnimationCubic = @"kCAAnimationCubic";
NSString * const kCAAnimationCubicPaced = @"kCAAnimationCubicPaced";

@implementation CAKeyframeAnimation

-(void)_updateTime:(CFTimeInterval)currentTime {
    [super _updateTime:currentTime];
    
    CALayer *layer = (CALayer*)self.delegate;
    
    if(_path) {
        NSAssert(0, @"path is not implemented");
    }
    if(_calculationMode != kCAAnimationDiscrete) {
        NSAssert(0, @"calculationMode other than kCAAnimationDiscrete is not implemented");
    }
    
    if(!_keyTimes) {
        if(_calculationMode == kCAAnimationDiscrete) {
            int count = [_values count]+1;
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:count];
            for(int i = 0; i < count; i++) {
                [arr addObject:[NSNumber numberWithFloat:1.0 * i / (count-1)]];
            }
            _keyTimes = [arr copy];
        }
    }
    
    NSValue *value = nil;
    if(_calculationMode == kCAAnimationDiscrete) {
        assert([[_keyTimes firstObject] floatValue] == 0.0);
        assert([[_keyTimes lastObject] floatValue] == 1.0);
        for(int i = 0; i < [_values count]; i++) {
            float f =  [[_keyTimes objectAtIndex:i+1] floatValue];
            if(self._scale <= f) {
                value = [_values objectAtIndex:i];
                break;
            }
        }
    }

    [self _updateProperty:value];
}

@end
