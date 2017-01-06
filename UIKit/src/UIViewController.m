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

#import "UIViewController+Private.h"
#import "UIApplication+UIPrivate.h"
#import "UIView+UIPrivate.h"
#import <UIKit/UIScreen.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIScreen.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIBarButtonItem.h>
#import <UIKit/UINavigationController.h>
#import <UIKit/UISplitViewController.h>
#import <UIKit/UIToolbar.h>
#import <UIKit/UIScreen.h>
#import <UIKit/UITabBarController.h>
#import <UIKit/UINib.h>
#import <QuartzCore/QuartzCore.h>
#import "UIAnimation.h"

typedef NS_ENUM(NSInteger, _UIViewControllerParentageTransition) {
    _UIViewControllerParentageTransitionNone = 0,
    _UIViewControllerParentageTransitionToParent,
    _UIViewControllerParentageTransitionFromParent,
};

@interface UIStoryboard(Private)
-(NSString*) _path;
@end

@implementation UIViewController {
    UIView *_view;
    UINavigationItem *_navigationItem;
    NSMutableArray *_childViewControllers;
    __unsafe_unretained UIViewController *_parentViewController;

    NSUInteger _appearanceTransitionStack;
    BOOL _appearanceTransitionIsAnimated;
    BOOL _viewIsAppearing;
    _UIViewControllerParentageTransition _parentageTransition;
    
    __weak UIViewController *_presentingViewController;
    UIViewController *_presentedViewController;

    UIInterfaceOrientation _interfaceOrientation;
    
    NSString *_nibName;
    NSBundle *_nibBundle;
}

- (id)init
{
    return [self initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    if ((self=[super init])) {
        _contentSizeForViewInPopover = CGSizeMake(320,1100);
        _hidesBottomBarWhenPushed = NO;
        _nibName = nibName;
        _nibBundle = nibBundle ?: [NSBundle mainBundle];
        _interfaceOrientation = UIInterfaceOrientationPortrait;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
    [_view _setViewController:nil];
}

- (NSString *)nibName
{
    return [_nibName copy];
}

- (void)setNibName:(NSString*)nibName
{
    _nibName = nibName;
}

- (UIResponder *)nextResponder
{
    return _view.superview;
}

- (UIViewController *)defaultResponderChildViewController
{
    return nil;
}

- (UIResponder *)defaultResponder
{
    return nil;
}

- (BOOL)isViewLoaded
{
    return (_view != nil);
}

- (UIView *)view
{
    if ([self isViewLoaded]) {
        return _view;
    } else {
        const BOOL wereEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [self loadView];
        [self performSelector:@selector(viewDidLoad) withObject:nil afterDelay:0];
        [UIView setAnimationsEnabled:wereEnabled];
        return _view;
    }
}

- (void)setView:(UIView *)aView
{
    if (aView != _view) {
        [_view _setViewController:nil];
        _view = aView;
        [_view _setViewController:self];
    }
}

// this code is originated from WinObjC
- (void)loadView
{
    if(_view) {
        return;
    }
    
    if(!_nibName) {
        self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        return;
    }
    
    NSString *path = [_nibBundle pathForResource:_nibName ofType:@"nib"];
    if(!path) {
        path = [[NSBundle mainBundle] pathForResource:_nibName ofType:@"nib"];
    }
    if(!path) {
        NSString* storyboardPath = [self.storyboard _path];
        if(storyboardPath) {
            NSString* runtimePath = [storyboardPath stringByAppendingPathComponent:_nibName];
            runtimePath = [runtimePath stringByAppendingString:@".nib"];
            path = [[NSBundle mainBundle] pathForResource:@"runtime" ofType:@"nib" inDirectory:runtimePath];
            if(!path) {
                path = [[NSBundle mainBundle] pathForResource:_nibName ofType:@"nib" inDirectory:storyboardPath];
            }
        }
    }
    if(!path) {
        assert(0);
    }
    
    NSMutableDictionary *proxies = [NSMutableDictionary dictionaryWithDictionary:@{ @"UIStoryboardPlaceholder": self.storyboard}];
    [proxies addEntriesFromDictionary:self.externalObjects];
    UINib *nib = [[UINib alloc] init];
    [nib loadNib:path withOwner:self proxies:proxies];
    self.externalObjects = nil;
}

- (void)viewDidLoad
{
}

- (void)viewDidUnload
{
}

- (void)didReceiveMemoryWarning
{
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)viewWillLayoutSubviews
{
}

- (void)viewDidLayoutSubviews
{
}

- (UIInterfaceOrientation)interfaceOrientation
{
    return _interfaceOrientation;
}

- (UINavigationItem *)navigationItem
{
    if (!_navigationItem) {
        _navigationItem = [[UINavigationItem alloc] initWithTitle:self.title];
    }
    return _navigationItem;
}

- (void)setNavigationItem:(UINavigationItem*)navigationItem
{
    _navigationItem = navigationItem;
}

- (void)setTitle:(NSString *)title
{
    if (![_title isEqual:title]) {
        _title = [title copy];
        _navigationItem.title = _title;
    }
}

- (void)setToolbarItems:(NSArray *)theToolbarItems animated:(BOOL)animated
{
    if (![_toolbarItems isEqual:theToolbarItems]) {
        _toolbarItems = theToolbarItems;
        [self.navigationController.toolbar setItems:_toolbarItems animated:animated];
    }
}

- (void)setToolbarItems:(NSArray *)theToolbarItems
{
    [self setToolbarItems:theToolbarItems animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    _editing = editing;
}

- (void)setEditing:(BOOL)editing
{
    [self setEditing:editing animated:NO];
}

- (UIBarButtonItem *)editButtonItem
{
    // this should really return a fancy bar button item that toggles between edit/done and sends setEditing:animated: messages to this controller
    return nil;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (!_presentedViewController && viewControllerToPresent != self) {
        _presentedViewController = viewControllerToPresent;
        [_presentedViewController _setPresentingViewController:self];

        UIWindow *window = self.view.window;
        UIView *selfView = self.view;
        UIView *newView = _presentedViewController.view;

        newView.autoresizingMask = selfView.autoresizingMask;
        newView.frame = _wantsFullScreenLayout? window.screen.bounds : window.screen.applicationFrame;

        [window addSubview:newView];
        [_presentedViewController viewWillAppear:animated];

        [self viewWillDisappear:animated];
        
        [CATransaction begin];
        
        selfView.layer.doubleSided = NO;
        newView.layer.doubleSided = NO;
        
        [CATransaction setCompletionBlock:^{
            //selfView.hidden = YES;		// I think the real one may actually remove it, which would mean needing to remember the superview, I guess? Not sure...
            
            [self viewDidDisappear:animated];

            [_presentedViewController viewDidAppear:animated];
            
            if(completion) {
                completion();
            }
        }];
        
        UIModalTransitionStyle style = _presentedViewController.modalTransitionStyle;
        switch(style) {
        case UIModalTransitionStyleFlipHorizontal:
            [selfView.layer addAnimation:[UIAnimation frontToBackClockwise] forKey:nil];
            [newView.layer addAnimation:[UIAnimation backToFrontClockwise] forKey:nil];
            break;
        case UIModalTransitionStyleCrossDissolve:
            break;
        case UIModalTransitionStyleCoverVertical:
        case UIModalTransitionStylePartialCurl:
        default:
            NSLog(@"%s Unsupported modalTransitionStyle %d", __FUNCTION__, style);
        }
        
        [CATransaction commit];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (_presentedViewController) {

        // if the modalViewController being dismissed has a modalViewController of its own, then we need to go dismiss that, too.
        // otherwise things can be left hanging around.
        if (_presentedViewController.presentedViewController) {
            [_presentedViewController dismissViewControllerAnimated:animated completion:nil];
        }

        [self viewWillAppear:animated];
        
        UIView *selfView = self.view;
        UIView *currentView = _presentedViewController.view;
        
        [CATransaction begin];
        
        selfView.hidden = NO;
        selfView.layer.doubleSided = NO;
        currentView.layer.doubleSided = NO;
        
        [CATransaction setCompletionBlock:^{

            [_presentedViewController.view removeFromSuperview];
            [_presentedViewController _setPresentingViewController:nil];
            _presentedViewController = nil;
            
            [self viewDidAppear:animated];
            
            if(completion) {
                completion();
            }
        }];
        
        UIModalTransitionStyle style = _presentedViewController.modalTransitionStyle;
        if(!style || style == UIModalTransitionStyleFlipHorizontal) {
            [selfView.layer addAnimation:[UIAnimation backToFrontCounterClockwise] forKey:nil];
            [currentView.layer addAnimation:[UIAnimation frontToBackCounterClockwise] forKey:nil];
        } else {
            NSLog(@"%s Unsupported modalTransitionStyle %d", __FUNCTION__, style);
        }
        
        [CATransaction commit];
    } else if(_presentingViewController) {
        [_presentingViewController dismissViewControllerAnimated:animated completion:completion];
    } else {
        [self.parentViewController dismissViewControllerAnimated:animated completion:completion];
    }

}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    /*
    if (!_modalViewController && _modalViewController != self) {
        _modalViewController = modalViewController;
        [_modalViewController _setParentViewController:self];

        UIWindow *window = self.view.window;
        UIView *selfView = self.view;
        UIView *newView = _modalViewController.view;

        newView.autoresizingMask = selfView.autoresizingMask;
        newView.frame = _wantsFullScreenLayout? window.screen.bounds : window.screen.applicationFrame;

        [window addSubview:newView];
        [_modalViewController viewWillAppear:animated];

        [self viewWillDisappear:animated];
        selfView.hidden = YES;		// I think the real one may actually remove it, which would mean needing to remember the superview, I guess? Not sure...
        [self viewDidDisappear:animated];

        [_modalViewController viewDidAppear:animated];
    }
     */
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    /*
    // NOTE: This is not implemented entirely correctly - the actual dismissModalViewController is somewhat subtle.
    // There is supposed to be a stack of modal view controllers that dismiss in a specific way,e tc.
    // The whole system of related view controllers is not really right - not just with modals, but everything else like
    // navigationController, too, which is supposed to return the nearest nav controller down the chain and it doesn't right now.

    if (_modalViewController) {

        // if the modalViewController being dismissed has a modalViewController of its own, then we need to go dismiss that, too.
        // otherwise things can be left hanging around.
        if (_modalViewController.modalViewController) {
            [_modalViewController dismissModalViewControllerAnimated:animated];
        }

        self.view.hidden = NO;
        [self viewWillAppear:animated];

        [_modalViewController.view removeFromSuperview];
        [_modalViewController _setParentViewController:nil];
        _modalViewController = nil;

        [self viewDidAppear:animated];
    } else {
        [self.parentViewController dismissModalViewControllerAnimated:animated];
    }
     */
}

- (void)_updateOrientation:(BOOL)forceUpdate
{
    if(!forceUpdate && !self.shouldAutorotate) return;

    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];

    UIInterfaceOrientationMask supportedInterfaceOrientations = [[UIApplication sharedApplication] _supportedInterfaceOrientations] & [self _supportedInterfaceOrientations];

    assert(supportedInterfaceOrientations);

    if((1<<deviceOrientation) & supportedInterfaceOrientations) {
        _interfaceOrientation = deviceOrientation;
    } else if(forceUpdate) {
        if(UIInterfaceOrientationMaskPortrait & supportedInterfaceOrientations) {
            _interfaceOrientation = UIInterfaceOrientationPortrait;
        } else if(UIInterfaceOrientationMaskLandscapeLeft & supportedInterfaceOrientations) {
            _interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        } else if(UIInterfaceOrientationMaskLandscapeRight & supportedInterfaceOrientations) {
            _interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        } else if(UIInterfaceOrientationMaskPortraitUpsideDown & supportedInterfaceOrientations) {
            _interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
        }
    }
}

+ (BOOL)_implementsShouldAutorotateToInterfaceOrientation
{
    return [UIViewController instanceMethodForSelector:@selector(shouldAutorotateToInterfaceOrientation:)]
        != [self instanceMethodForSelector:@selector(shouldAutorotateToInterfaceOrientation:)];
}

- (UIInterfaceOrientationMask)_supportedInterfaceOrientations
{
    // if subclass dares implementing shouldAutorotateToInterfaceOrientation, it means <iOS6 apps.
    if([[self class] _implementsShouldAutorotateToInterfaceOrientation]) {
        UIInterfaceOrientationMask mask = 0;
        if([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait])
            mask |= UIInterfaceOrientationMaskPortrait;
        if([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown])
            mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
        if([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft])
            mask |= UIInterfaceOrientationMaskLandscapeLeft;
        if([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight])
            mask |= UIInterfaceOrientationMaskLandscapeRight;
        return mask;
    } else {
        return [self supportedInterfaceOrientations];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}

- (id)_nearestParentViewControllerThatIsKindOf:(Class)c
{
    UIViewController *controller = _parentViewController;

    while (controller && ![controller isKindOfClass:c]) {
        controller = [controller parentViewController];
    }

    return controller;
}

- (UINavigationController *)navigationController
{
    return [self _nearestParentViewControllerThatIsKindOf:[UINavigationController class]];
}

- (UISplitViewController *)splitViewController
{
    return [self _nearestParentViewControllerThatIsKindOf:[UISplitViewController class]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; title = %@; view = %@>", [self class], self, self.title, self.view];
}






- (BOOL)isMovingFromParentViewController
{
    // Docs don't say anything about being required to call super for -willMoveToParentViewController: and people
    // on StackOverflow seem to tell each other they can override the method without calling super. Based on that,
    // I have no freakin' idea how this method here is meant to know when to return YES...

    // I'm inclined to think that the docs are just unclear and that -willMoveToParentViewController: and
    // -didMoveToParentViewController: must have to do *something* for this to work without ambiguity.

    // Now that I think about it some more, I suspect that it is far better to assume the docs imply you must call
    // super when you override a method *unless* it says not to. If that assumption is sound, then in that case it
    // suggests that when overriding -willMoveToParentViewController: and -didMoveToParentViewController: you are
    // expected to call super anyway, which means I could put some implementation in the base class versions safely.
    // Generally docs do tend to say things like, "parent implementation does nothing" when they mean you can skip
    // the call to super, and the docs currently say no such thing for -will/didMoveToParentViewController:.

    // In all likely hood, all that would happen if you didn't call super from a -will/didMoveToParentViewController:
    // override is that -isMovingFromParentViewController and -isMovingToParentViewController would return the
    // wrong answer, and if you never use them, you'll never even notice that bug!

    return (_appearanceTransitionStack > 0) && (_parentageTransition == _UIViewControllerParentageTransitionFromParent);
}

- (BOOL)isMovingToParentViewController
{
    return (_appearanceTransitionStack > 0) && (_parentageTransition == _UIViewControllerParentageTransitionToParent);
}

- (BOOL)isBeingPresented
{
    // TODO
    return (_appearanceTransitionStack > 0) && (NO);
}

- (BOOL)isBeingDismissed
{
    // TODO
    return (_appearanceTransitionStack > 0) && (NO);
}

- (UIViewController *)presentingViewController
{
    return _presentingViewController;
}

- (void)_setPresentingViewController:(UIViewController *)viewController
{
    _presentingViewController = viewController;
}

- (UIViewController *)presentedViewController
{
    return _presentedViewController;
}

- (void)_setPresentedViewController:(UIViewController *)viewController
{
    _presentedViewController = viewController;
}

- (NSArray *)childViewControllers
{
    return [_childViewControllers copy];
}

- (void)addChildViewController:(UIViewController *)childController
{
    NSAssert(childController != nil, @"cannot add nil child view controller");
    NSAssert(childController.parentViewController == nil, @"thou shalt have no other parent before me");

    if (!_childViewControllers) {
        _childViewControllers = [NSMutableArray arrayWithCapacity:1];
    }

    [childController willMoveToParentViewController:self];
    [_childViewControllers addObject:childController];
    childController->_parentViewController = self;
}

- (void)_removeFromParentViewController
{
    if (_parentViewController) {
        [_parentViewController->_childViewControllers removeObject:self];

        if ([_parentViewController->_childViewControllers count] == 0) {
            _parentViewController->_childViewControllers = nil;
        }

        _parentViewController = nil;
    }
}

- (void)removeFromParentViewController
{
    NSAssert(self.parentViewController != nil, @"view controller has no parent");

    [self _removeFromParentViewController];
    [self didMoveToParentViewController:nil];
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    NSAssert(fromViewController.parentViewController == toViewController.parentViewController && fromViewController.parentViewController != nil, @"child controllers must share common parent");
    const BOOL animated = (duration > 0);

    [fromViewController beginAppearanceTransition:NO animated:animated];
    [toViewController beginAppearanceTransition:YES animated:animated];

    [UIView transitionWithView:self.view
                      duration:duration
                       options:options
                    animations:^{
                        if (animations) {
                            animations();
                        }

                        [self.view addSubview:toViewController.view];
                    }
                    completion:^(BOOL finished) {
                        if (completion) {
                            completion(finished);
                        }

                        [fromViewController.view removeFromSuperview];

                        [fromViewController endAppearanceTransition];
                        [toViewController endAppearanceTransition];
                    }];
}

- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated
{
    if (_appearanceTransitionStack == 0 || (_appearanceTransitionStack > 0 && _viewIsAppearing != isAppearing)) {
        _appearanceTransitionStack = 1;
        _appearanceTransitionIsAnimated = animated;
        _viewIsAppearing = isAppearing;

        if ([self shouldAutomaticallyForwardAppearanceMethods]) {
            for (UIViewController *child in self.childViewControllers) {
                if ([child isViewLoaded] && [child.view isDescendantOfView:self.view]) {
                    [child beginAppearanceTransition:isAppearing animated:animated];
                }
            }
        }

        if (_viewIsAppearing) {
            [self view];    // ensures the view is loaded before viewWillAppear: happens
            [self viewWillAppear:_appearanceTransitionIsAnimated];
        } else {
            [self viewWillDisappear:_appearanceTransitionIsAnimated];
        }
    } else {
        _appearanceTransitionStack++;
    }
}

- (void)endAppearanceTransition
{
    if (_appearanceTransitionStack > 0) {
        _appearanceTransitionStack--;

        if (_appearanceTransitionStack == 0) {
            if ([self shouldAutomaticallyForwardAppearanceMethods]) {
                for (UIViewController *child in self.childViewControllers) {
                    [child endAppearanceTransition];
                }
            }

            if (_viewIsAppearing) {
                [self viewDidAppear:_appearanceTransitionIsAnimated];
            } else {
                [self viewDidDisappear:_appearanceTransitionIsAnimated];
            }
        }
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent) {
        _parentageTransition = _UIViewControllerParentageTransitionToParent;
    } else {
        _parentageTransition = _UIViewControllerParentageTransitionFromParent;
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    _parentageTransition = _UIViewControllerParentageTransitionNone;
}

- (void)setStoryboard:(UIStoryboard*)storyboard
{
    _storyboard = storyboard;
    [self view]; // hack to load view before calling awakeFromNib
}

@end
