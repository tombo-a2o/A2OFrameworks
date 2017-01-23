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

#import <UIKit/UIKit.h>
#import "UIDevice+UIPrivate.h"
#import "UIScreen+UIPrivate.h"
#import "UIWindow+UIPrivate.h"
#import "UIBackgroundTask.h"
#import "UIEventHandler.h"
#import <emscripten/html5.h>
#import <emscripten/trace.h>

NSString *const UIApplicationWillChangeStatusBarOrientationNotification = @"UIApplicationWillChangeStatusBarOrientationNotification";
NSString *const UIApplicationDidChangeStatusBarOrientationNotification = @"UIApplicationDidChangeStatusBarOrientationNotification";
NSString *const UIApplicationWillEnterForegroundNotification = @"UIApplicationWillEnterForegroundNotification";
NSString *const UIApplicationWillTerminateNotification = @"UIApplicationWillTerminateNotification";
NSString *const UIApplicationWillResignActiveNotification = @"UIApplicationWillResignActiveNotification";
NSString *const UIApplicationDidEnterBackgroundNotification = @"UIApplicationDidEnterBackgroundNotification";
NSString *const UIApplicationDidBecomeActiveNotification = @"UIApplicationDidBecomeActiveNotification";
NSString *const UIApplicationDidFinishLaunchingNotification = @"UIApplicationDidFinishLaunchingNotification";

NSString *const UIApplicationNetworkActivityIndicatorChangedNotification = @"UIApplicationNetworkActivityIndicatorChangedNotification";

NSString *const UIApplicationLaunchOptionsURLKey = @"UIApplicationLaunchOptionsURLKey";
NSString *const UIApplicationLaunchOptionsSourceApplicationKey = @"UIApplicationLaunchOptionsSourceApplicationKey";
NSString *const UIApplicationLaunchOptionsRemoteNotificationKey = @"UIApplicationLaunchOptionsRemoteNotificationKey";
NSString *const UIApplicationLaunchOptionsAnnotationKey = @"UIApplicationLaunchOptionsAnnotationKey";
NSString *const UIApplicationLaunchOptionsLocalNotificationKey = @"UIApplicationLaunchOptionsLocalNotificationKey";
NSString *const UIApplicationLaunchOptionsLocationKey = @"UIApplicationLaunchOptionsLocationKey";

NSString *const UIApplicationDidReceiveMemoryWarningNotification = @"UIApplicationDidReceiveMemoryWarningNotification";

NSString *const UITrackingRunLoopMode = @"UITrackingRunLoopMode";

const UIBackgroundTaskIdentifier UIBackgroundTaskInvalid = NSUIntegerMax; // correct?
const NSTimeInterval UIMinimumKeepAliveTimeout = 0;

static UIApplication *_theApplication = nil;

@interface UIApplication()
@property (nonatomic, assign) UIViewController *sceneViewController;
@end

@implementation UIApplication {
    NSUInteger _ignoringInteractionEvents;
    NSDate *_backgroundTasksExpirationDate;
    NSMutableArray *_backgroundTasks;
    UIEventHandler *_eventHandler;
}

+ (UIApplication *)sharedApplication
{
    if (!_theApplication) {
        _theApplication = [[self alloc] init];
    }

    return _theApplication;
}

static const char* beforeunloadCallback(int eventType, const void *reserved, void *userData)
{
    [[UIApplication sharedApplication] _applicationWillTerminate:nil];
}

static EM_BOOL visibilitychangeCallback(int eventType, const EmscriptenVisibilityChangeEvent *visibilityChangeEvent, void *userData)
{
    if(visibilityChangeEvent->visibilityState == EMSCRIPTEN_VISIBILITY_VISIBLE) {
        [[UIApplication sharedApplication] _computerDidWakeUp:nil];
        [[UIApplication sharedApplication] _applicationDidBecomeActive:nil];
    } else if(visibilityChangeEvent->visibilityState == EMSCRIPTEN_VISIBILITY_HIDDEN) {
        [[UIApplication sharedApplication] _applicationWillResignActive:nil];
        [[UIApplication sharedApplication] _computerWillSleep:nil];
    }
}

- (id)init
{
    if ((self=[super init])) {
        _backgroundTasks = [[NSMutableArray alloc] init];
        _applicationState = UIApplicationStateInactive;
        _applicationSupportsShakeToEdit = YES;		// yeah... not *really* true, but UIKit defaults to YES :)

        _eventHandler = [[UIEventHandler alloc] initWithScreen:[UIScreen mainScreen]];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];

        emscripten_set_visibilitychange_callback(nil, false, visibilitychangeCallback);
        emscripten_set_beforeunload_callback(nil, beforeunloadCallback);
    }
    return self;
}

- (NSTimeInterval)statusBarOrientationAnimationDuration
{
    return 0.3;
}

- (BOOL)isStatusBarHidden
{
    return YES;
}

- (CGRect)statusBarFrame
{
    return CGRectZero;
}

- (NSTimeInterval)backgroundTimeRemaining
{
    return [_backgroundTasksExpirationDate timeIntervalSinceNow];
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)b
{
    if (b != [self isNetworkActivityIndicatorVisible]) {
        _networkActivityIndicatorVisible = b;
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationNetworkActivityIndicatorChangedNotification object:self];
    }
}

- (void)beginIgnoringInteractionEvents
{
    _ignoringInteractionEvents++;
}

- (void)endIgnoringInteractionEvents
{
    _ignoringInteractionEvents--;
}

- (BOOL)isIgnoringInteractionEvents
{
    return (_ignoringInteractionEvents > 0);
}

- (UIInterfaceOrientation)statusBarOrientation
{
    return [UIScreen mainScreen].orientation;
}

static UIInterfaceOrientation interfaceOrientationFromNSString(NSString *orientationString)
{
    if([orientationString isEqualToString:@"UIInterfaceOrientationPortrait"]) {
        return UIInterfaceOrientationPortrait;
    } else if([orientationString isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown"]) {
        return UIInterfaceOrientationPortraitUpsideDown;
    } else if([orientationString isEqualToString:@"UIInterfaceOrientationLandscapeLeft"]) {
        return UIInterfaceOrientationLandscapeLeft;
    } else if([orientationString isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) {
        return UIInterfaceOrientationLandscapeRight;
    } else {
        assert(0);
    }
}

- (UIInterfaceOrientationMask)_supportedInterfaceOrientationsFromInfoPlist
{
    NSArray *orientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];
    if(!orientations) {
        NSString *orientation = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIInterfaceOrientation"];
        if(!orientation) {
            orientation = @"UIInterfaceOrientationPortrait";
        }
        orientations = @[orientation];
    }
    UIInterfaceOrientationMask mask = 0;
    for(NSString *orientationString in orientations) {
        UIInterfaceOrientation orientation = interfaceOrientationFromNSString(orientationString);
        mask |= (1 << orientation);
    }
    return mask;
}

- (UIInterfaceOrientation)_preferredOrientationFromInfoPlist
{
    NSArray *orientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];
    if(orientations) {
        return interfaceOrientationFromNSString(orientations[0]);
    }
    NSString *orientation = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIInterfaceOrientation"];
    if(orientation) {
        return interfaceOrientationFromNSString(orientation);
    }
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)_supportedInterfaceOrientations
{
    if([_delegate respondsToSelector:@selector(application:supportedInterfaceOrientationsForWindow:)]) {
        return [_delegate application:self supportedInterfaceOrientationsForWindow:[self keyWindow]];
    } else {
        return [self _supportedInterfaceOrientationsFromInfoPlist];
    }
}

- (void)_deviceOrientationChanged:(NSNotification*)note
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch(deviceOrientation) {
    case UIDeviceOrientationPortrait:
    case UIDeviceOrientationPortraitUpsideDown:
    case UIDeviceOrientationLandscapeLeft:
    case UIDeviceOrientationLandscapeRight:
        [self.keyWindow _updateOrientation];
        self.statusBarOrientation = self.keyWindow.rootViewController.interfaceOrientation;
        break;
    case UIDeviceOrientationUnknown:
    case UIDeviceOrientationFaceUp:
    case UIDeviceOrientationFaceDown:
    default:
        // do nothing for now
        break;
    }
}

- (void)setStatusBarOrientation:(UIInterfaceOrientation)orientation
{
    NSString *UIApplicationStatusBarOrientationUserInfoKey = @"UIApplicationStatusBarOrientationUserInfoKey";
    NSDictionary *info = @{ UIApplicationStatusBarOrientationUserInfoKey: [NSNumber numberWithInteger:orientation]};
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillChangeStatusBarOrientationNotification object:info];
    [UIScreen mainScreen].orientation = orientation;
    self.keyWindow.frame = [UIScreen mainScreen].bounds;
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidChangeStatusBarOrientationNotification object:info];
}

- (UIStatusBarStyle)statusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (void)registerUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (void)registerForRemoteNotifications;
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (void)unregisterForRemoteNotifications
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (UIRemoteNotificationType)enabledRemoteNotificationTypes
{
    return UIRemoteNotificationTypeNone;
}

- (void)presentLocalNotificationNow:(UILocalNotification *)notification
{
}

- (void)cancelAllLocalNotifications
{
}

- (void)cancelLocalNotification:(UILocalNotification *)notification
{
}

- (NSArray *)scheduledLocalNotifications
{
    return nil;
}

- (void)setScheduledLocalNotifications:(NSArray *)scheduledLocalNotifications
{
}

- (UIBackgroundTaskIdentifier)beginBackgroundTaskWithExpirationHandler:(void(^)(void))handler
{
    UIBackgroundTask *task = [[UIBackgroundTask alloc] initWithExpirationHandler:handler];
    [_backgroundTasks addObject:task];
    return task.taskIdentifier;
}

- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)identifier
{
    for (UIBackgroundTask *task in _backgroundTasks) {
        if (task.taskIdentifier == identifier) {
            [_backgroundTasks removeObject:task];
            break;
        }
    }
}

- (BOOL)_enterBackground
{
    if (self.applicationState != UIApplicationStateBackground) {
        _applicationState = UIApplicationStateBackground;

        if ([_delegate respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [_delegate applicationDidEnterBackground:self];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:self];

        return YES;
    } else {
        return NO;
    }
}

- (void)_enterForeground
{
    if (self.applicationState == UIApplicationStateBackground) {
        if ([_delegate respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [_delegate applicationWillEnterForeground:self];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:self];

        _applicationState = UIApplicationStateInactive;
    }
}

- (BOOL)_runRunLoopForBackgroundTasksBeforeDate:(NSDate *)date
{
    // check if all tasks were done, and if so, break
    if ([_backgroundTasks count] == 0) {
        return NO;
    }

    // run the runloop in the default mode so things like connections and timers still work for processing our
    // background tasks. we'll make sure not to run this any longer than 1 second at a time, otherwise the alert
    // might hang around for a lot longer than is necessary since we might not have anything to run in the default
    // mode for awhile or something which would keep this method from returning.
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:date];

    // otherwise check if we've timed out and if we are, break
    if ([[NSDate date] timeIntervalSinceReferenceDate] >= [_backgroundTasksExpirationDate timeIntervalSinceReferenceDate]) {
        return NO;
    }

    return YES;
}

- (void)_cancelBackgroundTasks
{
    // if there's any remaining tasks, run their expiration handlers
    for (UIBackgroundTask *task in [_backgroundTasks copy]) {
        if (task.expirationHandler) {
            task.expirationHandler();
        }
    }

    // remove any lingering tasks so we're back to being empty
    [_backgroundTasks removeAllObjects];
}

- (void)_runBackgroundTasks:(void (^)(void))run_tasks
{
    run_tasks();
}

// - (NSApplicationTerminateReply)terminateApplicationBeforeDate:(NSDate *)timeoutDate
// {
//     [self _enterBackground];
// 
//     _backgroundTasksExpirationDate = timeoutDate;
// 
//     // we will briefly block here for a short time and run the runloop in an attempt to let the background tasks finish up before
//     // actually prompting the user with an annoying alert. users are much more used to an app hanging for a brief moment while
//     // quitting than they are with an alert appearing/disappearing suddenly that they might have had trouble reading and processing
//     // before it's gone. that sort of thing creates anxiety.
//     NSDate *blockingBackgroundExpiration = [NSDate dateWithTimeIntervalSinceNow:1.33];
// 
//     for (;;) {
//         if (![self _runRunLoopForBackgroundTasksBeforeDate:blockingBackgroundExpiration] || [NSDate timeIntervalSinceReferenceDate] >= [blockingBackgroundExpiration timeIntervalSinceReferenceDate]) {
//             break;
//         }
//     }
// 
//     // if it turns out we're all done with tasks (or maybe had none to begin with), we'll clean up the structures
//     // and tell our app we can terminate immediately now.
//     if ([_backgroundTasks count] == 0) {
//         [self _cancelBackgroundTasks];
// 
//         // and reset our timer since we're done
//         _backgroundTasksExpirationDate = nil;
// 
//         // and return
//         return NSTerminateNow;
//     }
// 
//     // otherwise... we have to do a deferred thing so we can show an alert while we wait for background tasks to finish...
// 
//     void (^taskFinisher)(void) = ^{
// #if 1        
//         NSLog(@"%s fix me", __FUNCTION__);
// #else
//         NSAlert *alert = [[NSAlert alloc] init];
//         [alert setAlertStyle:NSInformationalAlertStyle];
//         [alert setShowsSuppressionButton:NO];
//         [alert setMessageText:@"Quitting"];
//         [alert setInformativeText:@"Finishing some tasks..."];
//         [alert addButtonWithTitle:@"Quit Now"];
//         [alert layout];
// 
//         // to avoid upsetting the user with an alert that flashes too quickly to read, we'll later artifically ensure that
//         // the alert has been visible for at least some small amount of time to give them a chance to see and understand it.
//         NSDate *minimumDisplayTime = [NSDate dateWithTimeIntervalSinceNow:2.33];
// 
//         NSModalSession session = [NSApp beginModalSessionForWindow:alert.window];
// 
//         // run the runloop and wait for tasks to finish
//         while ([NSApp runModalSession:session] == NSRunContinuesResponse) {
//             if (![self _runRunLoopForBackgroundTasksBeforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]) {
//                 break;
//             }
//         }
// 
//         // when we exit the runloop loop, then we're done with the tasks. either they are all finished or the time has run out
//         // so we need to clean things up here as if we're all finished. if there's any remaining tasks, run their expiration handlers
//         [self _cancelBackgroundTasks];
// 
//         // and reset our timer since we're done
//         _backgroundTasksExpirationDate = nil;
// 
//         // now just in case all of this happened too quickly and the user might not have had time to read and understand the alert,
//         // we will kill some time for a bit as long as the alert is still visible. runModalSession: will not return NSRunContinuesResponse
//         // if the user closed the alert, so in that case then this delay won't happen at all. however if the tasks finished too quickly
//         // then what this does is kill time until the user clicks the quit button or the timer expires.
//         while ([NSApp runModalSession:session] == NSRunContinuesResponse) {
//             if ([NSDate timeIntervalSinceReferenceDate] >= [minimumDisplayTime timeIntervalSinceReferenceDate]) {
//                 break;
//             }
//         }
// 
// 
//         [NSApp endModalSession:session];
// 
//         // tell the real NSApp we're all done here
//         [NSApp replyToApplicationShouldTerminate:YES];
// #endif
//     };
// 
//     // I need to delay this but run it on the main thread and also be able to run it in the panel run loop mode
//     // because we're probably in that run loop mode due to how -applicationShouldTerminate: does things. I don't
//     // know if I could do this same thing with a couple of simple GCD calls, but whatever, this works too. :)
//     [self performSelectorOnMainThread:@selector(_runBackgroundTasks:)
//                            withObject:[taskFinisher copy]
//                         waitUntilDone:NO
//                                 modes:[NSArray arrayWithObjects:NSModalPanelRunLoopMode, NSRunLoopCommonModes, nil]];
// 
//     return NSTerminateLater;
// }

- (void)_computerWillSleep:(NSNotification *)note
{
    if ([self _enterBackground]) {
        // docs say we have 30 seconds to return from our handler for the sleep notification, so we'll let background tasks
        // take up to 29 of them with the idea that hopefully this means that any cancelation handlers that might need to run
        // have a full second or so to finish up before we're forced to sleep.
        // since we can just block here we don't need to put the app into a modal state or popup a window or anything because
        // the machine is about to go to sleep.. so we'll just do things in a blocking way in this case while still handling
        // any pending background tasks.

        _backgroundTasksExpirationDate = [[NSDate alloc] initWithTimeIntervalSinceNow:29];

        for (;;) {
            if (![self _runRunLoopForBackgroundTasksBeforeDate:_backgroundTasksExpirationDate]) {
                break;
            }
        }

        [self _cancelBackgroundTasks];

        // and reset our timer since we're done
        _backgroundTasksExpirationDate = nil;
    }
}

- (void)_computerDidWakeUp:(NSNotification *)note
{
    [self _enterForeground];
}

- (NSArray *)windows
{
    NSMutableArray *windows = [NSMutableArray new];

    for (UIScreen *screen in [UIScreen screens]) {
        [windows addObjectsFromArray:screen.windows];
    }

    return [windows sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"windowLevel" ascending:YES]]];
}

- (UIWindow *)keyWindow
{
    for (UIWindow *window in self.windows) {
        if (window.isKeyWindow) {
            return window;
        }
    }

    return nil;
}

- (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event
{
    if (!target) {
        // The docs say this method will start with the first responder if target==nil. Initially I thought this meant that there was always a given
        // or set first responder (attached to the window, probably). However it doesn't appear that is the case. Instead it seems UIKit is perfectly
        // happy to function without ever having any UIResponder having had a becomeFirstResponder sent to it. This method seems to work by starting
        // with sender and traveling down the responder chain from there if target==nil. The first object that responds to the given action is sent
        // the message. (or no one is)

        // My confusion comes from the fact that motion events and keyboard events are supposed to start with the first responder - but what is that
        // if none was ever set? Apparently the answer is, if none were set, the message doesn't get delivered. If you expicitly set a UIResponder
        // using becomeFirstResponder, then it will receive keyboard/motion events but it does not receive any other messages from other views that
        // happen to end up calling this method with a nil target. So that's a seperate mechanism and I think it's confused a bit in the docs.

        // It seems that the reality of message delivery to "first responder" is that it depends a bit on the source. If the source is an external
        // event like motion or keyboard, then there has to have been an explicitly set first responder (by way of becomeFirstResponder) in order for
        // those events to even get delivered at all. If there is no responder defined, the action is simply never sent and thus never received.
        // This is entirely independent of what "first responder" means in the context of a UIControl. Instead, for a UIControl, the first responder
        // is the first UIResponder (including the UIControl itself) that responds to the action. It starts with the UIControl (sender) and not with
        // whatever UIResponder may have been set with becomeFirstResponder.

        id responder = sender;
        while (responder) {
            if ([responder respondsToSelector:action]) {
                target = responder;
                break;
            } else if ([responder respondsToSelector:@selector(nextResponder)]) {
                responder = [responder nextResponder];
            } else {
                responder = nil;
            }
        }
    }

    if (target) {
        [target performSelector:action withObject:sender withObject:event];
        return YES;
    }

    return NO;
}

- (void)sendEvent:(UIEvent *)event
{
    if (event.type ==  UIEventTypeTouches) {
        [self.windows makeObjectsPerformSelector:@selector(sendEvent:) withObject:event];
    } else {
        [self.keyWindow sendEvent:event];
    }
}

- (BOOL)openURL:(NSURL *)url
{
    // To avoid link error on emscripten, we need to encode
    // encodeURI("ポップアップブロックを解除してください")
    
    const char* urlString = [url.absoluteString UTF8String];
    int success = EM_ASM_INT({
        var url = Pointer_stringify($0);
        var ret = window.open(url, '_blank') != null ? 1 : 0;
        if(!ret) {
            alert(decodeURI("%E3%83%9D%E3%83%83%E3%83%97%E3%82%A2%E3%83%83%E3%83%97%E3%83%96%E3%83%AD%E3%83%83%E3%82%AF%E3%82%92%E8%A7%A3%E9%99%A4%E3%81%97%E3%81%A6%E3%81%8F%E3%81%A0%E3%81%95%E3%81%84"));
        }
        return ret;
    }, urlString);
    return success;
}

- (BOOL)canOpenURL:(NSURL *)url
{
    NSString *scheme = url.scheme;
    return [scheme isEqual:@"http"] || [scheme isEqual:@"https"];
}

- (void)_applicationWillFinishLaunching
{
    emscripten_trace_report_memory_layout();

    NSDictionary *options = nil;

    if ([_delegate respondsToSelector:@selector(application:willFinishLaunchingWithOptions:)]) {
        [_delegate application:self willFinishLaunchingWithOptions:options];
    }

    emscripten_trace_report_memory_layout();
}

- (void)_applicationDidFinishLaunching
{
    emscripten_trace_report_memory_layout();

    NSDictionary *options = nil;

    if ([_delegate respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        [_delegate application:self didFinishLaunchingWithOptions:options];
    } else if ([_delegate respondsToSelector:@selector(applicationDidFinishLaunching:)]) {
        [_delegate applicationDidFinishLaunching:self];
    }

    emscripten_trace_report_memory_layout();

    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidFinishLaunchingNotification object:self];
}

- (void)_applicationWillTerminate:(NSNotification *)note
{
    if ([_delegate respondsToSelector:@selector(applicationWillTerminateOnDesktop:)]) {
        [_delegate applicationWillTerminateOnDesktop:self];
    }

    if ([_delegate respondsToSelector:@selector(applicationWillTerminate:)]) {
        [_delegate applicationWillTerminate:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillTerminateNotification object:self];
}

- (void)_applicationWillResignActive:(NSNotification *)note
{
    if (self.applicationState == UIApplicationStateActive) {
        if ([_delegate respondsToSelector:@selector(applicationWillResignActive:)]) {
            [_delegate applicationWillResignActive:self];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillResignActiveNotification object:self];

        _applicationState = UIApplicationStateInactive;
    }
}

- (void)_applicationDidBecomeActive:(NSNotification *)note
{
    if (self.applicationState == UIApplicationStateInactive) {
        _applicationState = UIApplicationStateActive;

        if ([_delegate respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [_delegate applicationDidBecomeActive:self];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:self];
    }
}

// this is only here because there's a real private API in Apple's UIKit that does something similar
- (void)_performMemoryWarning
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:self];
}

- (void)scheduleLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

-(void)_display {
    [[UIScreen screens] makeObjectsPerformSelector:@selector(_display)];
}

 -(void)_setupScreen {
    UIScreen *screen = [UIScreen mainScreen];
    screen.orientation = [self _preferredOrientationFromInfoPlist];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *mainStoryboardName = [infoDictionary objectForKey:@"UIMainStoryboardFile"];
    NSString *mainNibName = [infoDictionary objectForKey:@"NSMainNibFile"];
    if(mainStoryboardName) {
        DEBUGLOG(@"main storyboard %@", mainStoryboardName);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:mainStoryboardName bundle:nil];
        DEBUGLOG(@"storyboard %@", storyboard);
        UIViewController *rootVC = [storyboard instantiateInitialViewController];
        DEBUGLOG(@"rootVC %@", rootVC);
        UIWindow *window = [[UIWindow alloc] initWithFrame:screen.bounds];
        window.screen = screen;
        [window makeKeyAndVisible];
        assert(window);

        id<UIApplicationDelegate> delegate = self.delegate;
        if([delegate respondsToSelector:@selector(setWindow:)]) {
            [delegate performSelector:@selector(setWindow:) withObject:window];
        }
        window.rootViewController = rootVC;
    } else if(mainNibName) {
        DEBUGLOG(@"main nib name %@", mainNibName);
        UINib *mainNib = [UINib nibWithNibName:mainNibName bundle:[NSBundle mainBundle]];
        NSArray *objects = [mainNib instantiateWithOwner:self options:nil];
        DEBUGLOG(@"main nib %@", objects);
    }
        
    emscripten_trace_report_memory_layout();
}

-(void)finishLaunching {
    @autoreleasepool {
        [self _applicationWillFinishLaunching];

        [self _setupScreen];

        [self _applicationDidFinishLaunching];

        // Actually, this should be later than here
        [UIDevice currentDevice].orientation = EM_ASM_INT_V({return Module['initialDeviceOrientation'] || 0;}) ?: UIDeviceOrientationPortrait;
        
        [self _applicationDidBecomeActive:nil];
    }
}

- (void)run
{
    emscripten_trace_report_memory_layout();

    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishLaunching];
        
        __block int count = 0;

        dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 2<<10, dispatch_get_current_queue());
        dispatch_source_set_timer(source, 0, 0, 0);
        dispatch_source_set_event_handler(source, ^{
            @autoreleasepool {
                [self _display];
            }

            if(count % 100 == 0) {
                EM_ASM({ FS.syncfs(false, function(){}) });
            }
            
            count++;
        });
        dispatch_resume(source);
    });
    dispatch_main();
}

@end


@implementation UIApplication(UIApplicationDeprecated)

- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated
{
}

@end

int UIApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName)
{
    @autoreleasepool {
        UIApplication *app = principalClassName? [NSClassFromString(principalClassName) sharedApplication] : [UIApplication sharedApplication];
        id<UIApplicationDelegate> delegate = delegateClassName? [NSClassFromString(delegateClassName) new] : nil;

        [app setDelegate:delegate];

        [app run];

        // the only purpose of this is to confuse ARC. I'm not sure how else to do it.
        // without this here, ARC thinks it can dealloc some stuff before we're really done
        // with it, and since we're never really going to be done with this stuff, it has to
        // be kept around as long as the app runs, but since the app never actually gets here
        // it will never be executed but this prevents ARC from preemptively releasing things.
        // meh.
        [@[app, delegate] count];
    }

    // this never happens
    return 0;
}

void UIApplicationSendStationaryTouches(void)
{
    // for (UIScreen *screen in [UIScreen screens]) {
    //     [screen.UIKitView sendStationaryTouches];
    // }
}

void UIApplicationInterruptTouchesInView(UIView *view)
{
    // the intent here was that there needed to be a way to force-cancel touches to somewhat replicate situations that
    // might arise on OSX that you could kinda/sorta pretend were phonecall-like events where you'd want a touch or
    // gesture or something to cancel. these situations come up when things like popovers and modal menus are presented,
    //
    // If the need arises, my intent here is to send a notification or something on the *next* runloop to all UIKitViews
    // attached to screens to tell them to kill off their current touch sequence (if any). It seems important that this
    // happen on the *next* runloop cycle and not immediately because there were cases where the touch cancelling would
    // happen in response to something like a touch ended event, so we can't just blindly cancel a touch while it's in
    // the process of being evalulated since that could lead to very inconsistent behavior and really weird edge cases.
    // by deferring the cancel, it would then be able to take the right action if the touch phase was something *other*
    // than ended or cancelled by the time it attemped cancellation.

    // if (!view) {
    //     for (UIScreen *screen in [UIScreen screens]) {
    //         [screen.UIKitView performSelector:@selector(cancelTouchesInView:) withObject:nil afterDelay:0];
    //     }
    // } else {
    //     [view.window.screen.UIKitView performSelector:@selector(cancelTouchesInView:) withObject:view afterDelay:0];
    // }
}
