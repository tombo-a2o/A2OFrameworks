#import <UIKit/UIViewController.h>

@class GKGameCenterViewController;

@protocol GKGameCenterControllerDelegate
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController;
@end

typedef NS_ENUM(NSInteger, GKGameCenterViewControllerState) {
    GKGameCenterViewControllerStateDefault = -1,
    GKGameCenterViewControllerStateLeaderboards,
    GKGameCenterViewControllerStateAchievements,
    GKGameCenterViewControllerStateChallenges,
};

@interface GKGameCenterViewController : UIViewController
@property(assign, nonatomic) id<GKGameCenterControllerDelegate> gameCenterDelegate;
@property(assign, nonatomic) GKGameCenterViewControllerState viewState;
@property(nonatomic, retain) NSString *leaderboardIdentifier;
@end
