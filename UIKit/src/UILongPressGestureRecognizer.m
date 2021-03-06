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

#import <UIKit/UILongPressGestureRecognizer.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UITouchEvent.h"
#import <UIKit/UITouch.h>
#import <Foundation/NSRunLoop.h>

static CGFloat DistanceBetweenTwoPoints(CGPoint A, CGPoint B)
{
    CGFloat a = B.x - A.x;
    CGFloat b = B.y - A.y;
    return sqrtf((a*a) + (b*b));
}

@implementation UILongPressGestureRecognizer {
    CGPoint _beginLocation;
    BOOL _waiting;
}

- (id)initWithTarget:(id)target action:(SEL)action
{
    if ((self=[super initWithTarget:target action:action])) {
        _allowableMovement = 10;
        _minimumPressDuration = 0.5;
        _numberOfTapsRequired = 0;
        _numberOfTouchesRequired = 1;
    }
    return self;
}

- (void)_beginGesture
{
    _waiting = NO;
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
        NSLog(@"%s ???", __FUNCTION__);
        //UIApplicationSendStationaryTouches();
    }
}

- (void)_cancelWaiting
{
    if (_waiting) {
        _waiting = NO;
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_beginGesture) object:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([event isKindOfClass:[UITouchEvent class]]) {
        UITouchEvent *touchEvent = (UITouchEvent *)event;
        
        if (touchEvent.touchEventGesture == UITouchEventGestureRightClick) {
            self.state = UIGestureRecognizerStateBegan;
        } else if (touchEvent.touchEventGesture == UITouchEventGestureNone) {
            if (!_waiting && self.state == UIGestureRecognizerStatePossible && touchEvent.touch.tapCount >= self.numberOfTapsRequired) {
                _beginLocation = [touchEvent.touch locationInView:self.view];
                _waiting = YES;
                [self performSelector:@selector(_beginGesture) withObject:nil afterDelay:self.minimumPressDuration];
            }
        } else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    const CGFloat distance = DistanceBetweenTwoPoints([touch locationInView:self.view], _beginLocation);

    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        if (distance <= self.allowableMovement) {
            self.state = UIGestureRecognizerStateChanged;
        } else {
            self.state = UIGestureRecognizerStateCancelled;
        }
    } else if (self.state == UIGestureRecognizerStatePossible && distance > self.allowableMovement) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateEnded;
    } else {
        [self _cancelWaiting];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateCancelled;
    } else {
        [self _cancelWaiting];
    }
}

- (void)reset
{
    [self _cancelWaiting];
    [super reset];
}

@end
