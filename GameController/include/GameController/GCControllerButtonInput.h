#import <Foundation/Foundation.h>
#import <GameController/GCControllerElement.h>

typedef void (^GCControllerButtonValueChangedHandler)(GCControllerButtonInput *button, float value, BOOL pressed);

@interface GCControllerButtonInput : GCControllerElement
@property(nonatomic, readonly, getter=isPressed) BOOL pressed;
@property(nonatomic, readonly) float value;
@property(nonatomic, copy) GCControllerButtonValueChangedHandler valueChangedHandler;
@end
