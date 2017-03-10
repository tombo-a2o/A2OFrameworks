#import <QuartzCore/CAAnimation.h>

@interface UIAnimation : NSObject
+(CAAnimation*)frontToBackClockwise;
+(CAAnimation*)frontToBackCounterClockwise;
+(CAAnimation*)backToFrontClockwise;
+(CAAnimation*)backToFrontCounterClockwise;
+(CATransform3D)perspective;
@end
