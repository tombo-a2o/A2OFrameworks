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

#import <UIKit/UIPanGestureRecognizer.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UITouchEvent.h"
#import <UIKit/UITouch.h>

@implementation UIPanGestureRecognizer {
    CGPoint _translation;
    CGPoint _velocity;
    CGPoint _prev;
    NSTimeInterval _lastMovementTime;
}

- (id)initWithTarget:(id)target action:(SEL)action
{
    if ((self=[super initWithTarget:target action:action])) {
        _minimumNumberOfTouches = 1;
        _maximumNumberOfTouches = NSUIntegerMax;
        _translation = CGPointZero;
        _velocity = CGPointZero;
    }
    return self;
}

- (CGPoint)translationInView:(UIView *)view
{
    return _translation;
}

- (void)setTranslation:(CGPoint)translation inView:(UIView *)view
{
    _velocity = CGPointZero;
    _translation = translation;
}

- (BOOL)_translate:(CGPoint)delta withEvent:(UIEvent *)event
{
    const NSTimeInterval timeDiff = event.timestamp - _lastMovementTime;

    if (!CGPointEqualToPoint(delta, CGPointZero) && timeDiff > 0) {
        _translation.x += delta.x;
        _translation.y += delta.y;
        _velocity.x = delta.x / timeDiff;
        _velocity.y = delta.y / timeDiff;
        _lastMovementTime = event.timestamp;
        return YES;
    } else {
        return NO;
    }
}

- (void)reset
{
    [super reset];
    _translation = CGPointZero;
    _velocity = CGPointZero;
}

- (CGPoint)velocityInView:(UIView *)view
{
    return _velocity;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStatePossible) {
        if ([event isKindOfClass:[UITouchEvent class]]) {
            UITouchEvent *touchEvent = (UITouchEvent *)event;
            
            if (touchEvent.touchEventGesture == UITouchEventGestureNone) {
                // OK. Do nothing
            } else if(touchEvent.touchEventGesture != UITouchEventGestureBegin) {
                self.state = UIGestureRecognizerStateFailed;
            }
        }
    }
}

- (CGPoint)calcDelta:(UITouch*)touch
{
    CGPoint delta;
    CGPoint prev = [touch previousLocationInView:self.view];
    CGPoint current = [touch locationInView:self.view];
    delta.x = current.x - prev.x;
    delta.y = current.y - prev.y;
    return delta;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([event isKindOfClass:[UITouchEvent class]]) {
        UITouchEvent *touchEvent = (UITouchEvent *)event;
        
        CGPoint delta;
        if (touchEvent.touchEventGesture == UITouchEventGestureNone || touchEvent.touchEventGesture == UITouchEventGesturePan) {
            if(touchEvent.touchEventGesture == UITouchEventGestureNone) {
                delta = [self calcDelta:[touches anyObject]];
            } else {
                delta = touchEvent.translation;
            }
            
            if (self.state == UIGestureRecognizerStatePossible) {
                _lastMovementTime = touchEvent.timestamp;
                [self setTranslation:delta inView:touchEvent.touch.view];
                self.state = UIGestureRecognizerStateBegan;
            } else if ([self _translate:delta withEvent:event]) {
                self.state = UIGestureRecognizerStateChanged;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        if ([event isKindOfClass:[UITouchEvent class]]) {
            UITouchEvent *touchEvent = (UITouchEvent *)event;
            
            if (touchEvent.touchEventGesture == UITouchEventGestureNone) {
                [self _translate:[self calcDelta:[touches anyObject]] withEvent:touchEvent];
            } else {
                [self _translate:touchEvent.translation withEvent:touchEvent];
            }
            self.state = UIGestureRecognizerStateEnded;
        } else {
            self.state = UIGestureRecognizerStateCancelled;
        }
    } else if(self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateCancelled;
    }
}

@end
