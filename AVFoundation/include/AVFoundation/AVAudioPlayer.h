/*
 *  AVAudioPlayer.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

@protocol AVAudioPlayerDelegate
@end

@interface AVAudioPlayer : NSObject
- (instancetype)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError;
- (BOOL)play;
- (BOOL)playAtTime:(NSTimeInterval)time;
- (void)pause;
- (void)stop;
- (BOOL)prepareToPlay;
@property(readonly, getter=isPlaying) BOOL playing;
@property float volume;
@property float pan;
@property float rate;
@property BOOL enableRate;
@property NSInteger numberOfLoops;
@property(assign) id< AVAudioPlayerDelegate > delegate;
@property(readonly) NSDictionary *settings;
@property(readonly) NSUInteger numberOfChannels;
@property(readonly) NSTimeInterval duration;
@property NSTimeInterval currentTime;
@property(readonly) NSTimeInterval deviceCurrentTime;
@property(readonly) NSURL * url;
@property(readonly) NSData * data;
@end
