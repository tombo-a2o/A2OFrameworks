/*
 *  SLRequest.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

typedef NS_ENUM (NSInteger, SLRequestMethod )  {
    SLRequestMethodGET,
    SLRequestMethodPOST,
    SLRequestMethodDELETE,
    SLRequestMethodPUT
};

typedef void(^SLRequestHandler)(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error);

@interface SLRequest : NSObject
+ (SLRequest *)requestForServiceType:(NSString *)serviceType requestMethod:(SLRequestMethod)requestMethod URL:(NSURL *)url parameters:(NSDictionary *)parameters;
@property(retain, nonatomic) ACAccount *account;
@property(readonly, nonatomic) SLRequestMethod requestMethod;
@property(readonly, nonatomic) NSURL *URL;
@property(readonly, nonatomic) NSDictionary *parameters;
- (void)performRequestWithHandler:(SLRequestHandler)handler;
- (NSURLRequest *)preparedURLRequest;
- (void)addMultipartData:(NSData *)data withName:(NSString *)name type:(NSString *)type filename:(NSString *)filename;
@end
