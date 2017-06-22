/*
 * Copyright (c) 2011, The Iconfactory. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of The Iconfactory nor the names of its contributors may
 *    be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE ICONFACTORY BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <UIKit/UIAccelerometer.h>
#import "UIAcceleration+UIPrivate.h"
#import <emscripten/emscripten.h>
#import <emscripten/html5.h>

static UIAccelerometer *_theAccelerometer = nil;

@implementation UIAccelerometer

+ (UIAccelerometer *)sharedAccelerometer
{
    if(!_theAccelerometer) {
        _theAccelerometer = [[UIAccelerometer alloc] init];
    }
    return _theAccelerometer;
}

static EM_BOOL motionCallback(int eventType, const EmscriptenDeviceMotionEvent *deviceMotionEvent, void *userData)
{
    UIAccelerometer *accelerometer = (__bridge UIAccelerometer*)userData;
    [accelerometer _motionEvent:deviceMotionEvent];
    return TRUE;
}

- (void)setDelegate:(id<UIAccelerometerDelegate>)delegate
{
    _delegate = delegate;

    // FIXME: Need to share callback function with motion event listener
    if(delegate) {
        emscripten_set_devicemotion_callback((__bridge void *)self, TRUE, motionCallback);
    } else {
        emscripten_set_devicemotion_callback((__bridge void *)self, TRUE, NULL);
    }
}

- (void)_motionEvent:(EmscriptenDeviceMotionEvent*)deviceMotionEvent
{
    UIAcceleration *acceleration = [[UIAcceleration alloc] init];
    NSString *userAgent = [NSString stringWithUTF8String:emscripten_run_script_string("navigator.userAgent")];

    int sign = -1;
    if([userAgent containsString:@"iPhone"] || [userAgent containsString:@"iPad"] || [userAgent containsString:@"iPod"]) {
        sign = 1;
    }

    // Whereas unit of HTML MotionEvent is m/s^2, one of UIAccelerationValue is "gravity".
#define GRAVITY 9.80619920
    acceleration.x = sign * deviceMotionEvent->accelerationIncludingGravityX / GRAVITY;
    acceleration.y = sign * deviceMotionEvent->accelerationIncludingGravityY / GRAVITY;
    acceleration.z = sign * deviceMotionEvent->accelerationIncludingGravityZ / GRAVITY;
    acceleration.timestamp = deviceMotionEvent->timestamp;
    [_delegate  accelerometer:self didAccelerate:acceleration];
}

@end
