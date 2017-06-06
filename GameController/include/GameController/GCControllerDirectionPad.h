#import <Foundation/Foundation.h>

@class GCControllerButtonInput;

@interface GCControllerDirectionPad : NSObject
@property(nonatomic, readonly) GCControllerButtonInput *up;
@property(nonatomic, readonly) GCControllerButtonInput *down;
@property(nonatomic, readonly) GCControllerButtonInput *left;
@property(nonatomic, readonly) GCControllerButtonInput *right;
@end
