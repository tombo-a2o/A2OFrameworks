/*
 *  GKLocalPlayer.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <GameKit/GKPlayer.h>
#import <GameKit/GKBase.h>
#import <UIKit/UIViewController.h>

GK_EXPORT NSString *GKPlayerAuthenticationDidChangeNotificationName;

@interface GKLocalPlayer : GKPlayer
+ (GKLocalPlayer *)localPlayer;
- (void)authenticateWithCompletionHandler:(void (^)(NSError *error))completionHandler;
@property(nonatomic, copy) void (^authenticateHandler)( UIViewController *viewController, NSError *error);
@property(readonly, getter=isAuthenticated, nonatomic) BOOL authenticated;
@end
