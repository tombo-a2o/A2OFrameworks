#import <Foundation/Foundation.h>
#import <GameController/GCControllerElement.h>

@interface GCControllerAxisInput : GCControllerElement
@property(nonatomic, copy) GCControllerButtonValueChangedHandler valueChangedHandler;
@end
