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
