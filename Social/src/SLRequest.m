/*
 *  SLRequest.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Social/Social.h>

@implementation SLRequest
+ (SLRequest *)requestForServiceType:(NSString *)serviceType requestMethod:(SLRequestMethod)requestMethod URL:(NSURL *)url parameters:(NSDictionary *)parameters
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return nil;
}

- (void)performRequestWithHandler:(SLRequestHandler)handler
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (NSURLRequest *)preparedURLRequest
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return nil;
}

- (void)addMultipartData:(NSData *)data withName:(NSString *)name type:(NSString *)type filename:(NSString *)filename
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

@end
