#import <UIKit/UIView.h>

@interface UIStackView : UIView
- (void)addArrangedSubview:(UIView *)view;
@property(nonatomic, readonly, copy) NSArray<__kindof UIView *> *arrangedSubviews;
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;
- (void)removeArrangedSubview:(UIView *)view;
@end
