#import <Foundation/Foundation.h>

@class GCController, GCControllerButtonInput, GCControllerDirectionPad, GCControllerElement;

typedef void (^GCGamepadValueChangedHandler)(GCGamepad *gamepad, GCControllerElement *element);

@interface GCGamepad : NSObject
@property(nonatomic, readonly, assign) GCController *controller;
@property(nonatomic, copy) GCGamepadValueChangedHandler valueChangedHandler;
@property(nonatomic, readonly) GCControllerButtonInput *leftShoulder;
@property(nonatomic, readonly) GCControllerButtonInput *rightShoulder;
@property(nonatomic, readonly) GCControllerDirectionPad *dpad;
@property(nonatomic, readonly) GCControllerButtonInput *buttonA;
@property(nonatomic, readonly) GCControllerButtonInput *buttonB;
@property(nonatomic, readonly) GCControllerButtonInput *buttonX;
@property(nonatomic, readonly) GCControllerButtonInput *buttonY;
@end
