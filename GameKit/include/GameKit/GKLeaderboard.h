#import <Foundation/NSObject.h>

enum {
    GKLeaderboardTimeScopeToday = 0,
    GKLeaderboardTimeScopeWeek,
    GKLeaderboardTimeScopeAllTime
};
typedef NSInteger GKLeaderboardTimeScope;

enum {
    GKLeaderboardPlayerScopeGlobal = 0,
    GKLeaderboardPlayerScopeFriendsOnly
};
typedef NSInteger GKLeaderboardPlayerScope;

@interface GKLeaderboard : NSObject
@end
