/*
 *  AVAudioSession.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
