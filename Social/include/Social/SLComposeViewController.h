/*
 *  SLComposeViewController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

// https://developer.apple.com/library/ios/documentation/NetworkingInternet/Reference/SLComposeViewController_Class/index.html

#import <UIKit/UIViewController.h>
#import <UIKit/UIImage.h>

extern NSString *const SLServiceTypeFacebook;
extern NSString *const SLServiceTypeTwitter;
extern NSString *const SLServiceTypeSinaWeibo;
extern NSString *const SLServiceTypeTencentWeibo;

typedef NS_ENUM (NSInteger, SLComposeViewControllerResult ) {
    SLComposeViewControllerResultCancelled,
    SLComposeViewControllerResultDone
};

typedef void (^SLComposeViewControllerCompletionHandler) (SLComposeViewControllerResult result);

@interface SLComposeViewController : UIViewController {
}
+ (SLComposeViewController *)composeViewControllerForServiceType:(NSString *)serviceType;
+ (BOOL)isAvailableForServiceType:(NSString *)serviceType;
- (BOOL)setInitialText:(NSString *)text;
- (BOOL)addImage:(UIImage *)image;
- (BOOL)removeAllImages;
- (BOOL)addURL:(NSURL *)url;
- (BOOL)removeAllURLs;

@property(nonatomic, readonly) NSString *serviceType;
@property(nonatomic, copy) SLComposeViewControllerCompletionHandler completionHandler;

@end
