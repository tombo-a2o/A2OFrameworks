/*
 *  SKStoreProductViewController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIViewController.h>

@class SKStoreProductViewController;

@protocol SKStoreProductViewControllerDelegate

// Responding to a Dismiss Action
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController;

@end

@interface SKStoreProductViewController : UIViewController

// Settings a Delegate
@property(nonatomic, assign) id< SKStoreProductViewControllerDelegate > delegate;

// Loading a New Product Screen
- (void)loadProductWithParameters:(NSDictionary*)parameters completionBlock:(void (^)(BOOL result, NSError *error))block;

@end

// Constants
extern NSString * const SKStoreProductParameterITunesItemIdentifier;
extern NSString * const SKStoreProductParameterAffiliateToken;
extern NSString * const SKStoreProductParameterCampaignToken;
extern NSString * const SKStoreProductParameterProviderToken;
