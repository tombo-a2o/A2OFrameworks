#import <AVFoundation/AVAudioPlayer.h>

@implementation AVAudioPlayer
- (instancetype)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError
{
    if(outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:nil]; 
    }
    return nil;
}
@end
