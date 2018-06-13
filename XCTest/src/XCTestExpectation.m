/*
 *  XCTestExpectation.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <XCTest/XCTest.h>

@interface XCTestExpectation ()
@property NSUInteger fulfillmentCount;
@end

@implementation XCTestExpectation

- (instancetype)initWithDescription:(NSString *)expectationDescription
{
    self = [super init];
    _expectationDescription = expectationDescription;
    _expectedFulfillmentCount = 1;
    _fulfillmentCount = 0;
    return self;
}

- (void)fulfill
{
    self.fulfillmentCount = self.fulfillmentCount + 1;
}

- (BOOL)isFullfilled
{
    return _expectedFulfillmentCount == _fulfillmentCount;
}

@end
