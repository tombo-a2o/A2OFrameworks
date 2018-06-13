/*
 *  SKStoreProductViewController.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <StoreKit/SKStoreProductViewController.h>

@implementation SKStoreProductViewController

// Loads a new product screen to display.
- (void)loadProductWithParameters:(NSDictionary*)parameters completionBlock:(void (^)(BOOL result, NSError *error))block
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

@end

// Constants
NSString * const SKStoreProductParameterITunesItemIdentifier= @"id";
NSString * const SKStoreProductParameterAffiliateToken = @"at";
NSString * const SKStoreProductParameterCampaignToken = @"ct";
NSString * const SKStoreProductParameterProviderToken = @"pt";
