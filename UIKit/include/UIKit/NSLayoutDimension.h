#import <UIKit/NSLayoutAnchor.h>
#import <UIKit/NSLayoutConstraint.h>

@interface NSLayoutDimension : NSLayoutAnchor
- (NSLayoutConstraint *)constraintEqualToConstant:(CGFloat)c;
@end
