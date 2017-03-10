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

#import <UIKit/UIScreen.h>
#import "UIImage+UIPrivate.h"
#import <UIKit/UIImageView.h>
#import <UIKit/UIApplication.h>
#import "UIViewLayoutManager.h"
#import "UIScreenMode+UIPrivate.h"
#import <UIKit/UIWindow.h>
#import "UIView+UIPrivate.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayerContext.h>
#import <emscripten.h>
#import <emscripten/html5.h>
#import <QuartzCore/CATransform3D.h>

NSString *const UIScreenDidConnectNotification = @"UIScreenDidConnectNotification";
NSString *const UIScreenDidDisconnectNotification = @"UIScreenDidDisconnectNotification";
NSString *const UIScreenModeDidChangeNotification = @"UIScreenModeDidChangeNotification";

@interface UIScreen()
@property (nonatomic, readwrite) CGRect bounds;
@property (nonatomic, readwrite) CGFloat scale;
@property (nonatomic, readwrite) NSArray *availableModes;
@end

@implementation UIScreen {
    NSMutableArray *_windows;
     __weak UIWindow *_keyWindow;
    CALayerContext *_layerContext;
    CALayer *_rootLayer;
    UIInterfaceOrientation _orientation;
    CGAffineTransform _touchTransform;
}

+ (UIScreen *)mainScreen
{
    static UIScreen *screen = nil;
    if(!screen) {
        screen = [[UIScreen alloc] init];
    }
    return screen;
}

+ (NSArray *)screens
{
    return @[[UIScreen mainScreen]];
}

- (id)init
{
    if ((self = [super init])) {
        _windows = [[NSMutableArray alloc] init];
        _brightness = 1;

        NSArray* userModes = [UIScreenMode _userDefinedModes];
        if(userModes) {
            _preferredMode = userModes[0];
            _availableModes = userModes;
        } else {
            UIScreenMode *defaultMode = [UIScreenMode screenModeIphone5];
            _preferredMode = defaultMode;
            _availableModes = @[defaultMode];
        }
        _rootLayer = [CALayer layer];
        _orientation = UIInterfaceOrientationPortrait;
        self.currentMode = _preferredMode;

        // should not here?
        EmscriptenWebGLContextAttributes attr;
        emscripten_webgl_init_context_attributes(&attr);
        attr.enableExtensionsByDefault = 1;
        attr.premultipliedAlpha = 0;
        attr.alpha = 0;
        attr.stencil = 1;
        EMSCRIPTEN_WEBGL_CONTEXT_HANDLE webglContext = emscripten_webgl_create_context(0, &attr);
        emscripten_webgl_make_context_current(webglContext);
        EM_ASM({
            Module.useWebGL = true;
            Browser.moduleContextCreatedCallbacks.forEach(function(callback) { callback() });
        });

        _rootLayer.frame = self.bounds;
        _rootLayer.contentsScale = self.scale;
        _rootLayer.delegate = self;
        _rootLayer.anchorPoint = CGPointMake(0,0);
        
        _layerContext = [[CALayerContext alloc] initWithLayer:_rootLayer];
    }
    return self;
}

- (void)_updateScreenSize
{
    UIInterfaceOrientation interfaceOrientation = _orientation;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    float scale = _currentMode.pixelAspectRatio;
    CGSize physicalSize = _currentMode.size; // ex. 640x1136 (on iPhone5)
    CGSize logicalSize = _currentMode.logicalSize; // ex. 320x568 (on iPhone5)
    CGSize canvasSize; // ex 320x568(portrait), 568x320(landscape)
    if(UIDeviceOrientationIsPortrait(deviceOrientation)) {
        emscripten_set_canvas_size(physicalSize.width, physicalSize.height);
        canvasSize.width = logicalSize.width;
        canvasSize.height = logicalSize.height;
    } else {
        emscripten_set_canvas_size(physicalSize.height, physicalSize.width);
        canvasSize.width = logicalSize.height;
        canvasSize.height = logicalSize.width;
    }
    emscripten_set_element_css_size(NULL, canvasSize.width, canvasSize.height);

    _scale = scale;
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        _bounds.size.width = logicalSize.width;
        _bounds.size.height = logicalSize.height;
    } else {
        _bounds.size.width = logicalSize.height;
        _bounds.size.height = logicalSize.width;
    }

    _rootLayer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    _rootLayer.contentsScale = scale;

    float angles[] = {0, 0, M_PI, M_PI_2*3, M_PI_2};
    float angle = angles[deviceOrientation] - angles[interfaceOrientation];
    
    CGAffineTransform transform =
        CGAffineTransformTranslate(
            CGAffineTransformRotate(
                CGAffineTransformMakeTranslation(
                     -_bounds.size.width/2, -_bounds.size.height/2
                ),
                angle
            ),
            canvasSize.width/2, canvasSize.height/2
        );
        
    _rootLayer.sublayerTransform = CATransform3DMakeAffineTransform(transform);
    _touchTransform = CGAffineTransformInvert(transform);
}

- (id)actionForLayer:(CALayer *)theLayer forKey:(NSString *)event
{
    return [NSNull null];
}

- (void)setCurrentMode:(UIScreenMode*)mode
{
    if(_currentMode != mode) {
        NSDictionary *userInfo = (self.currentMode)? [NSDictionary dictionaryWithObject:_currentMode forKey:@"_previousMode"] : nil;
        _currentMode = mode;

        [self _updateScreenSize];

        [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenModeDidChangeNotification object:self userInfo:userInfo];
    }
}

- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    _orientation = orientation;

    [self _updateScreenSize];
}

- (UIInterfaceOrientation)orientation
{
    return _orientation;
}

- (CGRect)applicationFrame
{
    const float statusBarHeight = [UIApplication sharedApplication].statusBarHidden? 0 : 20;
    const CGSize size = [self bounds].size;
    return CGRectMake(0,statusBarHeight,size.width,size.height-statusBarHeight);
}

- (void)_NSScreenDidChange
{
    [self.windows makeObjectsPerformSelector:@selector(_didMoveToScreen)];
}

// [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenDidConnectNotification object:self];
// [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenDidDisconnectNotification object:self];

- (void)_addWindow:(UIWindow *)window
{
    [_windows addObject:[NSValue valueWithNonretainedObject:window]];
    [_rootLayer addSublayer:window.layer];
}

- (void)_removeWindow:(UIWindow *)window
{
    if (_keyWindow == window) {
        _keyWindow = nil;
    }

    [_windows removeObject:[NSValue valueWithNonretainedObject:window]];
    [window.layer removeFromSuperlayer];
}

- (NSArray *)windows
{
    return [_windows valueForKey:@"nonretainedObjectValue"];
}

- (UIWindow *)keyWindow
{
    return _keyWindow;
}

- (void)_setKeyWindow:(UIWindow *)window
{
    NSAssert([self.windows containsObject:window], @"cannot set key window to a window not on this screen");
    _keyWindow = window;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; bounds = %@; mode = %@>", [self class], self, NSStringFromCGRect(self.bounds), self.currentMode];
}

- (void)_display
{
    [_layerContext render];
}

- (CGPoint)_convertCanvasLocation:(long)x y:(long)y
{
    return CGPointApplyAffineTransform(CGPointMake(x,y), _touchTransform);
}
@end
