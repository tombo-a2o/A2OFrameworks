/*
 *  SKDownload.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
