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

// touch handling logic is extracted from UIKitView

#import "UIEventHandler.h"
#import <UIKit/UIApplication.h>
#import "UIScreen+UIPrivate.h"
#import "UIWindow+UIPrivate.h"
#import <UIKit/UIImage.h>
#import <UIKit/UIImageView.h>
#import <UIKit/UIColor.h>
#import "UITouchEvent.h"
#import "UITouch+UIPrivate.h"
#import "UIKey.h"
#import "UINSResponderShim.h"
#import "UIViewControllerAppKitIntegration.h"
#import <QuartzCore/CALayer.h>
#import <emscripten/html5.h>

/*
 An older design of Chameleon had the singlular multi-touch event living in UIApplication because that made sense at the time.
 However it was needlessly awkward to send events from here to the UIApplication and then have to decode them all again, etc.
 It seemingly gained nothing. Also, while I don't know how UIKit would handle this situation, I'm not sure it makes sense to
 have a single multitouch sequence span multiple screens anyway. There are some cases where that might kinda make sense, but
 I'm having some doubts that this is how iOS would be setup anyway. (It's hard to really know without some deep digging since
 I don't know if iOS even supports touch events on any screen other than the main one anyway, but it doesn't matter right now.)

 The benefit of having it here is that this is right where the touches happen. There's no ambiguity about exactly which
 screen/NSView the event occured on, and there's no need to pass that info around deep into other parts of the code, either.
 It can be dealt with here and now and life can go on and things don't have to get weirdly complicated deep down the rabbit
 hole. In theory.
 */

@interface UIEventHandler () <UINSResponderShimDelegate>
@end

@implementation UIEventHandler {
    UITouchEvent *_touchEvent;
    UITouch *_mouseMoveTouch;
    __weak UIScreen *_screen;
}

static EM_BOOL sendTouchEvnetToApp(int eventType, const EmscriptenTouchEvent *touchEvent, void *userData) {
    UIEventHandler *handler = (__bridge UIEventHandler*)userData;
    // NSLog(@"event %d", eventType);

    // handle only single touch
    if(touchEvent->numTouches == 0) return NO;

    switch(eventType) {
    // case EMSCRIPTEN_EVENT_TOUCHSTART:
    //     [handler mouseDown:touchEvent];
    //     break;
    // case EMSCRIPTEN_EVENT_TOUCHEND:
    //     [handler mouseUp:touchEvent];
    //     break;
    // case EMSCRIPTEN_EVENT_TOUCHMOVE:
    //     [handler mouseMoved:touchEvent];
    //     break;
    // case EMSCRIPTEN_EVENT_TOUCHCANCEL:
    //     // FIX ME
    //     [handler mouseUp:touchEvent];
    //     break;
    default:
        return NO;
    }
    return YES;
}

static EM_BOOL sendMouseEventToApp(int eventType, const EmscriptenMouseEvent *mouseEvent, void *userData) {
    UIEventHandler *handler = (__bridge UIEventHandler*)userData;
//    NSLog(@"event %d", eventType);

    __block SEL sel;
    switch(eventType) {
    case EMSCRIPTEN_EVENT_MOUSEDOWN:
        sel = @selector(mouseDown:);
        break;
    case EMSCRIPTEN_EVENT_MOUSEUP:
        sel = @selector(mouseUp:);
        break;
    case EMSCRIPTEN_EVENT_MOUSEMOVE:
        sel = @selector(mouseMove:);
        break;
    case EMSCRIPTEN_EVENT_MOUSEENTER:
        sel = @selector(mouseEntered:);
        break;
    case EMSCRIPTEN_EVENT_MOUSELEAVE:
        sel = @selector(mouseExited:);
        break;
    default:
        return NO;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [handler performSelector:sel withObject:(__bridge id)mouseEvent];
    });
    return YES;
}

static EM_BOOL sendWheelEventToApp(int eventType, const EmscriptenWheelEvent *wheelEvent, void *userData) {
    UIEventHandler *handler = (__bridge UIEventHandler*)userData;
    assert(eventType == EMSCRIPTEN_EVENT_WHEEL);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [handler scrollWheel:wheelEvent];
    });
}

- (id)initWithScreen:(UIScreen*)screen
{
    if ((self = [super init])) {
        _mouseMoveTouch = [[UITouch alloc] init];
        _screen = screen;

        emscripten_set_touchstart_callback(NULL, (__bridge void *)self, TRUE, sendTouchEvnetToApp);
        emscripten_set_touchend_callback(NULL, (__bridge void *)self, TRUE, sendTouchEvnetToApp);
        emscripten_set_touchmove_callback(NULL, (__bridge void *)self, TRUE, sendTouchEvnetToApp);
        emscripten_set_touchcancel_callback(NULL, (__bridge void *)self, TRUE, sendTouchEvnetToApp);

        emscripten_set_click_callback(NULL, (__bridge void *)self, TRUE, sendMouseEventToApp);
        emscripten_set_mousedown_callback(NULL, (__bridge void *)self, TRUE, sendMouseEventToApp);
        emscripten_set_mouseup_callback(NULL, (__bridge void *)self, TRUE, sendMouseEventToApp);
        emscripten_set_mousemove_callback(NULL, (__bridge void *)self, TRUE, sendMouseEventToApp);
        emscripten_set_mouseenter_callback(NULL, (__bridge void *)self, TRUE, sendMouseEventToApp);
        emscripten_set_mouseleave_callback(NULL, (__bridge void *)self, TRUE, sendMouseEventToApp);
        
        emscripten_set_wheel_callback(NULL, (__bridge void *)self, TRUE, sendWheelEventToApp);
    }
    return self;
}

- (UIView *)hitTestUIView:(CGPoint)point
{
    NSMutableArray *sortedWindows = [_UIScreen.windows mutableCopy];
    [sortedWindows sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"windowLevel" ascending:NO]]];

    for (UIWindow *window in sortedWindows) {
        const CGPoint windowPoint = [window convertPoint:point fromWindow:nil];
        UIView *hitView = [window hitTest:windowPoint withEvent:nil];
        if (hitView) return hitView;
    }

    return nil;
}

#pragma mark touch utilities

- (UITouch *)touchForEvent:(EmscriptenMouseEvent *)theEvent
{
    const CGPoint location = [_screen _convertCanvasLocation:theEvent->canvasX y:theEvent->canvasY];

    UITouch *touch = [[UITouch alloc] init];
    touch.view = [self hitTestUIView:location];
    touch.locationOnScreen = location;
    touch.timestamp = theEvent->timestamp;

    return touch;
}

- (void)updateTouchLocation:(UITouch *)touch withEvent:(EmscriptenMouseEvent *)theEvent
{
    touch.locationOnScreen = [_screen _convertCanvasLocation:theEvent->canvasX y:theEvent->canvasY];
    touch.timestamp = theEvent->timestamp;
}

- (void)cancelTouchesInView:(UIView *)view
{
    if (_touchEvent && _touchEvent.touch.phase != UITouchPhaseEnded && _touchEvent.touch.phase != UITouchPhaseCancelled) {
        if (!view || [view isDescendantOfView:_touchEvent.touch.view]) {
            _touchEvent.touch.phase = UITouchPhaseCancelled;
            _touchEvent.touch.timestamp = [NSDate timeIntervalSinceReferenceDate];
            [[UIApplication sharedApplication] sendEvent:_touchEvent];
            [_touchEvent endTouchEvent];
            _touchEvent = nil;
        }
    }
}

- (void)sendStationaryTouches
{
    if (_touchEvent && _touchEvent.touch.phase != UITouchPhaseEnded && _touchEvent.touch.phase != UITouchPhaseCancelled) {
        _touchEvent.touch.phase = UITouchPhaseStationary;
        _touchEvent.touch.timestamp = [NSDate timeIntervalSinceReferenceDate];
        [[UIApplication sharedApplication] sendEvent:_touchEvent];
    }
}

#pragma mark pseudo touch handling

- (void)mouseDown:(EmscriptenMouseEvent *)theEvent
{
    // this is a special case to cancel any existing touches (as far as the client code is concerned) if the left
    // mouse button is pressed mid-gesture. the reason is that sometimes when using a magic mouse a user will intend
    // to click but if their finger moves against the surface ever so slightly, it will trigger a touch gesture to
    // begin instead. without this, the fact that we're in a touch gesture phase effectively overrules everything
    // else and clicks end up not getting registered. I don't think it's right to allow clicks to pass through when
    // we're in a gesture state since that'd be somewhat like a multitouch scenerio on an actual iOS device and we
    // are not really supporting anything like that at the moment.
    if (_touchEvent) {
        _touchEvent.touch.phase = UITouchPhaseCancelled;
        [self updateTouchLocation:_touchEvent.touch withEvent:theEvent];

        [[UIApplication sharedApplication] sendEvent:_touchEvent];

        [_touchEvent endTouchEvent];
        _touchEvent = nil;
    }

    if (!_touchEvent) {
        _touchEvent = [[UITouchEvent alloc] initWithTouch:[self touchForEvent:theEvent]];
        _touchEvent.touchEventGesture = UITouchEventGestureNone;
        _touchEvent.touch.tapCount = 1;

        [[UIApplication sharedApplication] sendEvent:_touchEvent];
    }
}

- (void)mouseUp:(EmscriptenMouseEvent *)theEvent
{
    if (_touchEvent && _touchEvent.touchEventGesture == UITouchEventGestureNone) {
        _touchEvent.touch.phase = UITouchPhaseEnded;
        [self updateTouchLocation:_touchEvent.touch withEvent:theEvent];

        [[UIApplication sharedApplication] sendEvent:_touchEvent];

        [_touchEvent endTouchEvent];
        _touchEvent = nil;
    }
}

- (void)mouseDragged:(EmscriptenMouseEvent *)theEvent
{
    if (_touchEvent && _touchEvent.touchEventGesture == UITouchEventGestureNone) {
        _touchEvent.touch.phase = UITouchPhaseMoved;
        [self updateTouchLocation:_touchEvent.touch withEvent:theEvent];

        [[UIApplication sharedApplication] sendEvent:_touchEvent];
    }
}

// #pragma mark touch gestures
// 
// - (void)beginGestureWithEvent:(NSEvent *)theEvent
// {
//     if (!_touchEvent) {
//         _touchEvent = [[UITouchEvent alloc] initWithTouch:[self touchForEvent:theEvent]];
//         _touchEvent.touchEventGesture = UITouchEventGestureBegin;
// 
//         [[UIApplication sharedApplication] sendEvent:_touchEvent];
//     }
// }
// 
// - (void)endGestureWithEvent:(NSEvent *)theEvent
// {
//     if (_touchEvent && _touchEvent.touchEventGesture != UITouchEventGestureNone) {
//         _touchEvent.touch.phase = UITouchPhaseEnded;
//         [self updateTouchLocation:_touchEvent.touch withEvent:theEvent];
// 
//         [[UIApplication sharedApplication] sendEvent:_touchEvent];
// 
//         [_touchEvent endTouchEvent];
//         _touchEvent = nil;
//     }
// }
// 
// - (void)rotateWithEvent:(NSEvent *)theEvent
// {
//     if (_touchEvent && (_touchEvent.touchEventGesture == UITouchEventGestureBegin || _touchEvent.touchEventGesture == UITouchEventGestureRotate)) {
//         _touchEvent.touch.phase = UITouchPhaseMoved;
//         [self updateTouchLocation:_touchEvent.touch withEvent:theEvent];
// 
//         _touchEvent.touchEventGesture = UITouchEventGestureRotate;
//         _touchEvent.rotation = [theEvent rotation];
// 
//         [[UIApplication sharedApplication] sendEvent:_touchEvent];
//     }
// }
// 
// - (void)magnifyWithEvent:(NSEvent *)theEvent
// {
//     if (_touchEvent && (_touchEvent.touchEventGesture == UITouchEventGestureBegin || _touchEvent.touchEventGesture == UITouchEventGesturePinch)) {
//         _touchEvent.touch.phase = UITouchPhaseMoved;
//         [self updateTouchLocation:_touchEvent.touch withEvent:theEvent];
// 
//         _touchEvent.touchEventGesture = UITouchEventGesturePinch;
//         _touchEvent.magnification = [theEvent magnification];
// 
//         [[UIApplication sharedApplication] sendEvent:_touchEvent];
//     }
// }
// 
// - (void)swipeWithEvent:(NSEvent *)theEvent
// {
//     // it seems as if the swipe gesture actually is discrete as far as OSX is concerned and does not occur between gesture begin/end messages
//     // which is sort of different.. but.. here we go. :) As a result, I'll require there to not be an existing touchEvent in play before a
//     // swipe gesture is recognized.
// 
//     if (!_touchEvent) {
//         UITouchEvent *swipeEvent = [[UITouchEvent alloc] initWithTouch:[self touchForEvent:theEvent]];
//         swipeEvent.touchEventGesture = UITouchEventGestureSwipe;
//         swipeEvent.translation = CGPointMake([theEvent deltaX], [theEvent deltaY]);
//         [[UIApplication sharedApplication] sendEvent:swipeEvent];
//         [swipeEvent endTouchEvent];
//     }
// }

#pragma mark discrete mouse events

- (void)rightMouseDown:(EmscriptenMouseEvent *)theEvent
{
    if (!_touchEvent) {
        UITouchEvent *mouseEvent = [[UITouchEvent alloc] initWithTouch:[self touchForEvent:theEvent]];
        mouseEvent.touchEventGesture = UITouchEventGestureRightClick;
        mouseEvent.touch.tapCount = 1;
        [[UIApplication sharedApplication] sendEvent:mouseEvent];
        [mouseEvent endTouchEvent];
    }
}

- (void)mouseMoved:(EmscriptenMouseEvent *)theEvent
{
    if (!_touchEvent) {
        const CGPoint location = [_screen _convertCanvasLocation:theEvent->canvasX y:theEvent->canvasY];
        UIView *currentView = [self hitTestUIView:location];
        UIView *previousView = _mouseMoveTouch.view;

        _mouseMoveTouch.timestamp = theEvent->timestamp;
        _mouseMoveTouch.locationOnScreen = location;
        _mouseMoveTouch.phase = UITouchPhaseMoved;

        if (previousView && previousView != currentView) {
            UITouchEvent *moveEvent = [[UITouchEvent alloc] initWithTouch:_mouseMoveTouch];
            moveEvent.touchEventGesture = UITouchEventGestureMouseMove;
            [[UIApplication sharedApplication] sendEvent:moveEvent];
            [moveEvent endTouchEvent];

            UITouchEvent *exitEvent = [[UITouchEvent alloc] initWithTouch:_mouseMoveTouch];
            exitEvent.touchEventGesture = UITouchEventGestureMouseExited;
            [[UIApplication sharedApplication] sendEvent:exitEvent];
            [exitEvent endTouchEvent];
        }

        _mouseMoveTouch.view = currentView;

        if (currentView) {
            if (currentView != previousView) {
                UITouchEvent *enterEvent = [[UITouchEvent alloc] initWithTouch:_mouseMoveTouch];
                enterEvent.touchEventGesture = UITouchEventGestureMouseEntered;
                [[UIApplication sharedApplication] sendEvent:enterEvent];
                [enterEvent endTouchEvent];
            }

            UITouchEvent *moveEvent = [[UITouchEvent alloc] initWithTouch:_mouseMoveTouch];
            moveEvent.touchEventGesture = UITouchEventGestureMouseMove;
            [[UIApplication sharedApplication] sendEvent:moveEvent];
            [moveEvent endTouchEvent];
        }
    }
}

- (void)mouseEntered:(EmscriptenMouseEvent *)theEvent
{
    [self mouseMoved:theEvent];
}

- (void)mouseExited:(EmscriptenMouseEvent *)theEvent
{
    if (!_touchEvent) {
        _mouseMoveTouch.phase = UITouchPhaseMoved;
        [self updateTouchLocation:_mouseMoveTouch withEvent:theEvent];

        UITouchEvent *moveEvent = [[UITouchEvent alloc] initWithTouch:_mouseMoveTouch];
        moveEvent.touchEventGesture = UITouchEventGestureMouseMove;
        [[UIApplication sharedApplication] sendEvent:moveEvent];
        [moveEvent endTouchEvent];

        UITouchEvent *exitEvent = [[UITouchEvent alloc] initWithTouch:_mouseMoveTouch];
        exitEvent.touchEventGesture = UITouchEventGestureMouseExited;
        [[UIApplication sharedApplication] sendEvent:exitEvent];
        [exitEvent endTouchEvent];

        _mouseMoveTouch.view = nil;
    }
}

#pragma mark scroll/pan gesture

- (void)scrollWheel:(EmscriptenWheelEvent *)theEvent
{
    double dx, dy;

    dx = theEvent->deltaX;
    dy = -theEvent->deltaY;

    CGPoint translation = CGPointMake(-dx, -dy);

    // if this happens within an actual OSX gesture sequence, it is a pan touch gesture event
    // if it happens outside of a gesture, it is a normal mouse event instead
    // if it somehow happens during any other touch sequence, ignore it (someone might be click-dragging with the mouse and also using a wheel)

    if (_touchEvent) {
        if (_touchEvent.touchEventGesture == UITouchEventGestureBegin || _touchEvent.touchEventGesture == UITouchEventGesturePan) {
            _touchEvent.touch.phase = UITouchPhaseMoved;
            [self updateTouchLocation:_touchEvent.touch withEvent:theEvent];

            _touchEvent.touchEventGesture = UITouchEventGesturePan;
            _touchEvent.translation = translation;

            [[UIApplication sharedApplication] sendEvent:_touchEvent];
        }
    } else {
        UITouchEvent *mouseEvent = [[UITouchEvent alloc] initWithTouch:[self touchForEvent:theEvent]];
        mouseEvent.touchEventGesture = UITouchEventGestureScrollWheel;
        mouseEvent.translation = translation;
        [[UIApplication sharedApplication] sendEvent:mouseEvent];
        [mouseEvent endTouchEvent];
    }
}

#pragma keyboard events

- (void)keyDown:(NSEvent *)theEvent
{
    // UIKey *key = [[UIKey alloc] initWithNSEvent:theEvent];
    // 
    // // this is not the correct way to handle keys.. iOS 7 finally added a way to handle key commands
    // // but this was implemented well before that. for now, this gets what we want to happen to happen.
    // 
    // if (key.action) {
    //     [self doCommandBySelector:key.action];
    // } else {
    //     [super keyDown:theEvent];
    // }
}

@end
