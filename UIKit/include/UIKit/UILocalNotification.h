/*
 *  UILocalNotification.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

extern NSString *const UILocalNotificationDefaultSoundName;


@interface UILocalNotification : NSObject
@property(nonatomic, copy) NSDate *fireDate;
@property(nonatomic, copy) NSTimeZone *timeZone;
@property(nonatomic) NSCalendarUnit repeatInterval;
@property(nonatomic, copy) NSCalendar *repeatCalendar;
//@property(nonatomic, copy) CLRegion *region;
@property(nonatomic, assign) BOOL regionTriggersOnce;
@property(nonatomic, copy) NSString *alertBody;
@property(nonatomic, copy) NSString *alertAction;
@property(nonatomic, copy) NSString *alertTitle;
@property(nonatomic) BOOL hasAction;
@property(nonatomic, copy) NSString *alertLaunchImage;
@property(nonatomic, copy) NSString *category;
@property(nonatomic) NSInteger applicationIconBadgeNumber;
@property(nonatomic, copy) NSString *soundName;
@property(nonatomic, copy) NSDictionary *userInfo;
@end
