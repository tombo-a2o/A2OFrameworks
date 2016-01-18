#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CATransform3D.h>
#import <QuartzCore/CALayer.h>
#import "CAAnimation+Private.h"

@implementation CABasicAnimation

-fromValue {
   return _fromValue;
}

-(void)setFromValue:value {
   value=[value retain];
   [_fromValue release];
   _fromValue=value;
}

-toValue {
   return _toValue;
}

-(void)setToValue:value {
   value=[value retain];
   [_toValue release];
   _toValue=value;
}

-byValue {
   return _byValue;
}

-(void)setByValue:value {
   value=[value retain];
   [_byValue release];
   _byValue=value;
}

-(void)_updateTime:(CFTimeInterval)currentTime {
    [super _updateTime:currentTime];
    
    CALayer *layer = (CALayer*)self.delegate;

    if(!_toValue && !_fromValue) {
        // not correct
        _fromValue = [[layer.presentationLayer valueForKey:_keyPath] retain];
        _toValue = [[layer valueForKey:_keyPath] retain];
    } else if(!_toValue) {
        _toValue = [[layer valueForKey:_keyPath] retain];
    } else if(!_fromValue) {
        _fromValue = [[layer valueForKey:_keyPath] retain];
    }
    if(_byValue) {
        NSAssert(0, @"byValue is not implemented");
    }
    
    [self _updateProperty:[self _interpolate:_fromValue with:_toValue ratio:[self _scale]]];
}

@end
