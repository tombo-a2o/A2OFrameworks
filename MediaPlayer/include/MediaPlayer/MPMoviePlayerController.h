/*
 *  MPMoviePlayerController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

extern NSString *const MPMoviePlayerPlaybackDidFinishNotification;
extern NSString *const MPMoviePlayerPlaybackStateDidChangeNotification;

typedef NS_ENUM(NSInteger, MPMovieSourceType) {
  MPMovieSourceTypeUnknown,
  MPMovieSourceTypeFile,
  MPMovieSourceTypeStreaming
};

typedef NS_ENUM(NSInteger, MPMovieScalingMode) {
  MPMovieScalingModeNone,
  MPMovieScalingModeAspectFit,
  MPMovieScalingModeAspectFill,
  MPMovieScalingModeFill
};

typedef NS_ENUM(NSInteger, MPMovieControlStyle) {
  MPMovieControlStyleNone,
  MPMovieControlStyleEmbedded,
  MPMovieControlStyleFullscreen,
  MPMovieControlStyleDefault
};

typedef NS_ENUM(NSInteger, MPMoviePlaybackState) {
  MPMoviePlaybackStateStopped,
  MPMoviePlaybackStatePlaying,
  MPMoviePlaybackStatePaused,
  MPMoviePlaybackStateInterrupted,
  MPMoviePlaybackStateSeekingForward,
  MPMoviePlaybackStateSeekingBackward
};

@class UIView;

@interface MPMoviePlayerController : NSObject
- (instancetype)initWithContentURL:(NSURL *)url;
@property(nonatomic, copy) NSURL *contentURL;
@property(nonatomic) MPMovieSourceType movieSourceType;
// @property(nonatomic, readonly) MPMovieMediaTypeMask movieMediaTypes;
@property(nonatomic) BOOL allowsAirPlay;
@property(nonatomic) MPMovieScalingMode scalingMode;
@property(nonatomic) MPMovieControlStyle controlStyle;

@property(nonatomic, readonly) MPMoviePlaybackState playbackState;

@property(nonatomic, readonly) UIView *view;
@property(nonatomic, readonly) UIView *backgroundView;
@end
