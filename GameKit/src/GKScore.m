/*
 *  GKScore.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
