#import <GameKit/GKScore.h>

@implementation GKScore
- (instancetype)initWithLeaderboardIdentifier:(NSString *)identifier
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithLeaderboardIdentifier:(NSString *)identifier player:(GKPlayer *)player
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (void)reportScores:(NSArray<GKScore *> *)scores withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

+ (void)reportScores:(NSArray<GKScore *> *)scores withEligibleChallenges:(NSArray<GKChallenge *> *)challenges withCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (UIViewController *)challengeComposeControllerWithMessage:(NSString *)message players:(NSArray<GKPlayer *> *)players completionHandler:(GKChallengeComposeCompletionBlock)completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (UIViewController *)challengeComposeControllerWithPlayers:(NSArray<NSString *> *)playerIDs message:(NSString *)message completionHandler:(GKChallengeComposeCompletionBlock)completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithCategory:(NSString *)category
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithLeaderboardIdentifier:(NSString *)identifier forPlayer:(NSString *)playerID
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)issueChallengeToPlayers:(NSArray<NSString *> *)playerIDs message:(NSString *)message
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)reportScoreWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
