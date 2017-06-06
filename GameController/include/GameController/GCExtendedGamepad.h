#import <Foundation/Foundation.h>

@class GCControllerAxisInput, GCControllerDirectionPad;

@interface GCExtendedGamepad : NSObject
@property(nonatomic, readonly) GCControllerAxisInput *xAxis;
@property(nonatomic, readonly) GCControllerAxisInput *yAxis;
@property(nonatomic, readonly) GCControllerDirectionPad *dpad;
@property(nonatomic, readonly) GCControllerDirectionPad *leftThumbstick;
@property(nonatomic, readonly) GCControllerDirectionPad *rightThumbstick;
@end
