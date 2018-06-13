/*
 *  XCAbstractTest.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <XCTest/XCAbstractTest.h>

@implementation XCTest

- (void)performTest:(XCTestRun *)run
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)runTest
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)setUp
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)tearDown
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
