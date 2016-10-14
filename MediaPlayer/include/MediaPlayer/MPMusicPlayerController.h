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
@property(nonatomic, readonly) MPMusicPlaybackState playbackState;
@end
