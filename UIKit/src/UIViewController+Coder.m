//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#import <UIKit/UIViewController.h>
#import "UIViewController+Private.h"

#if defined(DEBUG)
#define EbrDebugLog(...) fprintf(stderr, __VA_ARGS__)
#else
#define EbrDebugLog(...)
#endif

@implementation UIViewController (Coder)

- (id)initWithCoder:(NSCoder*)coder {
    UIView* view = [coder decodeObjectForKey:@"UIView"];
    if(view) {
        self.view = view;
    }

    self.navigationItem = [coder decodeObjectForKey:@"UINavigationItem"];
    if (!self.navigationItem) {
        EbrDebugLog("UIVIewController navigationItem is %s\n", object_getClassName(self.navigationItem));
    }

    self.nibName = [coder decodeObjectForKey:@"UINibName"];
    self.tabBarItem = [coder decodeObjectForKey:@"UITabBarItem"];

    self.toolbarItems = [coder decodeObjectForKey:@"UIToolbarItems"];

    // TODO
    // if ([coder containsValueForKey:@"UIAutoresizesArchivedViewToFullSize"]) {
    //     self.autoresize = [coder decodeIntForKey:@"UIAutoresizesArchivedViewToFullSize"] != FALSE;
    // } else {
    //     self.autoresize = true;
    // }
    if ([coder containsValueForKey:@"UIWantsFullScreenLayout"]) {
        self.wantsFullScreenLayout = [coder decodeIntForKey:@"UIWantsFullScreenLayout"] != FALSE;
    };

    // self.modalTemplates = [coder decodeObjectForKey:@"UIStoryboardSegueTemplates"];
    NSDictionary* objs = [coder decodeObjectForKey:@"UIExternalObjectsTableForViewLoading"];
    if (objs != nil) {
         self.externalObjects = objs;
    }

    self.childViewControllers = [[coder decodeObjectForKey:@"UIChildViewControllers"] mutableCopy];
    // assert(nibName != nil);
    //self.edgesForExtendedLayout = [coder decodeIntForKey:@"UIKeyEdgesForExtendedLayout"];

    return self;
}

@end
