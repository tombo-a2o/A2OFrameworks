#import <UIKit/UIControl.h>

@class UIImage;

@interface UIStepper : UIControl
@property(nonatomic) double value;
@property(nonatomic) double minimumValue;
@property(nonatomic) double maximumValue;
@property(nonatomic) double stepValue;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setDividerImage:(UIImage *)image forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState;
- (void)setIncrementImage:(UIImage *)image forState:(UIControlState)state;
- (void)setDecrementImage:(UIImage *)image forState:(UIControlState)state;
@end
