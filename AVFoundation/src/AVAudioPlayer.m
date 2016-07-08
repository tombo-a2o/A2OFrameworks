#import <AVFoundation/AVAudioPlayer.h>

extern int audioPlayer_create(const char* path);
extern void audioPlayer_play(int playerId, float delay);
extern void audioPlayer_stop(int playerId);
extern void audioPlayer_setVolume(int playerId, float volume);
extern void audioPlayer_setNumberOfLoops(int playerId, int numberOfLoops);
extern void audioPlayer_destroy(int playerId);
extern int audioPlayer_isPlaying(int playerId);
extern float audioPlayer_setOffset(int playerId, float offset);
extern float audioPlayer_getPosition(int playerId);

@implementation AVAudioPlayer {
    NSURL *_url;
    int _playerId;
    float _volume;
    float _pan;
    float _rate;
    BOOL _enableRate;
    NSInteger _numberOfLoops;
}

- (instancetype)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError
{
    self = [self init];
    if(!self) {
        return nil;
    }
    
    if(!url) {
        if(outError) *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:nil];
        return nil;
    }
    _url = url;
    _playerId = audioPlayer_create(url.fileSystemRepresentation);
    _volume = 1.0;
    _pan = 0.0;
    _rate = 1.0;
    _enableRate = NO;
    _numberOfLoops = 0;
    
    NSLog(@"%s %d %s", __FUNCTION__, _playerId, _url.fileSystemRepresentation);
    return self;
}

// - (instancetype)initWithData:(NSData *)data error:(NSError **)outError
// {
//     self = [self init];
//     if(!self) {
//         return nil;
//     }
//     
//     if(!data) {
//         if(outError) *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:nil];
//         return nil;
//     }
//     _data = data;
//     
//     return self;
// }

- (void)dealloc
{
    [self stop];
    NSLog(@"%s %d", __FUNCTION__, _playerId);
    audioPlayer_destroy(_playerId);
}

- (BOOL)play
{
    NSLog(@"%s %d %s", __FUNCTION__, _playerId, _url.fileSystemRepresentation);
    audioPlayer_play(_playerId, 0);
    return YES;
}

- (BOOL)playAtTime:(NSTimeInterval)time
{
    NSLog(@"%s %d %s", __FUNCTION__, _playerId, _url.fileSystemRepresentation);
    audioPlayer_play(_playerId, (float)time);
    return YES;
}

- (void)pause
{
    NSLog(@"%s %d %s", __FUNCTION__, _playerId, _url.fileSystemRepresentation);
    audioPlayer_stop(_playerId);
}

- (void)stop
{
    NSLog(@"%s %d %s", __FUNCTION__, _playerId, _url.fileSystemRepresentation);
    audioPlayer_stop(_playerId);
}

- (BOOL)prepareToPlay
{
    // preparation has finished on page load
    return YES;
}

- (BOOL)isPlaying
{
    return audioPlayer_isPlaying(_playerId) > 0;
}

- (void)setVolume:(float)volume
{
    NSLog(@"%s %d %f", __FUNCTION__, _playerId, volume);
    _volume = volume;
    audioPlayer_setVolume(_playerId, volume);
}

- (float)volume
{
    return _volume;
}

- (void)setPan:(float)pan
{
    NSLog(@"%s not implemented %d %f", __FUNCTION__, _playerId, pan);
    _pan = pan;
}

- (float)pan
{
    return _pan;
}

- (void)setRate:(float)rate
{
    NSLog(@"%s not implemented %d %f", __FUNCTION__, _playerId, rate);
    _rate = rate;
}

- (float)rate
{
    return _rate;
}

- (void)setEnableRate:(BOOL)enableRate
{
    NSLog(@"%s not implemented %d %d", __FUNCTION__, _playerId, enableRate);
    _enableRate = enableRate;
}

- (BOOL)enableRate
{
    return _enableRate;
}

- (void)setNumberOfLoops:(NSInteger)numberOfLoops
{
    NSLog(@"%s %d %d", __FUNCTION__, _playerId, numberOfLoops);
    _numberOfLoops = numberOfLoops;
    audioPlayer_setNumberOfLoops(_playerId, numberOfLoops);
}

- (NSInteger)numberOfLoops
{
    return _numberOfLoops;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    NSLog(@"%s %d %f", __FUNCTION__, _playerId, currentTime);
    int isPlaying = audioPlayer_isPlaying(_playerId);

    if(isPlaying) {
        [self stop];
    }
    audioPlayer_setOffset(_playerId, (float)currentTime);
     if(isPlaying) {
        [self play];
    }
}

- (NSTimeInterval)currentTime
{
    return audioPlayer_getPosition(_playerId);
}

@end
