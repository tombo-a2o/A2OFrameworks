#import <Foundation/Foundation.h>

@interface ASIdentifierManager : NSObject
@property(nonatomic, readonly) NSUUID *advertisingIdentifier;
@property(nonatomic, readonly, getter=isAdvertisingTrackingEnabled) BOOL advertisingTrackingEnabled;
+ (ASIdentifierManager *)sharedManager;
@end
