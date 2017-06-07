#import <Foundation/Foundation.h>

extern NSString *const GCControllerDidConnectNotification;
extern NSString *const GCControllerDidDisconnectNotification;

@class GCGamepad, GCExtendedGamepad;

@interface GCController : NSObject
@property(nonatomic, retain, readonly) GCGamepad *gamepad;
@property(nonatomic, retain, readonly) GCExtendedGamepad *extendedGamepad;
@property(nonatomic, readonly, copy) NSString *vendorName;
@property(nonatomic, copy, nonnull) void (^controllerPausedHandler)(GCController *controller);
@property(nonatomic, readonly, getter=isAttachedToDevice) BOOL attachedToDevice;
@end
