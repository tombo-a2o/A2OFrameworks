/*
 *  GKAchievement.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
