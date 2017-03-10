#import <Foundation/Foundation.h>

@class GKPlayer, GKScore, GKChallenge;
@class UIViewController;

typedef void (^GKChallengeComposeCompletionBlock)(UIViewController *composeController, BOOL didIssueChallenge, NSArray<NSString *> *sentPlayerIDs);

@interface GKScore : NSObject<NSCoding, NSSecureCoding>
- (instancetype)initWithLeaderboardIdentifier:(NSString *)identifier;
- (instancetype)initWithLeaderboardIdentifier:(NSString *)identifier
                                       player:(GKPlayer *)player;
@property(assign, nonatomic) uint64_t context;
@property(readonly, retain, nonatomic) NSDate *date;
@property(readonly, copy, nonatomic) NSString *formattedValue;
@property(copy, nonatomic) NSString *leaderboardIdentifier;
@property(readonly, retain, nonatomic) GKPlayer *player;
@property(readonly, assign, nonatomic) NSInteger rank;
@property(assign, nonatomic) int64_t value;
+ (void)reportScores:(NSArray<GKScore *> *)scores
withCompletionHandler:(void (^)(NSError *error))completionHandler;
+ (void)reportScores:(NSArray<GKScore *> *)scores
withEligibleChallenges:(NSArray<GKChallenge *> *)challenges
withCompletionHandler:(void (^)(NSError *error))completionHandler;
@property(nonatomic, assign) BOOL shouldSetDefaultLeaderboard;
- (UIViewController *)challengeComposeControllerWithMessage:(NSString *)message
                                                    players:(NSArray<GKPlayer *> *)players
                                          completionHandler:(GKChallengeComposeCompletionBlock)completionHandler;
@property(copy, nonatomic) NSString *category;
- (UIViewController *)challengeComposeControllerWithPlayers:(NSArray<NSString *> *)playerIDs
                                                    message:(NSString *)message
                                          completionHandler:(GKChallengeComposeCompletionBlock)completionHandler;
- (instancetype)initWithCategory:(NSString *)category;
- (instancetype)initWithLeaderboardIdentifier:(NSString *)identifier
                                    forPlayer:(NSString *)playerID;
- (void)issueChallengeToPlayers:(NSArray<NSString *> *)playerIDs
                        message:(NSString *)message;
@property(readonly, retain, nonatomic) NSString *playerID;
- (void)reportScoreWithCompletionHandler:(void (^)(NSError *error))completionHandler;
@end
