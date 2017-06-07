#import <Foundation/Foundation.h>
#import <GameController/GCControllerElement.h>

typedef void (^GCControllerAxisValueChangedHandler)(GCControllerAxisInput *axis, float value);

@interface GCControllerAxisInput : GCControllerElement
@property(nonatomic, copy) GCControllerAxisValueChangedHandler valueChangedHandler;
@end
