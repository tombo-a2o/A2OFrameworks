/*
 *  GKLeaderboardViewController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <GameKit/GKLeaderboard.h>
#import <GameKit/GKGameCenterViewController.h>

@protocol GKLeaderboardViewControllerDelegate
@end

@interface GKLeaderboardViewController : GKGameCenterViewController
@property(copy, atomic) NSString *category;
@property(assign, atomic) id< GKLeaderboardViewControllerDelegate > leaderboardDelegate;
@property(assign, atomic) GKLeaderboardTimeScope timeScope;
@end
