#import <UIKit/UIAcceleration.h>

@interface UIAcceleration (UIPrivate)
@property (nonatomic, readwrite) UIAccelerationValue x;
@property (nonatomic, readwrite) UIAccelerationValue y;
@property (nonatomic, readwrite) UIAccelerationValue z;
@property (nonatomic, readwrite) NSTimeInterval timestamp;
@end
