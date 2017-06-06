#import <Foundation/Foundation.h>
#import <GameController/GCControllerElement.h>

typedef void (^GCControllerButtonValueChangedHandler)(GCControllerButtonInput *button, float value, BOOL pressed);

@interface GCControllerButtonInput : GCControllerElement
@property(nonatomic, copy) GCControllerButtonValueChangedHandler valueChangedHandler;
@end
