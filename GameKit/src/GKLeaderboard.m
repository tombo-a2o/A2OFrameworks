#import <GameKit/GKLeaderboard.h>

@implementation GKLeaderboard
+ (void)loadLeaderboardsWithCompletionHandler:(void (^)(NSArray<GKLeaderboard *> *leaderboards, NSError *error))completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (instancetype)init
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithPlayers:(NSArray<GKPlayer *> *)players
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)loadImageWithCompletionHandler:(void (^)(UIImage *image, NSError *error))completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)loadScoresWithCompletionHandler:(void (^)(NSArray<GKScore *> *scores, NSError *error))completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

+ (void)setDefaultLeaderboard:(NSString *)leaderboardIdentifier
        withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (instancetype)initWithPlayerIDs:(NSArray<NSString *> *)playerIDs
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (void)loadCategoriesWithCompletionHandler:(void (^)(NSArray<NSString *> *categories, NSArray<NSString *> *titles, NSError *error))completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
