#import <MediaPlayer/MPMusicPlayerController.h>

NSString *const MPMusicPlayerControllerPlaybackStateDidChangeNotification = @"MPMusicPlayerControllerPlaybackStateDidChangeNotification";
NSString *const MPMusicPlayerControllerNowPlayingItemDidChangeNotification = @"MPMusicPlayerControllerNowPlayingItemDidChangeNotification";

@implementation MPMusicPlayerController
+ (MPMusicPlayerController *)applicationMusicPlayer
{
    NSLog(@"%s is not implemented", __FUNCTION__);
    return nil;
}

+ (MPMusicPlayerController *)systemMusicPlayer
{
    NSLog(@"%s is not implemented", __FUNCTION__);
    return nil;
}

+ (MPMusicPlayerController *)iPodMusicPlayer
{
    NSLog(@"%s is not implemented", __FUNCTION__);
    return nil;
}

- (void)beginGeneratingPlaybackNotifications
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)endGeneratingPlaybackNotifications
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

-(id)init {
    NSLog(@"MPMusicPlayerController is not implemented");
    return [super init];
}
@end
