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
