/*
 *  AVAudioSession.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>

extern NSString *const AVAudioSessionCategoryAmbient;
extern NSString *const AVAudioSessionCategorySoloAmbient;
extern NSString *const AVAudioSessionCategoryPlayback;
extern NSString *const AVAudioSessionCategoryRecord;
extern NSString *const AVAudioSessionCategoryPlayAndRecord;
extern NSString *const AVAudioSessionCategoryAudioProcessing;
extern NSString *const AVAudioSessionCategoryMultiRoute;
extern NSString *const AVAudioSessionInterruptionNotification;
extern NSString *const AVAudioSessionRouteChangeNotification;

@protocol AVAudioSessionDelegate
@end

@interface AVAudioSession : NSObject
+ (AVAudioSession *)sharedInstance;
- (BOOL)setActive:(BOOL)beActive error:(NSError **)outError;
- (BOOL)setCategory:(NSString *)theCategory error:(NSError **)outError;
@property(assign) id< AVAudioSessionDelegate > delegate;
@property(readonly, getter=isOtherAudioPlaying) BOOL otherAudioPlaying;
@end
