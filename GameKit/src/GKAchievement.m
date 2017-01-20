#import <GameKit/GKAchievement.h>

@implementation GKAchievement
+ (void)loadAchievementsWithCompletionHandler:(void (^)(NSArray *achievements, NSError *error))completionHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}
- (instancetype)initWithIdentifier:(NSString *)identifier
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}
//- (instancetype)initWithIdentifier:(NSString *)identifier player:(GKPlayer *)player;

+ (void)reportAchievements:(NSArray *)achievements withCompletionHandler:(void (^)(NSError *error))completionHandler;
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}
+ (void)reportAchievements:(NSArray *)achievements withEligibleChallenges:(NSArray *)challenges withCompletionHandler:(void (^)(NSError *error))completionHandler;
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}
- (void)reportAchievementWithCompletionHandler:(void (^)(NSError *error))completionHandler;
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}
+ (void)resetAchievementsWithCompletionHandler:(void (^)(NSError *error))completionHandler;
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}
@end
