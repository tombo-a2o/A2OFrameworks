#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@class GKPlayer, GKScore;

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
+ (void)loadLeaderboardsWithCompletionHandler:(void (^)(NSArray<GKLeaderboard *> *leaderboards, NSError *error))completionHandler;
- (instancetype)init;
- (instancetype)initWithPlayers:(NSArray<GKPlayer *> *)players;
@property(assign, nonatomic) GKLeaderboardPlayerScope playerScope;
@property(assign, nonatomic) NSRange range;
@property(assign, nonatomic) GKLeaderboardTimeScope timeScope;
@property(copy, nonatomic) NSString *identifier;
- (void)loadImageWithCompletionHandler:(void (^)(UIImage *image, NSError *error))completionHandler;
- (void)loadScoresWithCompletionHandler:(void (^)(NSArray<GKScore *> *scores, NSError *error))completionHandler;
@property(readonly, getter=isLoading) BOOL loading;
@property(readonly, copy, nonatomic) NSString *title;
@property(readonly, retain, nonatomic) NSArray<GKScore *> *scores;
@property(readonly, retain, nonatomic) GKScore *localPlayerScore;
@property(readonly, assign, nonatomic) NSUInteger maxRange;
@property(nonatomic, readonly, retain) NSString *groupIdentifier;
@property(copy, nonatomic) NSString *category;
+ (void)setDefaultLeaderboard:(NSString *)leaderboardIdentifier
        withCompletionHandler:(void (^)(NSError *error))completionHandler;
- (instancetype)initWithPlayerIDs:(NSArray<NSString *> *)playerIDs;
+ (void)loadCategoriesWithCompletionHandler:(void (^)(NSArray<NSString *> *categories, NSArray<NSString *> *titles, NSError *error))completionHandler;
@end
