#import <Foundation/Foundation.h>

@class UIViewController;

@interface UIStoryboardSegue : NSObject
@property(nonatomic, readonly) __kindof UIViewController *sourceViewController;
@property(nonatomic, readonly) __kindof UIViewController *destinationViewController;
@property(nonatomic, copy, readonly) NSString *identifier;
@end
