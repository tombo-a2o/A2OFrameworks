#import <AVFoundation/AVFoundation.h>

NSString *const AVAudioSessionCategoryAmbient = @"ambient";
NSString *const AVAudioSessionCategorySoloAmbient = @"soloAmbient";
NSString *const AVAudioSessionCategoryPlayback = @"playback";
NSString *const AVAudioSessionCategoryRecord = @"record";
NSString *const AVAudioSessionCategoryPlayAndRecord = @"playAndRecord";
NSString *const AVAudioSessionCategoryAudioProcessing = @"audioProcessing";
NSString *const AVAudioSessionCategoryMultiRoute = @"multiRoute";

NSString *const AVAudioSessionInterruptionNotification = @"AVAudioSessionInterruptionNotification";
NSString *const AVAudioSessionRouteChangeNotification = @"AVAudioSessionRouteChangeNotification";

AVAudioSession *_theSession = nil;

@implementation AVAudioSession
+ (AVAudioSession *)sharedInstance {
    if(!_theSession) {
        _theSession = [[AVAudioSession alloc] init];
    }
    return _theSession;
}
- (BOOL)setActive:(BOOL)beActive error:(NSError **)outError {
    return YES;
}
- (BOOL)setCategory:(NSString *)theCategory error:(NSError **)outError {
    return YES;
}
@end
