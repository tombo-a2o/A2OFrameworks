#import <Foundation/NSObject.h>

@interface CTCarrier : NSObject
@property(nonatomic, readonly, assign) BOOL allowsVOIP;
@property(nonatomic, readonly, retain) NSString *carrierName;
@property(nonatomic, readonly, retain) NSString *isoCountryCode;
@property(nonatomic, readonly, retain) NSString *mobileCountryCode;
@property(nonatomic, readonly, retain) NSString *mobileNetworkCode;
@end
