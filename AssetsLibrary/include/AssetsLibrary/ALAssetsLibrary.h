#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, ALAuthorizationStatus ) {
   ALAuthorizationStatusNotDetermined = 0,
   ALAuthorizationStatusRestricted,
   ALAuthorizationStatusDenied,
   ALAuthorizationStatusAuthorized
};

@interface ALAssetsLibrary : NSObject
+ (ALAuthorizationStatus)authorizationStatus;
@end
