/*
 * Copyright (c) 2013, The Iconfactory. All rights reserved.
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

#import "UINSApplicationDelegate.h"
#import "UIApplicationAppKitIntegration.h"
#import <AppKit/NSWindow.h>
#import "UIKitView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIStoryboard.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIApplicationDelegate.h>

@implementation UINSApplicationDelegate

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    return [[UIApplication sharedApplication] terminateApplicationBeforeDate:[NSDate dateWithTimeIntervalSinceNow:30]];
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    NSApplication *app = (NSApplication *)[notification object];
    _window = [[NSWindow alloc] initWithContentRect:CGRectMake(0,0,320,568) styleMask:0 backing:NSBackingStoreBuffered defer:NO];
    [_window orderFront:nil];
    UIKitView *uiKitView = [[UIKitView alloc] initWithFrame:CGRectMake(0,0,320,568)];
    _window.contentView = uiKitView;

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *mainStoryboardName = [infoDictionary objectForKey:@"UIMainStoryboardFile"];
    if(mainStoryboardName) {
        NSLog(@"main storyboard %@", mainStoryboardName);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:mainStoryboardName bundle:nil];
        NSLog(@"storyboard %@", storyboard);
        UIViewController *rootVC = [storyboard instantiateInitialViewController];
        NSLog(@"rootVC %@", rootVC);
        UIWindow *uiWindow = [uiKitView UIWindow];
        assert(uiWindow);

        UIApplication *uiApp = [UIApplication sharedApplication];
        id<UIApplicationDelegate> delegate = uiApp.delegate;
        if([delegate respondsToSelector:@selector(setWindow:)]) {
            [delegate performSelector:@selector(setWindow:) withObject:uiWindow];
        }
        uiWindow.rootViewController = rootVC;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
//    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

/*
- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    NSURL* url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    UIApplication *app = [UIApplication sharedApplication];

    [app.delegate application:app openURL:url sourceApplication:nil annotation:nil];
}
*/

@end
