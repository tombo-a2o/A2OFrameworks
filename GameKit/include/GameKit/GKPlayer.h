/*
 *  GKPlayer.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <GameKit/GKBase.h>

@class UIImage;
GK_EXPORT NSString *GKPlayerDidChangeNotificationName;

typedef NSInteger GKPhotoSize;

@interface GKBasePlayer : NSObject
@property(readonly, nonatomic) NSString *displayName;
@property(readonly, retain, nonatomic) NSString *playerID;
@end

@interface GKPlayer : GKBasePlayer
+ (void)loadPlayersForIdentifiers:(NSArray<NSString *> *)identifiers
            withCompletionHandler:(void (^)(NSArray<GKPlayer *> *players, NSError *error))completionHandler;
@property(readonly, retain, nonatomic) NSString *playerID;
@property(readonly, copy, nonatomic) NSString *alias;
@property(readonly, nonatomic) NSString *displayName;
@property(readonly, nonatomic) BOOL isFriend;
- (void)loadPhotoForSize:(GKPhotoSize)size
   withCompletionHandler:(void (^)(UIImage *photo, NSError *error))completionHandler;
+ (instancetype)anonymousGuestPlayerWithIdentifier:(NSString *)guestIdentifier;
@property(readonly, nonatomic) NSString *guestIdentifier;
@end
