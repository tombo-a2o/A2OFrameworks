/*
 *  GKAchievement.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
