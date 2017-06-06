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
