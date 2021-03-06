/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import <AppKit/NSApplication.h>
#import <AppKit/NSWindow-Private.h>
#import <AppKit/NSMenu.h>
#import <AppKit/NSMenuItem.h>
#import <AppKit/NSEvent.h>
#import <AppKit/NSScreen.h>
//#import <AppKit/NSColorPanel.h>
#import <AppKit/NSDisplay.h>
#import <AppKit/NSWorkspace.h>
//#import <AppKit/NSDockTile.h>
#import <CoreGraphics/CGWindow.h>
#import <AppKit/NSRaise.h>
//#import <AppKit/NSSpellChecker.h>
#import <objc/message.h>
#import <pthread.h>
#import <emscripten.h>
#import <emscripten/html5.h>
#import <emscripten/trace.h>

#define pthread_mutex_init(a,b)
#define pthread_mutex_lock(a)
#define pthread_mutex_unlock(a)

NSString * const NSModalPanelRunLoopMode=@"NSModalPanelRunLoopMode";
NSString * const NSEventTrackingRunLoopMode=@"NSEventTrackingRunLoopMode";

NSString * const NSApplicationWillFinishLaunchingNotification=@"NSApplicationWillFinishLaunchingNotification";
NSString * const NSApplicationDidFinishLaunchingNotification=@"NSApplicationDidFinishLaunchingNotification";

NSString * const NSApplicationWillBecomeActiveNotification=@"NSApplicationWillBecomeActiveNotification";
NSString * const NSApplicationDidBecomeActiveNotification=@"NSApplicationDidBecomeActiveNotification";
NSString * const NSApplicationWillResignActiveNotification=@"NSApplicationWillResignActiveNotification";
NSString * const NSApplicationDidResignActiveNotification=@"NSApplicationDidResignActiveNotification";

NSString * const NSApplicationWillUpdateNotification=@"NSApplicationWillUpdateNotification";
NSString * const NSApplicationDidUpdateNotification=@"NSApplicationDidUpdateNotification";

NSString * const NSApplicationWillHideNotification=@"NSApplicationWillHideNotification";
NSString * const NSApplicationDidHideNotification=@"NSApplicationDidHideNotification";
NSString * const NSApplicationWillUnhideNotification=@"NSApplicationWillUnhideNotification";
NSString * const NSApplicationDidUnhideNotification=@"NSApplicationDidUnhideNotification";

NSString * const NSApplicationWillTerminateNotification=@"NSApplicationWillTerminateNotification";

NSString * const NSApplicationDidChangeScreenParametersNotification=@"NSApplicationDidChangeScreenParametersNotification";

@interface NSMenu(Private)
-(NSMenu *)_menuWithName:(NSString *)name;
@end

@implementation NSApplication

id NSApp=nil;

+(NSApplication *)sharedApplication {

    if(NSApp==nil){
        [[self alloc] init]; // NSApp must be nil inside init
    }

    return NSApp;
}

+(void)detachDrawingThread:(SEL)selector toTarget:target withObject:object {
    NSUnimplementedMethod();
}

#if 0
-(void)_showSplashImage {
    NSImage *image=[NSImage imageNamed:@"splash"];

    if(image!=nil){
        NSSize    imageSize=[image size];
        NSWindow *splash=[[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,imageSize.width,imageSize.height) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        [splash setLevel:NSFloatingWindowLevel];

        NSImageView *view=[[NSImageView alloc] initWithFrame:NSMakeRect(0,0,imageSize.width,imageSize.height)];

        [view setImage:image];
        [splash setContentView:view];
        [view release];
        [splash setReleasedWhenClosed:YES];
        [splash center];
        [splash orderFront:nil];
        [splash display];
    }
}

-(void)_closeSplashImage {
    int i;

    for(i=0;i<[_windows count];i++){
        NSWindow *check=[_windows objectAtIndex:i];
        NSView   *contentView=[check contentView];

        if([contentView isKindOfClass:[NSImageView class]])
     if([[[(NSImageView *)contentView image] name] isEqual:@"splash"]){
         [check close];
         return;
     }
    }
}
#endif

static EM_BOOL sendTouchEvnetToApp(int eventType, const EmscriptenTouchEvent *touchEvent, void *userData) {
    NSLog(@"event %d", eventType);

    // handle only single touch
    if(touchEvent->numTouches == 0) return NO;

    NSEventType type;
    switch(eventType) {
    case EMSCRIPTEN_EVENT_TOUCHSTART:
        type = NSLeftMouseDown;
        break;
    case EMSCRIPTEN_EVENT_TOUCHEND:
        type = NSLeftMouseUp;
        break;
    case EMSCRIPTEN_EVENT_TOUCHMOVE:
        type = NSLeftMouseDragged;
        break;
    case EMSCRIPTEN_EVENT_TOUCHCANCEL:
        type = NSLeftMouseUp;
        break;
    }


    NSPoint location;
    location.x = touchEvent->touches[0].canvasX;
    location.y = 568 - touchEvent->touches[0].canvasY;
    NSUInteger flags = 0;

    NSTimeInterval timestamp = touchEvent->touches[0].identifier;

    dispatch_async(dispatch_get_main_queue(), ^{
        NSWindow* window = [NSApp mainWindow];
        NSEvent *event = [NSEvent mouseEventWithType:type location:location modifierFlags:flags timestamp:timestamp windowNumber:window.windowNumber context:NULL eventNumber:0 clickCount:1 pressure:0];
        [NSApp sendEvent:event];
    });
    return YES;
}

static EM_BOOL sentMouseEventToApp(int eventType, const EmscriptenMouseEvent *mouseEvent, void *userData) {
//    NSLog(@"event %d", eventType);

    NSEventType type;
    switch(eventType) {
    case EMSCRIPTEN_EVENT_MOUSEDOWN:
        type = NSLeftMouseDown;
        break;
    case EMSCRIPTEN_EVENT_MOUSEUP:
        type = NSLeftMouseUp;
        break;
    case EMSCRIPTEN_EVENT_MOUSEMOVE:
        if(mouseEvent->buttons & 1) {
            type = NSLeftMouseDragged;
            break;
        } else {
            type = NSMouseMoved;
            break;
        }
    default:
        return NO;
    }

    NSPoint location;
    location.x = mouseEvent->canvasX;
    location.y = 568 - mouseEvent->canvasY;
    NSUInteger flags = 0;

    NSTimeInterval timestamp = mouseEvent->timestamp;

    dispatch_async(dispatch_get_main_queue(), ^{
        NSWindow* window = [NSApp mainWindow];
        NSEvent *event = [NSEvent mouseEventWithType:type location:location modifierFlags:flags timestamp:timestamp windowNumber:window.windowNumber context:NULL eventNumber:0 clickCount:1 pressure:0];
        [NSApp sendEvent:event];
    });
    return YES;
}

static EM_BOOL sentWheelEventToApp(int eventType, const EmscriptenWheelEvent *wheelEvent, void *userData) {
    assert(eventType == EMSCRIPTEN_EVENT_WHEEL);
    
    NSEventType type = NSScrollWheel;
    EmscriptenMouseEvent *mouseEvent = &(wheelEvent->mouse);
    
    NSPoint location;
    location.x = mouseEvent->canvasX;
    location.y = 568 - mouseEvent->canvasY;
    NSUInteger flags = 0;

    NSTimeInterval timestamp = mouseEvent->timestamp;
    
    float deltaY = wheelEvent->deltaY;

    dispatch_async(dispatch_get_main_queue(), ^{
        NSWindow* window = [NSApp mainWindow];
        NSEvent *event = [NSEvent mouseEventWithType:type location:location modifierFlags:flags window:window deltaY:deltaY];
        [NSApp sendEvent:event];
    });
    return YES;
}

-init {
    if(NSApp)
        NSAssert(!NSApp, @"NSApplication is a singleton");
    NSApp=self;
    _display=[[NSDisplay currentDisplay] retain];

    _windows=[NSMutableArray new];
    _mainMenu=nil;

    _modalStack=[NSMutableArray new];

    _lock=NSZoneMalloc(NULL,sizeof(pthread_mutex_t));

    pthread_mutex_init(_lock,NULL);

//    [self _showSplashImage];

    emscripten_set_touchstart_callback(NULL, NULL, TRUE, sendTouchEvnetToApp);
    emscripten_set_touchend_callback(NULL, NULL, TRUE, sendTouchEvnetToApp);
    emscripten_set_touchmove_callback(NULL, NULL, TRUE, sendTouchEvnetToApp);
    emscripten_set_touchcancel_callback(NULL, NULL, TRUE, sendTouchEvnetToApp);

    emscripten_set_click_callback(NULL, NULL, TRUE, sentMouseEventToApp);
    emscripten_set_mousedown_callback(NULL, NULL, TRUE, sentMouseEventToApp);
    emscripten_set_mouseup_callback(NULL, NULL, TRUE, sentMouseEventToApp);
    emscripten_set_mousemove_callback(NULL, NULL, TRUE, sentMouseEventToApp);
    emscripten_set_mouseenter_callback(NULL, NULL, TRUE, sentMouseEventToApp);
    emscripten_set_mouseleave_callback(NULL, NULL, TRUE, sentMouseEventToApp);
    
    emscripten_set_wheel_callback(NULL, NULL, TRUE, sentWheelEventToApp);
    return NSApp;
}

-(NSGraphicsContext *)context {
    NSUnimplementedMethod();
    return nil;
}

-delegate {
    return _delegate;
}

-(NSArray *)windows {
    return _windows;
}

-(NSWindow *)windowWithWindowNumber:(NSInteger)number {
    int i,count=[_windows count];

    for(i=0;i<count;i++){
        NSWindow *check=[_windows objectAtIndex:i];

        if([check windowNumber]==number)
            return check;
    }

    return nil;
}

-(NSMenu *)mainMenu {
    return _mainMenu;
}

-(NSMenu *)menu {
    return [self mainMenu];
}

-(NSMenu *)windowsMenu {
    if(_windowsMenu==nil) {
        _windowsMenu=[[NSApp mainMenu] _menuWithName:@"_NSWindowsMenu"];
        if (_windowsMenu && ![[[_windowsMenu itemArray] lastObject] isSeparatorItem])
            [_windowsMenu addItem:[NSMenuItem separatorItem]];
    }

    return _windowsMenu;
}

-(NSWindow *)mainWindow {
    return _mainWindow;
}

-(void)_setMainWindow:(NSWindow *)window {
    _mainWindow=window;
}

-(NSWindow *)keyWindow {
    return _keyWindow;
}

-(void)_setKeyWindow:(NSWindow *)window {
    _keyWindow=window;
}

-(BOOL)isActiveExcludingWindow:(NSWindow *)exclude {
    int count=[_windows count];

    while(--count>=0){
        NSWindow *check=[_windows objectAtIndex:count];

        if(check==exclude)
            continue;

        if([check _isActive])
            return YES;
    }

    return NO;
}

-(BOOL)isActive {
    return [self isActiveExcludingWindow:nil];
}

-(BOOL)isHidden {
    return _isHidden;
}

-(BOOL)isRunning {
    return _isRunning;
}

-(NSWindow *)makeWindowsPerform:(SEL)selector inOrder:(BOOL)inOrder {
    NSUnimplementedMethod();
    return nil;
}

-(void)miniaturizeAll:sender {
    int count=[_windows count];

    while(--count>=0)
        [[_windows objectAtIndex:count] miniaturize:sender];
}

-(NSArray *)orderedWindows {
    extern NSArray *CGSOrderedWindowNumbers();

    NSMutableArray *result=[NSMutableArray array];
    NSArray *numbers=CGSOrderedWindowNumbers();

    for(NSNumber *number in numbers){
        NSWindow *window=[self windowWithWindowNumber:[number integerValue]];

        // if(window!=nil && ![window isKindOfClass:[NSPanel class]])
       [result addObject:window];
    }

    return result;
}

-(void)preventWindowOrdering {
    NSUnimplementedMethod();
}

-(void)unregisterDelegate {
    if([_delegate respondsToSelector:@selector(applicationWillFinishLaunching:)]){
        [[NSNotificationCenter defaultCenter] removeObserver:_delegate
                                                        name:NSApplicationWillFinishLaunchingNotification object:self];
    }
    if([_delegate respondsToSelector:@selector(applicationDidFinishLaunching:)]){
        [[NSNotificationCenter defaultCenter] removeObserver:_delegate
                                                        name:NSApplicationDidFinishLaunchingNotification object:self];
    }
    if([_delegate respondsToSelector:@selector(applicationDidBecomeActive:)]){
        [[NSNotificationCenter defaultCenter] removeObserver:_delegate
                                                        name: NSApplicationDidBecomeActiveNotification object:self];
    }
    if([_delegate respondsToSelector:@selector(applicationWillTerminate:)]){
        [[NSNotificationCenter defaultCenter] removeObserver:_delegate
                                                        name: NSApplicationWillTerminateNotification object:self];
    }
}

-(void)registerDelegate {
    if([_delegate respondsToSelector:@selector(applicationWillFinishLaunching:)]){
     [[NSNotificationCenter defaultCenter] addObserver:_delegate
                                              selector:@selector(applicationWillFinishLaunching:)
                                                  name:NSApplicationWillFinishLaunchingNotification object:self];
    }
    if([_delegate respondsToSelector:@selector(applicationDidFinishLaunching:)]){
     [[NSNotificationCenter defaultCenter] addObserver:_delegate
                                              selector:@selector(applicationDidFinishLaunching:)
                                                  name:NSApplicationDidFinishLaunchingNotification object:self];
    }
    if([_delegate respondsToSelector:@selector(applicationDidBecomeActive:)]){
     [[NSNotificationCenter defaultCenter] addObserver:_delegate
                                              selector:@selector(applicationDidBecomeActive:)
                                                  name: NSApplicationDidBecomeActiveNotification object:self];
    }
    if([_delegate respondsToSelector:@selector(applicationWillTerminate:)]){
      [[NSNotificationCenter defaultCenter] addObserver:_delegate
                                               selector:@selector(applicationWillTerminate:)
                                                   name: NSApplicationWillTerminateNotification object:self];
    }

}

-(void)setDelegate:delegate {
    if (delegate != _delegate) {
        [self unregisterDelegate];
        _delegate=delegate;
        [self registerDelegate];
    }
}

-(void)setMainMenu:(NSMenu *)menu {
    int i,count=[_windows count];

    [_mainMenu autorelease];
    _mainMenu=[menu retain];

    for(i=0;i<count;i++){
        NSWindow *window=[_windows objectAtIndex:i];

        // if(![window isKindOfClass:[NSPanel class]])
      [window setMenu:_mainMenu];
    }
}

-(void)setMenu:(NSMenu *)menu {
   [self setMainMenu:menu];
}

-(void)setWindowsMenu:(NSMenu *)menu {
    [_windowsMenu autorelease];
    _windowsMenu=[menu retain];
}


-(void)addWindowsItem:(NSWindow *)window title:(NSString *)title filename:(BOOL)isFilename {
    NSMenuItem *item;

    if ([[self windowsMenu] indexOfItemWithTarget:window andAction:@selector(makeKeyAndOrderFront:)] != -1)
        return;

    if (isFilename)
        title = [NSString stringWithFormat:@"%@  --  %@", [title lastPathComponent],[title stringByDeletingLastPathComponent]];

    item = [[[NSMenuItem alloc] initWithTitle:title action:@selector(makeKeyAndOrderFront:) keyEquivalent:@""] autorelease];
    [item setTarget:window];

    [[self windowsMenu] addItem:item];
}

-(void)changeWindowsItem:(NSWindow *)window title:(NSString *)title filename:(BOOL)isFilename {

    if ([title length] == 0) {
        // Windows with no name aren't in the Windows menu
        [self removeWindowsItem:window];
    } else {
        int itemIndex = [[self windowsMenu] indexOfItemWithTarget:window andAction:@selector(makeKeyAndOrderFront:)];

        if (itemIndex != -1) {
            NSMenuItem *item = [[self windowsMenu] itemAtIndex:itemIndex];

            if (isFilename)
                title = [NSString stringWithFormat:@"%@  --  %@",[title lastPathComponent], [title stringByDeletingLastPathComponent]];

            [item setTitle:title];
            [[self windowsMenu] itemChanged:item];
        }
        else
            [self addWindowsItem:window title:title filename:isFilename];
    }
}

-(void)removeWindowsItem:(NSWindow *)window {
    int itemIndex = [[self windowsMenu] indexOfItemWithTarget:window andAction:@selector(makeKeyAndOrderFront:)];

    if (itemIndex != -1) {
        [[self windowsMenu] removeItemAtIndex:itemIndex];

        if ([[[[self windowsMenu] itemArray] lastObject] isSeparatorItem]){
            [[self windowsMenu] removeItem:[[[self windowsMenu] itemArray] lastObject]];
        }
    }
}

-(BOOL)openFiles
{
    BOOL opened = NO;
    if(_delegate) {
        id nsOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"NSOpen"];
        NSArray *openFiles = nil;
        if ([nsOpen isKindOfClass:[NSString class]] && [nsOpen length]) {
         openFiles = [NSArray arrayWithObject:nsOpen];
        } else if ([nsOpen isKindOfClass:[NSArray class]]) {
            openFiles = nsOpen;
        }
        if ([openFiles count] > 0) {
            if ([openFiles count] == 1 && [_delegate respondsToSelector: @selector(application:openFile:)]) {

                if([_delegate application: self openFile: [openFiles lastObject]]) {
                    opened = YES;
                }
            } else {
                if ([_delegate respondsToSelector: @selector(application:openFiles:)]) {
                           [_delegate application: self openFiles: openFiles];
                           opened = YES;

                } else if ([_delegate respondsToSelector: @selector(application:openFile:)]) {
                    for (NSString *aFile in openFiles) {
                        opened |= [_delegate application: self openFile: aFile];
                    }
                }
            }
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NSOpen"];
    }
    return opened;
}

-(void)finishLaunching {
    //NSAutoreleasePool *pool=[NSAutoreleasePool new];
    BOOL               needsUntitled=YES;

    NS_DURING
        [[NSNotificationCenter defaultCenter] postNotificationName: NSApplicationWillFinishLaunchingNotification object:self];
    NS_HANDLER
        [self reportException:localException];
    NS_ENDHANDLER

    // Give us a first event
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:nil
                                   selector:NULL userInfo:nil repeats:NO];

//    [self _closeSplashImage];

    if ([self openFiles]) {
        needsUntitled = NO;
    }

    if(needsUntitled && _delegate && [_delegate respondsToSelector: @selector(applicationShouldOpenUntitledFile:)]) {
        needsUntitled = [_delegate applicationShouldOpenUntitledFile: self];
    }

    if(needsUntitled && _delegate && [_delegate respondsToSelector: @selector(applicationOpenUntitledFile:)]) {
        needsUntitled = ![_delegate applicationOpenUntitledFile: self];
    }

    NS_DURING
        [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationDidFinishLaunchingNotification object:self];
    NS_HANDLER
        [self reportException:localException];
    NS_ENDHANDLER

    //[pool release];
}

-(void)_checkForReleasedWindows {
    int  count=[_windows count];

    while(--count>=0){
        NSWindow *check=[_windows objectAtIndex:count];

        if([check retainCount]==1){

            // Use the setters here - give a chance to the observer to notice something happened
            if(check==_keyWindow) {
                [self _setKeyWindow:nil];
            }

            if(check==_mainWindow) {
                [self _setMainWindow:nil];
            }

            [_windows removeObjectAtIndex:count];
        }
    }
}

-(void)_checkForTerminate {
    int  count=[_windows count];

    while(--count>=0){
        NSWindow *check=[_windows objectAtIndex:count];

        if([check isVisible]){
            return;
        }
    }

    [self terminate:self];
}

-(void)_checkForAppActivation {
#if 1
    if([self isActive])
        [_windows makeObjectsPerformSelector:@selector(_showForActivation)];
    else {
        [_windows makeObjectsPerformSelector:@selector(_hideForDeactivation)];
    }
#endif
}

-(void)run {
    emscripten_trace_report_memory_layout();

    static BOOL didlaunch = NO;

    _isRunning=YES;

    if (!didlaunch) {
        didlaunch = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAutoreleasePool *pool=[NSAutoreleasePool new];
            emscripten_trace_report_memory_layout();
            [self finishLaunching];
            emscripten_trace_report_memory_layout();
            [pool release];
            
            __block int count = 0;

            dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 2<<10, dispatch_get_current_queue());
            dispatch_source_set_timer(source, 0, 0, 0);
            dispatch_source_set_event_handler(source, ^{
                NSAutoreleasePool *pool = [NSAutoreleasePool new];
                NSEvent           *event;
                event=[self nextEventMatchingMask:NSAnyEventMask untilDate:[NSDate distantFuture] inMode:NSDefaultRunLoopMode dequeue:YES];

                NS_DURING
                    [self sendEvent:event];

                NS_HANDLER
                    [self reportException:localException];
                NS_ENDHANDLER

                [self _checkForReleasedWindows];
                // [self _checkForTerminate];

                [pool release];

                if (!_isRunning) {
                    dispatch_source_cancel(source);
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
}

-(BOOL)_performKeyEquivalent:(NSEvent *)event {
    if (event.charactersIgnoringModifiers.length > 0) {
        /* order is important here, views may want to handle the event before menu*/

        if([[self keyWindow] performKeyEquivalent:event])
            return YES;
        if([[self mainWindow] performKeyEquivalent:event])
            return YES;
        if([[self mainMenu] performKeyEquivalent:event])
            return YES;
    }
    // documentation says to send it to all windows
    return NO;
}

-(void)sendEvent:(NSEvent *)event {
    if(!event) return;

    //if(event) NSLog(@"NSApp sendEvent %@", event);
    if([event type]==NSKeyDown){
        unsigned modifierFlags=[event modifierFlags];

        if(modifierFlags&(NSCommandKeyMask|NSAlternateKeyMask))
            if([self _performKeyEquivalent:event])
                return;
    }

    //[[event window] sendEvent:event];
    [_windows[0] sendEvent:event];
}

// This method is used by NSWindow
-(void)_displayAllWindowsIfNeeded {
    [[NSApp windows] makeObjectsPerformSelector:@selector(displayIfNeeded)];
}

-(NSEvent *)nextEventMatchingMask:(unsigned int)mask untilDate:(NSDate *)untilDate inMode:(NSString *)mode dequeue:(BOOL)dequeue {
    NSEvent *nextEvent=nil;

    if ([untilDate timeIntervalSinceNow] <= 0) {
        return nil;
    }

    // do {
    NSAutoreleasePool *pool=[NSAutoreleasePool new];

    NS_DURING
        // [NSClassFromString(@"Win32RunningCopyPipe") performSelector:@selector(createRunningCopyPipe)];

        // This should happen before _makeSureIsOnAScreen so we don't reposition done windows
        [self _checkForReleasedWindows];

    [[NSApp windows] makeObjectsPerformSelector:@selector(_makeSureIsOnAScreen)];

    [self _checkForAppActivation];
    [self _displayAllWindowsIfNeeded];

    nextEvent = nil;//[[_display nextEventMatchingMask:mask untilDate:untilDate inMode:mode dequeue:dequeue] retain];

    if([nextEvent type]==NSAppKitSystem){
        [nextEvent release];
        nextEvent=nil;
    }

    NS_HANDLER
        [self reportException:localException];
    NS_ENDHANDLER

        [pool release];
    //}while(nextEvent==nil && [untilDate timeIntervalSinceNow]>0);

    if(nextEvent!=nil){
        nextEvent=[nextEvent retain];

        pthread_mutex_lock(_lock);
        [_currentEvent release];
        _currentEvent=nextEvent;
        pthread_mutex_unlock(_lock);
    }

    return [nextEvent autorelease];
}

-(NSEvent *)currentEvent {
    /* Apps do use currentEvent from secondary threads and it doesn't crash on OS X, so we need to be safe here too. */
    NSEvent *result;

    pthread_mutex_lock(_lock);
    result=[_currentEvent retain];
    pthread_mutex_unlock(_lock);

    return [result autorelease];
}

-(void)discardEventsMatchingMask:(unsigned)mask beforeEvent:(NSEvent *)event {
    [_display discardEventsMatchingMask:mask beforeEvent:event];
}

-(void)postEvent:(NSEvent *)event atStart:(BOOL)atStart {
    [_display postEvent:event atStart:atStart];
}

-_searchForAction:(SEL)action responder:target {
    // Search a responder chain

    while (target != nil) {

        if ([target respondsToSelector:action])
            return target;

        if([target respondsToSelector:@selector(nextResponder)])
            target = [target nextResponder];
        else
            break;
    }

    return nil;
}

-_searchForAction:(SEL)action window:(NSWindow *)window {
    // Search a windows responder chain and window
    // The window check is done seperately from the responder chain
    // in case the responder chain is broken

    // FIXME: should a windows delegate and windowController be checked if a window is found in a responder chain too ?
    // Document based facts:
    //  An NSWindow's next responder should be the window controller
    //  An NSWindow's delegate should be the document
    // - This probably means the windowController check is duplicative, but need to make the next responder is window controller

    id check=[self _searchForAction:action responder:[window firstResponder]];

    if(check!=nil)
        return check;

    if ([[window delegate] respondsToSelector:action])
        return [window delegate];

    if ([[window windowController] respondsToSelector:action])
        return [window windowController];

    return nil;
}

-targetForAction:(SEL)action {
    return [self targetForAction:action to:nil from:nil];
}

-targetForAction:(SEL)action to:target from:sender {
    if (target == nil)
    {
        target = [self _searchForAction:action window:[self keyWindow]];
        if (target)
            return target;

        if ([self mainWindow] != [self keyWindow])
        {
            target = [self _searchForAction:action window:[self mainWindow]];
            if (target)
                return target;
        }
    }
    else
    {
        target = [self _searchForAction:action responder:target];
        if (target)
            return target;
    }

    if([self respondsToSelector:action])
        return self;

    if([[self delegate] respondsToSelector:action])
        return [self delegate];

    return nil;
}

-(BOOL)sendAction:(SEL)action to:target from:sender {
    if([target respondsToSelector:action])
    {
        [target performSelector:action withObject:sender];
        return YES;
    }

    target=[self targetForAction:action to:target from:sender];
    if (target != nil)
    {
        [target performSelector:action withObject:sender];
        return YES;
    }

    return NO;
}

-(BOOL)tryToPerform:(SEL)selector with:object {
    if ([self respondsToSelector:selector])
    {
        [self performSelector:selector withObject:object];
        return YES;
    }

    if ([[self delegate] respondsToSelector:selector])
    {
        [[self delegate] performSelector:selector withObject:object];
        return YES;
    }

    return NO;
}

-(void)setWindowsNeedUpdate:(BOOL)value {
    _windowsNeedUpdate=value;
    NSUnimplementedMethod();
}

-(void)updateWindows {
    [_windows makeObjectsPerformSelector:@selector(update)];
}

-(void)activateIgnoringOtherApps:(BOOL)flag {
    NSUnimplementedMethod();
}

-(void)deactivate {
    NSUnimplementedMethod();
}

-(NSWindow *)modalWindow {
    return [[_modalStack lastObject] modalWindow];
}

-(void)reportException:(NSException *)exception {
    NSLog(@"NSApplication got exception: %@",exception);
}

-(void)_attentionTimer:(NSTimer *)timer {
    [_windows makeObjectsPerformSelector:@selector(_flashWindow)];
}

-(int)requestUserAttention:(NSRequestUserAttentionType)attentionType {
    [_attentionTimer invalidate];
    _attentionTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(_attentionTimer:) userInfo:nil repeats:YES];

    return 0;
}

-(void)cancelUserAttentionRequest:(int)requestNumber {
    NSUnimplementedMethod();
}

-(void)orderFrontColorPanel:(id)sender {
//   [[NSColorPanel sharedColorPanel] orderFront:sender];
}

-(void)orderFrontCharacterPalette:sender {
    NSUnimplementedMethod();
}

-(void)hide:sender {//deactivates the application and hides all windows
    if (!_isHidden)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:NSApplicationWillHideNotification object:self];
        [_windows makeObjectsPerformSelector:@selector(_forcedHideForDeactivation)];//do no use orderOut here ist causes the application to quit if no window is visible
        [[NSNotificationCenter defaultCenter]postNotificationName:NSApplicationDidHideNotification object:self];
    }
    _isHidden=YES;

}

-(void)hideOtherApplications:sender {
    NSUnimplementedMethod();
}

-(void)unhide:sender
{

    if (_isHidden)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:NSApplicationWillUnhideNotification object:self];
        [_windows makeObjectsPerformSelector:@selector(_showForActivation)];//only shows previously hidden windows
        [[NSNotificationCenter defaultCenter]postNotificationName:NSApplicationDidUnhideNotification object:self];
    }
    _isHidden=NO;
    //[self activateIgnoringOtherApps:NO]

}

-(void)unhideAllApplications:sender {
    NSUnimplementedMethod();
}

-(void)unhideWithoutActivation {
    if (_isHidden)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:NSApplicationWillUnhideNotification object:self];
        [_windows makeObjectsPerformSelector:@selector(_showForActivation)];//only shows previously hidden windows
        [[NSNotificationCenter defaultCenter]postNotificationName:NSApplicationDidUnhideNotification object:self];
    }
    _isHidden=NO;
}

-(void)stop:sender {
    if([_modalStack lastObject]!=nil){
        [self stopModal];
        return;
    }

    _isRunning=NO;
}

-(void)terminate:sender
{
}

-(void)replyToApplicationShouldTerminate:(BOOL)terminate
{
    if (terminate == YES)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationWillTerminateNotification object:self];

        [NSClassFromString(@"Win32RunningCopyPipe") performSelector:@selector(invalidateRunningCopyPipe)];

        exit(0);
    }
}

-(void)replyToOpenOrPrint:(NSApplicationDelegateReply)reply {
    NSUnimplementedMethod();
}

-(void)arrangeInFront:sender {
#define CASCADE_DELTA	20		// ? isn't there a call for this?
    NSMutableArray *visibleWindows = [NSMutableArray new];
    NSRect rect=[[[NSScreen screens] objectAtIndex:0] frame], winRect;
    NSArray *windowsItems = [[self windowsMenu] itemArray];
    int i, count=[windowsItems count];

    for (i = 0 ; i < count; ++i) {
        id target = [[windowsItems objectAtIndex:i] target];

        if ([target isKindOfClass:[NSWindow class]])
        [visibleWindows addObject:target];
    }

    count = [visibleWindows count];
    if (count == 0)
        return;

    // find screen center.
    // subtract window w,h /2
    winRect = [[visibleWindows objectAtIndex:0] frame];
    rect.origin.x = (rect.size.width/2) - (winRect.size.width/2);
    rect.origin.x -= count*CASCADE_DELTA/2;
    rect.origin.x=floor(rect.origin.x);

    rect.origin.y = (rect.size.height/2) + (winRect.size.height/2);
    rect.origin.y += count*CASCADE_DELTA/2;
    rect.origin.y=floor(rect.origin.y);

    for (i = 0; i < count; ++i) {
        [[visibleWindows objectAtIndex:i] setFrameTopLeftPoint:rect.origin];
        [[visibleWindows objectAtIndex:i] orderFront:nil];

        rect.origin.x += CASCADE_DELTA;
        rect.origin.y -= CASCADE_DELTA;
    }
}

-(NSMenu *)servicesMenu {
    return [[NSApp mainMenu] _menuWithName:@"_NSServicesMenu"];
}

-(void)setServicesMenu:(NSMenu *)menu {
    NSUnimplementedMethod();
}

-servicesProvider {
    return nil;
}

-(void)setServicesProvider:provider {
}

-(void)registerServicesMenuSendTypes:(NSArray *)sendTypes returnTypes:(NSArray *)returnTypes {
    //tiredofthesewarnings NSUnsupportedMethod();
}

-validRequestorForSendType:(NSString *)sendType returnType:(NSString *)returnType {
    NSUnimplementedMethod();
    return nil;
}


-(void)orderFrontStandardAboutPanel:sender {
   [self orderFrontStandardAboutPanelWithOptions:nil];
}


-(void)activateContextHelpMode:sender {
    NSUnimplementedMethod();
}

#if 0
-(void)showGuessPanel:sender {
    [[[NSSpellChecker sharedSpellChecker] spellingPanel] makeKeyAndOrderFront: self];
}

-(void)showHelp:sender
{
    NSString *helpBookFolder = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleHelpBookFolder"];
    if(helpBookFolder != nil) {
        BOOL isDir;
        NSString *folder = [[NSBundle mainBundle] pathForResource:helpBookFolder ofType:nil];
        if(folder != nil && [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir] && isDir) {
                             NSBundle* helpBundle = [NSBundle bundleWithPath: folder];
                             if (helpBundle) {
                                 NSString *helpBookName = [[helpBundle infoDictionary] objectForKey:@"CFBundleHelpTOCFile"];
                                 if(helpBookName != nil) {
                                     NSString* helpFilePath = [helpBundle pathForResource: helpBookName ofType: nil];
                                     if (helpFilePath) {
                                         if([[NSWorkspace sharedWorkspace] openFile:helpFilePath withApplication:@"Help Viewer"]==YES) {
                                             return;
                                         }
                                     }
                                 }
                                 // Perhaps there's an index.html file that'll be usable?
                                 NSString* helpFilePath = [helpBundle pathForResource: @"index" ofType: @"html"];
                                 if (helpFilePath) {
                                     if([[NSWorkspace sharedWorkspace] openFile:helpFilePath withApplication:@"Help Viewer"]==YES) {
                                         return;
                                     }
                                 }
                             }
        }
    }

    NSString *processName = [[NSProcessInfo processInfo] processName];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText: NSLocalizedStringFromTableInBundle(@"Help", nil, [NSBundle bundleForClass: [NSApplication class]], @"Help alert title")];
    [alert setInformativeText:[NSString stringWithFormat: NSLocalizedStringFromTableInBundle(@"Help isn't available for %@.", nil, [NSBundle bundleForClass: [NSApplication class]], @""), processName]];
    [alert runModal];
    [alert release];
}
#endif

-(NSDockTile *)dockTile {
    return _dockTile;
}

- (void)doCommandBySelector:(SEL)selector {
    if ([_delegate respondsToSelector:selector])
           [_delegate performSelector:selector withObject:nil];
    else
        [super doCommandBySelector:selector];
}

-(void)_addWindow:(NSWindow *)window {
   [_windows addObject:window];
}

-(void)_windowWillBecomeActive:(NSWindow *)window {
    [_attentionTimer invalidate];
    _attentionTimer=nil;

    if(![self isActive]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationWillBecomeActiveNotification object:self];
    }
}

-(void)_windowDidBecomeActive:(NSWindow *)window {
   if(![self isActiveExcludingWindow:window]){
    [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationDidBecomeActiveNotification object:self];
   }
}

-(void)_windowWillBecomeDeactive:(NSWindow *)window {
   if(![self isActiveExcludingWindow:window]){
       [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationWillResignActiveNotification object:self];
   }
}

-(void)_windowDidBecomeDeactive:(NSWindow *)window {
    if(![self isActive]){

        // Exposed menus are running tight event tracking loops and would remain visible when the app deactivates (making
        // the UI less than community minded) - unfortunately because they're in these tracking loops they're waiting
        // on events and even though they could receive the notification sent here they can't deal with it until an event is
        // received to let them proceed. This special event type was added to help them get unstuck and remove the menu on
        // deactivation
        NSEvent* appKitEvent = [NSEvent otherEventWithType: NSAppKitDefined location: NSZeroPoint modifierFlags: 0 timestamp: 0 windowNumber: 0 context: nil subtype: NSApplicationDeactivated data1: 0 data2: 0];
        [self postEvent: appKitEvent atStart: YES];

        [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationDidResignActiveNotification object:self];
    }
}
//private method called when the application is reopened
-(void)_reopen
{
    BOOL doReopen=YES;
    if ([_delegate respondsToSelector:@selector(applicationShouldHandleReopen:hasVisibleWindows:)])
    doReopen=	[_delegate applicationShouldHandleReopen:self hasVisibleWindows:!_isHidden];
    if(!doReopen) return;
    if(_isHidden) [self unhide:nil];

}

@end

#if 0
int NSApplicationMain(int argc, const char *argv[]) {
    NSAutoreleasePool *pool=[NSAutoreleasePool new];
    NSBundle *bundle=[NSBundle mainBundle];
    Class     clazz=[bundle principalClass];
    NSString *nibFile=[[bundle infoDictionary] objectForKey:@"NSMainNibFile"];

    [NSClassFromString(@"Win32RunningCopyPipe") performSelector:@selector(startRunningCopyPipe)];

    if(clazz==Nil) {
        clazz=[NSApplication class];
    }

    [clazz sharedApplication];

    nibFile=[nibFile stringByDeletingPathExtension];

    if(![NSBundle loadNibNamed:nibFile owner:NSApp]) {
        NSLog(@"Unable to load main nib file %@",nibFile);
    }

    [pool release];

    [NSApp run];

    return 0;
}
#endif

void NSUpdateDynamicServices(void) {
    NSUnimplementedFunction();
}

BOOL NSPerformService(NSString *itemName, NSPasteboard *pasteboard) {
    NSUnimplementedFunction();
    return NO;
}
