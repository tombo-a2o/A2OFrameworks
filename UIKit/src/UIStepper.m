#import <UIKit/UIStepper.h>
#import <UIKit/UIImage.h>

@implementation UIStepper

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)setDividerImage:(UIImage *)image forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState;
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)setIncrementImage:(UIImage *)image forState:(UIControlState)state
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)setDecrementImage:(UIImage *)image forState:(UIControlState)state
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
