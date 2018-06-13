/*
 *  CABasicAnimation.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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

-(void)_updateLayer:(CALayer*)layer currentTime:(CFTimeInterval)currentTime {
    [super _updateLayer:layer currentTime:currentTime];

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

    NSValue *currentValue = [layer valueForKeyPath:self.keyPath];
    const char* type = currentValue.objCType;

    [self _updateProperty:layer withValue:[self _interpolate:_fromValue with:_toValue ratio:[self _scale] type:type]];
}

@end
