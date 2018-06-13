/*
 *  GKLeaderboard.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
