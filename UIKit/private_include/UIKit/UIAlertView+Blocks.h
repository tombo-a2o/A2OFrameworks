#import <UIKit/UIAlertView.h>

@interface UIAlertView (WithBlocks)
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
     clickedHandler:(void(^)(UIAlertView*, NSInteger))clickedHandler
    canceledHandler:(void(^)(UIAlertView*))canceledHandler
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;
@end
