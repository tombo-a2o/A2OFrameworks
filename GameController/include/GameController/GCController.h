#import <Foundation/Foundation.h>

extern NSString *const GCControllerDidConnectNotification;
extern NSString *const GCControllerDidDisconnectNotification;

@class GCExtendedGamepad;

@interface GCController : NSObject
@property(nonatomic, retain, readonly) GCExtendedGamepad *extendedGamepad;
@property(nonatomic, readonly, copy) NSString *vendorName;
@end
