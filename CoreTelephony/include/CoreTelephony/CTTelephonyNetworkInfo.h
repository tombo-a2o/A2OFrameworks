#import <Foundation/NSObject.h>

@class CTCarrier;

@interface CTTelephonyNetworkInfo : NSObject
@property(readonly, retain) CTCarrier *subscriberCellularProvider;
@property(nonatomic, copy) void (^subscriberCellularProviderDidUpdateNotifier)( CTCarrier *);
@end
