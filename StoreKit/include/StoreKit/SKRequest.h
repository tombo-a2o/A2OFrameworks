/*
 *  SKRequest.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#ifndef STOREKIT_SKRequest
#define STOREKIT_SKRequest

#import <Foundation/Foundation.h>

@class SKRequest;

@protocol SKRequestDelegate <NSObject>

// Completing Requests
- (void)requestDidFinish:(SKRequest *)request;

// Handling Erros
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error;

@end

@interface SKRequest : NSObject

// Controlling the Request
- (void)start;
- (void)cancel;

// Accessing the Delegate
@property(nonatomic, assign) id< SKRequestDelegate > delegate;

@end

@class SKProductsRequest;
@class SKProductsResponse;

@protocol SKProductsRequestDelegate <SKRequestDelegate>

// Receiving the Response
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;

@end

@interface SKProductsRequest : SKRequest

// Initializing a Products Request
- (instancetype)initWithProductIdentifiers:(NSSet<NSString *> *)productIdentifiers;

// Settings the Delegate
@property(nonatomic, assign) id< SKProductsRequestDelegate > delegate;

@end

@interface SKReceiptRefreshRequest : SKRequest

// Working with Receipt Refresh Requests
- (instancetype)initWithReceiptProperties:(NSDictionary<NSString *, id> *)properties;
@property (nonatomic, readonly) NSDictionary<NSString *, id> *receiptProperties;

@end

extern NSString * const SKReceiptPropertyIsExpired;
extern NSString * const SKReceiptPropertyIsRevoked;
extern NSString * const SKReceiptPropertyIsVolumePurchase;

#endif
