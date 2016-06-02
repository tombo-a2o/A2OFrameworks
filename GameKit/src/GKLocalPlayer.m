#import <GameKit/GKLocalPlayer.h>

@implementation GKLocalPlayer
+ (GKLocalPlayer *)localPlayer
{
    return nil;
}

- (void)authenticateWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
    completionHandler([NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:nil]);
}
@end
