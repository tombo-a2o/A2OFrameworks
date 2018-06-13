/*
 *  XCTestExpectation.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <XCTest/XCTestDefines.h>
#import <XCTest/XCTestCase.h>

@interface XCTestExpectation : NSObject
- (instancetype)initWithDescription:(NSString *)expectationDescription;
@property(copy) NSString *expectationDescription;
- (void)fulfill;
@property(nonatomic) NSUInteger expectedFulfillmentCount;
@property(nonatomic) BOOL assertForOverFulfill;
@property(getter=isInverted) BOOL inverted;
- (BOOL)isFullfilled;
@end

typedef void (^XCWaitCompletionHandler)(NSError *error);

@interface XCTestCase (Expectation)
- (XCTestExpectation *)expectationWithDescription:(NSString *)description;
- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout
                               handler:(XCWaitCompletionHandler)handler;
@end
