#import <Foundation/Foundation.h>
#import <GameController/GCControllerElement.h>

@class GCControllerAxisInput, GCControllerButtonInput;

@interface GCControllerDirectionPad : GCControllerElement
@property(nonatomic, readonly) GCControllerAxisInput *xAxis;
@property(nonatomic, readonly) GCControllerAxisInput *yAxis;
@property(nonatomic, readonly) GCControllerButtonInput *up;
@property(nonatomic, readonly) GCControllerButtonInput *down;
@property(nonatomic, readonly) GCControllerButtonInput *left;
@property(nonatomic, readonly) GCControllerButtonInput *right;
@end
