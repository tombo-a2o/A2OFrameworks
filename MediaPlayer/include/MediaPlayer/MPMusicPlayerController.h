#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MPMusicPlaybackState) {
    MPMusicPlaybackStateStopped,
    MPMusicPlaybackStatePlaying,
    MPMusicPlaybackStatePaused,
    MPMusicPlaybackStateInterrupted,
    MPMusicPlaybackStateSeekingForward,
    MPMusicPlaybackStateSeekingBackward,
};

extern NSString *const MPMusicPlayerControllerPlaybackStateDidChangeNotification;
extern NSString *const MPMusicPlayerControllerNowPlayingItemDidChangeNotification;

@interface MPMusicPlayerController : NSObject
+ (MPMusicPlayerController *)systemMusicPlayer;
+ (MPMusicPlayerController *)iPodMusicPlayer;
- (void)beginGeneratingPlaybackNotifications;
- (void)endGeneratingPlaybackNotifications;
@property(nonatomic, readonly) MPMusicPlaybackState playbackState;
@end
