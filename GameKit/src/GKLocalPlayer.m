/*
 *  GKLocalPlayer.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <GameKit/GKLocalPlayer.h>

NSString *GKPlayerAuthenticationDidChangeNotificationName = @"GKPlayerAuthenticationDidChangeNotificationName";

@implementation GKLocalPlayer
+ (GKLocalPlayer *)localPlayer
{
    return nil;
}

- (void)authenticateWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
    completionHandler([NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:nil]);
}
@end
