#import <AVFoundation/AVFoundation.h>

NSString *const AVAudioSessionCategoryAmbient = @"ambient";
NSString *const AVAudioSessionCategorySoloAmbient = @"soloAmbient";
NSString *const AVAudioSessionCategoryPlayback = @"playback";
NSString *const AVAudioSessionCategoryRecord = @"record";
NSString *const AVAudioSessionCategoryPlayAndRecord = @"playAndRecord";
NSString *const AVAudioSessionCategoryAudioProcessing = @"audioProcessing";
NSString *const AVAudioSessionCategoryMultiRoute = @"multiRoute";

@implementation AVAudioSession
+ (AVAudioSession *)sharedInstance {
    return nil;
}
- (BOOL)setActive:(BOOL)beActive error:(NSError **)outError {
    return NO;
}
- (BOOL)setCategory:(NSString *)theCategory error:(NSError **)outError {
    return NO;
}
@end
