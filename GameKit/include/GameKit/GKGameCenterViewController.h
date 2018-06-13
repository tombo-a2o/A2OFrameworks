/*
 *  GKGameCenterViewController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIViewController.h>

@class GKGameCenterViewController;

@protocol GKGameCenterControllerDelegate
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController;
@end

typedef NS_ENUM(NSInteger, GKGameCenterViewControllerState) {
    GKGameCenterViewControllerStateDefault = -1,
    GKGameCenterViewControllerStateLeaderboards,
    GKGameCenterViewControllerStateAchievements,
    GKGameCenterViewControllerStateChallenges,
};

@interface GKGameCenterViewController : UIViewController
@property(assign, nonatomic) id<GKGameCenterControllerDelegate> gameCenterDelegate;
@property(assign, nonatomic) GKGameCenterViewControllerState viewState;
@property(nonatomic, retain) NSString *leaderboardIdentifier;
@end
