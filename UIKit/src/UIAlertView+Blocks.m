#import <UIKit/UIAlertView+Blocks.h>
#import <objc/runtime.h>

@interface UIAlertViewWithBlocksDelegateObject : NSObject<UIAlertViewDelegate>
@property(nonatomic, readwrite) void(^clickedHandler)(UIAlertView*, NSInteger);
@property(nonatomic, readwrite) void(^canceledHandler)(UIAlertView*);
@end

@implementation UIAlertViewWithBlocksDelegateObject
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(_clickedHandler) {
        _clickedHandler(alertView, buttonIndex);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if(_canceledHandler) {
        _canceledHandler(alertView);
    }
}
@end

@implementation UIAlertView (WithBlocks)

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
     clickedHandler:(void(^)(UIAlertView*, NSInteger))clickedHandler
    canceledHandler:(void(^)(UIAlertView*))canceledHandler
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertViewWithBlocksDelegateObject *delegate = [[UIAlertViewWithBlocksDelegateObject alloc] init];
    delegate.clickedHandler = clickedHandler;
    delegate.canceledHandler = canceledHandler;
    objc_setAssociatedObject(self, "keyToRetainDelegate", delegate, OBJC_ASSOCIATION_RETAIN);

    self = [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if(self) {

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
    }
    return self;
}
@end
