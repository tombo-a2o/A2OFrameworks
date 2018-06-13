/*
 *  MPMusicPlayerController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
