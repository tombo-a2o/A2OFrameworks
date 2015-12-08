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
#import <UIKit/UINavigationBar.h>


@interface UINavigationController(Coder)
@property (nonatomic) UINavigationBar *navigationBar;
@property (nonatomic) UIToolbar *toolbar;
@end

@implementation UINavigationController(Coder)

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];

    self.navigationBar = [coder decodeObjectForKey:@"UINavigationBar"];
    [self.navigationBar setDelegate:self];
    
    self.viewControllers = [coder decodeObjectForKey:@"UIViewControllers"];
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

    //[self setViewControllers:viewControllers animated:YES];
    //priv->_wantsFullScreenLayout = YES;

    return self;
}

@end
