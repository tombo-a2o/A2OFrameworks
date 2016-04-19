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

#import <UIKit/UINavigationController.h>
#import "UINavigationController+Private.h"
#import "UIViewController+Private.h"
#import <UIKit/UINavigationBar.h>


@interface UINavigationController(Coder)
@property (nonatomic) UINavigationBar *navigationBar;
@property (nonatomic) UIToolbar *toolbar;
@end

@implementation UINavigationController(Coder)

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];

    //self.viewControllers = [coder decodeObjectForKey:@"UIViewControllers"];

    self.navigationBar = [coder decodeObjectForKey:@"UINavigationBar"];
    [self.navigationBar setDelegate:self];
    
    if ([coder decodeObjectForKey:@"UINavigationBarHidden"]) {
        [self.navigationBar setHidden:YES];
    }

    if ([coder containsValueForKey:@"UIToolbar"]) {
        self.toolbar = [coder decodeObjectForKey:@"UIToolbar"];
    } else {
        self.toolbar = [[UIToolbar alloc] init];
    }
    if ([coder decodeIntForKey:@"UIToolbarShown"]) {
        [self.toolbar setHidden:NO];
    } else {
        [self.toolbar setHidden:YES];
    }

    // childViewControllers should be cleared to run viewController initialization in setViewControllers
    // because it is used as a container of viewControllers and assigned in [UIViewController -initWithCoder]
    // and setViewControllers initializes controllers only when current and new viewControllers are different.
    self.childViewControllers = [[NSMutableArray alloc] init];
    NSArray* viewControllers = [coder decodeObjectForKey:@"UIViewControllers"];
    [self setViewControllers:viewControllers animated:NO];
    //priv->_wantsFullScreenLayout = YES;
    
    self.toolbarHidden = YES;

    return self;
}

@end
