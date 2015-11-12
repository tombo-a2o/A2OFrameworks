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

@interface UIAlertView()
- (void)_closeWithResult:(NSInteger)result;
@end

@interface _UIAlertWindow : UIWindow
@end

@implementation _UIAlertWindow
@end


@interface _UIAlertViewController : UIViewController
-(instancetype)initWithAlertView:(UIAlertView*)alertView;
@property(nonatomic,retain) UIAlertView *alertView;
@end

@implementation _UIAlertViewController

-(instancetype)initWithAlertView:(UIAlertView*)alertView {
    self = [super init];
    _alertView = alertView;
    return self;
}

static void adjustHeight(UIView* view, CGFloat width) {
    CGSize size = [view sizeThatFits:CGSizeMake(width,1000)];
    CGRect rect = view.frame;
    rect.size.height = size.height;
    view.frame = rect;
}

- (void)viewDidLoad {
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(30,115,260,260)];
    rootView.backgroundColor = [UIColor whiteColor];
    rootView.layer.cornerRadius = 10;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 50)];
    titleLabel.text = _alertView.title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.numberOfLines = 0;
    adjustHeight(titleLabel, 230);
    [rootView addSubview:titleLabel];

    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+5, 240, 80)];
    messageLabel.text = _alertView.message;
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.font = [UIFont systemFontOfSize:13];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    messageLabel.numberOfLines = 0;
    adjustHeight(messageLabel, 240);
    [rootView addSubview:messageLabel];

    CGFloat top = CGRectGetMaxY(messageLabel.frame)+20;

    for(int i = 0; i < _alertView.numberOfButtons; i++) {
        NSString *title = [_alertView buttonTitleAtIndex:i];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, top, 260, 42)];
        button.tag = i;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        if(i == _alertView.cancelButtonIndex) {
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [rootView addSubview:button];

        UIView *hr = [[UIView alloc] initWithFrame:CGRectMake(0, top, 260, 1)];
        hr.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [rootView addSubview:hr];

        top = CGRectGetMaxY(button.frame);
    }
    CGRect frame = rootView.frame;
    frame.size.height = top;
    rootView.frame = frame;
    rootView.center = self.view.center;

    [self.view addSubview:rootView];
}

- (void)close:(UIButton*)sender {
    [_alertView _closeWithResult:sender.tag];
}

@end



@implementation UIAlertView {
    NSMutableArray *_buttonTitles;

    struct {
        unsigned clickedButtonAtIndex : 1;
        unsigned alertViewCancel : 1;
        unsigned willPresentAlertView : 1;
        unsigned didPresentAlertView : 1;
        unsigned willDismissWithButtonIndex : 1;
        unsigned didDismissWithButtonIndex : 1;
    } _delegateHas;

    _UIAlertViewController *_controller;
    _UIAlertWindow *_window;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if ((self=[super initWithFrame:CGRectZero])) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        _buttonTitles = [NSMutableArray arrayWithCapacity:1];

        if (otherButtonTitles) {
            [self addButtonWithTitle:otherButtonTitles];

            id buttonTitle = nil;
            va_list argumentList;
            va_start(argumentList, otherButtonTitles);

            while ((buttonTitle=va_arg(argumentList, NSString *))) {
                [self addButtonWithTitle:buttonTitle];
            }

            va_end(argumentList);
        }

        if (cancelButtonTitle) {
            self.cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
        }
    }
    return self;
}


- (void)setDelegate:(id<UIAlertViewDelegate>)newDelegate
{
    _delegate = newDelegate;
    _delegateHas.clickedButtonAtIndex = [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)];
    _delegateHas.alertViewCancel = [_delegate respondsToSelector:@selector(alertViewCancel:)];
    _delegateHas.willPresentAlertView = [_delegate respondsToSelector:@selector(willPresentAlertView:)];
    _delegateHas.didPresentAlertView = [_delegate respondsToSelector:@selector(didPresentAlertView:)];
    _delegateHas.willDismissWithButtonIndex = [_delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)];
    _delegateHas.didDismissWithButtonIndex = [_delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)];
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    [_buttonTitles addObject:title];
    return ([_buttonTitles count] - 1);
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    return [_buttonTitles objectAtIndex:buttonIndex];
}


- (NSInteger)numberOfButtons
{
    return [_buttonTitles count];
}

- (void)show
{
    if (_delegateHas.willPresentAlertView) {
        [_delegate willPresentAlertView:self];
    }

    _controller = [[_UIAlertViewController alloc] initWithAlertView:self];
    _window = [[_UIAlertWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = _controller;
    _window.windowLevel = UIWindowLevelNormal + 5;
    _window.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];

    [_window makeKeyAndVisible];

    // _controller.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
    // _window.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    // [UIView animateWithDuration:0.2f
    //                       delay:0.0f
    //                     options:UIViewAnimationOptionCurveEaseOut
    //                  animations:^{
    //                      _controller.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    //                      _window.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
    //                  } completion:^(BOOL finished) {
    //                  }];


    if (_delegateHas.didPresentAlertView) {
        [_delegate didPresentAlertView:self];
    }
}

- (void)_closeWithResult:(NSInteger)result {
    if (_delegateHas.willDismissWithButtonIndex) {
        [_delegate alertView:self willDismissWithButtonIndex:result];
    }

    if (_delegateHas.clickedButtonAtIndex) {
        [_delegate alertView:self clickedButtonAtIndex:result];
    }

    [_controller.view removeFromSuperview];
    _window.rootViewController = nil;
    [_window setHidden:YES];
    _controller = nil;
    _window = nil;
    //    [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];

    if (_delegateHas.didDismissWithButtonIndex) {
        [_delegate alertView:self didDismissWithButtonIndex:result];
    }
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
}

@end
