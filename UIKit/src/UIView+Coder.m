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

#import <UIKit/UIView.h>
#import <UIKit/NSLayoutConstraint.h>

#if defined(DEBUG)
#define EbrDebugLog(...) fprintf(stderr, __VA_ARGS__)
#else
#define EbrDebugLog(...)
#endif

@implementation UIView (Coder)

- (id)initWithCoder:(NSCoder*)coder {
    CGRect bounds;

    id boundsObj = [coder decodeObjectForKey:@"UIBounds"];
    if (boundsObj != nil) {
        if ([boundsObj isKindOfClass:[NSString class]]) {
            bounds = CGRectFromString(boundsObj);
        } else {
            //assert(0);
            memcpy(&bounds, (const char*)[boundsObj bytes] + 1, sizeof(CGRect));
        }
    } else {
        bounds.origin.x = 0;
        bounds.origin.y = 0;
        bounds.size.width = 0;
        bounds.size.height = 0;
    }

    CGPoint center;

    id centerObj = [coder decodeObjectForKey:@"UICenter"];
    if (centerObj) {
        if ([centerObj isKindOfClass:[NSString class]]) {
            center = CGPointFromString(centerObj);
        } else {
            memcpy(&center, (const char*)[centerObj bytes] + 1, sizeof(CGPoint));
        }
    } else {
        center.x = 0;
        center.y = 0;
    }

    //PAUSE_ANIMATIONS();
    [self setBounds:bounds];
    [self setCenter:center];
    [self setNeedsDisplay];
    if ([coder containsValueForKey:@"UIAlpha"]) {
        float val = [coder decodeFloatForKey:@"UIAlpha"];
        [self setAlpha:val];
    }
    if ([coder containsValueForKey:@"UIContentStretch"]) {
        CGRect rect;

        id obj = [coder decodeObjectForKey:@"UIContentStretch"];
        if ([obj isKindOfClass:[NSString class]]) {
            rect = CGRectFromString(obj);
        } else {
            memcpy(&rect, (char*)[obj bytes] + 1, sizeof(CGRect));
        }

        [self setContentStretch:rect];
    }

    //CONTINUE_ANIMATIONS();

    if ([coder decodeInt32ForKey:@"UIUserInteractionDisabled"]) {
        self.userInteractionEnabled = NO;
    }

    self.contentMode = (UIViewContentMode)[coder decodeInt32ForKey:@"UIContentMode"];

    id uiDelegate = [coder decodeObjectForKey:@"UIDelegate"];
    if (uiDelegate != nil) {
        if ([self respondsToSelector:@selector(setDelegate:)]) {
            [self performSelector:@selector(setDelegate:) withObject:uiDelegate];
        } else {
            EbrDebugLog("UIDelegate decoded but %s doens't support setDelegate!\n", object_getClassName(self));
        }
    }

    NSArray* subviewsObj = [coder decodeObjectForKey:@"UISubviews"];
    if (subviewsObj != nil) {
        int count = [subviewsObj count];

        for (int i = 0; i < count; i++) {
            UIView* subView = [subviewsObj objectAtIndex:i];
            [self addSubview:subView];
        }
    }

    // TODO ???
    // if ([coder containsValueForKey:@"UIViewDoesNotTranslateAutoresizingMaskIntoConstraints"]) {
    //     priv->translatesAutoresizingMaskIntoConstraints =
    //         ![coder decodeInt32ForKey:@"UIViewDoesNotTranslateAutoresizingMaskIntoConstraints"];
    // }

    // TODO ???
    // if ([self conformsToProtocol:@protocol(AutoLayoutView)]) {
    //     [self autoLayoutInitWithCoder:coder];
    // }

    if ([coder containsValueForKey:@"UIViewAutolayoutConstraints"]) {
        EbrDebugLog("constraints is not supported yet!");
        // NSArray* constraints = [coder decodeObjectForKey:@"UIViewAutolayoutConstraints"];
        // NSArray* removeConstraints = [coder decodeObjectForKey:@"_UILayoutGuideConstraintsToRemove"];
        // int count = [constraints count];
        // for (int i = 0; i < count; i++) {
        //     NSLayoutConstraint* constraint = [constraints objectAtIndex:i];
        //     if ([constraint isKindOfClass:[NSLayoutConstraint class]]) {
        //         bool remove = false;
        //         for (int i = 0; i < [removeConstraints count]; i++) {
        //             NSLayoutConstraint* wayward = [removeConstraints objectAtIndex:i];
        //             if (wayward == constraint) {
        //                 EbrDebugLog("Removing constraint (%s): \n", [[wayward description] UTF8String]);
        //                 //[wayward printConstraint];
        //                 remove = true;
        //                 break;
        //             }
        //         }
        // 
        //         if (![priv->constraints containsObject:constraint] && !remove) {
        //             [priv->constraints addObject:constraint];
        //             if ([constraint conformsToProtocol:@protocol(AutoLayoutConstraint)]) {
        //                 [constraint autoLayoutConstraintAddedToView:self];
        //             }
        //         }
        //     } else {
        //         EbrDebugLog("Skipping unsupported constraint type: %s\n", [[constraint description] UTF8String]);
        //     }
        // }
    }

//    [NSLayoutConstraint printConstraints:self.constraints];

    [self setHidden:[coder decodeInt32ForKey:@"UIHidden"]];

    self.autoresizesSubviews = [coder decodeInt32ForKey:@"UIAutoresizeSubviews"];
    self.autoresizingMask = (UIViewAutoresizing)[coder decodeInt32ForKey:@"UIAutoresizingMask"];
    self.tag = [coder decodeInt32ForKey:@"UITag"];
    self.multipleTouchEnabled = [coder decodeInt32ForKey:@"UIMultipleTouchEnabled"];

    [self setOpaque:[coder decodeInt32ForKey:@"UIOpaque"]];
    [self setClipsToBounds:[coder decodeInt32ForKey:@"UIClipsToBounds"]];

    UIColor* backgroundColor = [coder decodeObjectForKey:@"UIBackgroundColor"];
    if (backgroundColor != nil) {
        self.backgroundColor = backgroundColor;
    }

    NSArray* gestures = [coder decodeObjectForKey:@"gestureRecognizers"];
    if (gestures != nil) {
        EbrDebugLog("UIView initWithCoder adding gesture recognizers\n");
        [self setGestureRecognizers:gestures];
    }

    return self;
}

@end
