#import <UIKit/UIPopoverController.h>
#import <UIKit/UIPresentationController.h>

@interface UIPopoverPresentationController : UIPresentationController
@property(nonatomic, strong) UIView *sourceView;
@property(nonatomic, assign) CGRect sourceRect;
@property(nonatomic, assign) UIPopoverArrowDirection permittedArrowDirections;
@end
