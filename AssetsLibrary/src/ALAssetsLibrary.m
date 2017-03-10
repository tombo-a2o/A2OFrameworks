#import <AssetsLibrary/AssetsLibrary.h>

@implementation ALAssetsLibrary
+ (ALAuthorizationStatus)authorizationStatus
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return ALAuthorizationStatusNotDetermined;
}
@end
