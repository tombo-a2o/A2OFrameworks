#import <Foundation/Foundation.h>

@interface GKAchievement : NSObject
+ (void)loadAchievementsWithCompletionHandler:(void (^)(NSArray *achievements, NSError *error))completionHandler;
- (instancetype)initWithIdentifier:(NSString *)identifier;
//- (instancetype)initWithIdentifier:(NSString *)identifier player:(GKPlayer *)player;

+ (void)reportAchievements:(NSArray *)achievements withCompletionHandler:(void (^)(NSError *error))completionHandler;
+ (void)reportAchievements:(NSArray *)achievements withEligibleChallenges:(NSArray *)challenges withCompletionHandler:(void (^)(NSError *error))completionHandler;
- (void)reportAchievementWithCompletionHandler:(void (^)(NSError *error))completionHandler;
+ (void)resetAchievementsWithCompletionHandler:(void (^)(NSError *error))completionHandler;

@property(copy, nonatomic) NSString *identifier;
@property(assign, nonatomic) double percentComplete;
@property(readonly, getter=isCompleted, nonatomic) BOOL completed;
@property(copy, readonly, nonatomic) NSDate *lastReportedDate;
@property(assign, nonatomic) BOOL showsCompletionBanner;

@end
