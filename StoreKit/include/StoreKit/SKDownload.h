#import <Foundation/Foundation.h>

@class SKPaymentTransaction;

typedef NS_ENUM(NSInteger, SKDownloadState) {
  SKDownloadStateWaiting,
  SKDownloadStateActive,
  SKDownloadStatePaused,
  SKDownloadStateFinished,
  SKDownloadStateFailed,
  SKDownloadStateCancelled,
};

@interface SKDownload : NSObject

// Obtaining Information about the Downloadable Content
@property(nonatomic, readonly) NSString *contentIdentifier;
@property(nonatomic, readonly) long long contentLength;
@property(nonatomic, readonly) NSString *contentVersion;
@property(nonatomic, readonly) SKPaymentTransaction *transaction;

// Obtaining Information about the State of a Download
@property(nonatomic, readonly) SKDownloadState downloadState;
@property(nonatomic, readonly) float progress;
@property(nonatomic, readonly) NSTimeInterval timeRemaining;

// Accessing a Completed Download
@property(nonatomic, readonly) NSError *error;
@property(nonatomic, readonly) NSURL *contentURL;

@end

// Constants
extern NSTimeInterval SKDownloadTimeRemainingUnknown;
