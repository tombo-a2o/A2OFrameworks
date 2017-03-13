#import <UIKit/UIKit.h>

@interface UIStoryboardEmbedSegueTemplate : NSObject <NSCoding>
// - (id)initWithCoder:(NSCoder *)coder;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) UIViewController *viewController;
@end

@implementation UIStoryboardEmbedSegueTemplate
// - (id)initWithCoder:(NSCoder *)coder
// {
//     return self;
// }
@end

@interface UIStoryboardShowSegueTemplate : NSObject
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) UIViewController *viewController;
@end

@implementation UIStoryboardShowSegueTemplate
@end

@implementation UIStoryboardSegue
@end
