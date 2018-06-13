/*
 *  UIUserNotificationSettings.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, UIUserNotificationType) {
   UIUserNotificationTypeNone    = 0,
   UIUserNotificationTypeBadge   = 1 << 0,
   UIUserNotificationTypeSound   = 1 << 1,
   UIUserNotificationTypeAlert   = 1 << 2,
};

@interface UIUserNotificationSettings : NSObject
+(instancetype)settingsForTypes:(UIUserNotificationType)allowedUserNotificationTypes categories:(NSSet*)actionSettings;
@property(nonatomic, readonly) UIUserNotificationType types;
@property(nonatomic, copy, readonly) NSSet *categories;
@end
