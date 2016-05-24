#import <GameKit/GKPlayer.h>
#import <UIKit/UIViewController.h>

@interface GKLocalPlayer : GKPlayer 
+ (GKLocalPlayer *)localPlayer;
@property(nonatomic, copy) void (^authenticateHandler)( UIViewController *viewController, NSError *error);
@property(readonly, getter=isAuthenticated, nonatomic) BOOL authenticated;
@end
