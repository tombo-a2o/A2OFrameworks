#import <GameKit/GKLeaderboard.h>
#import <GameKit/GKGameCenterViewController.h>

@protocol GKLeaderboardViewControllerDelegate
@end

@interface GKLeaderboardViewController : GKGameCenterViewController
@property(copy, atomic) NSString *category;
@property(assign, atomic) id< GKLeaderboardViewControllerDelegate > leaderboardDelegate;
@property(assign, atomic) GKLeaderboardTimeScope timeScope;
@end
