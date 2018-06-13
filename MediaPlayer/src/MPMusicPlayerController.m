/*
 *  MPMusicPlayerController.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
