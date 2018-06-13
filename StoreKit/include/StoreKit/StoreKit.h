/*
 *  StoreKit.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#ifdef DEBUG
#define SKDebugLog(fmt,...) NSLog((@"%s %d "fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define SKDebugLog(...)
#endif

#import <StoreKit/SKBase.h>
#import <StoreKit/SKDownload.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKProductsResponse.h>
#import <StoreKit/SKRequest.h>
#import <StoreKit/SKStoreProductViewController.h>
