#import <GameKit/GKPlayer.h>
#import <GameKit/GKBase.h>
#import <UIKit/UIViewController.h>

GK_EXPORT NSString *GKPlayerAuthenticationDidChangeNotificationName;

@interface GKLocalPlayer : GKPlayer
+ (GKLocalPlayer *)localPlayer;
- (void)authenticateWithCompletionHandler:(void (^)(NSError *error))completionHandler;
@property(nonatomic, copy) void (^authenticateHandler)( UIViewController *viewController, NSError *error);
@property(readonly, getter=isAuthenticated, nonatomic) BOOL authenticated;
@end
