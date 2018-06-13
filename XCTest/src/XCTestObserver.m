/*
 *  XCTestObserver.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <XCTest/XCTestObserver.h>

@implementation XCTestObserver
- (void)startObserving
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)stopObserving
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testSuiteDidStart:(XCTestRun *)testRun
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testSuiteDidStop:(XCTestRun *)testRun
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testCaseDidStart:(XCTestRun *)testRun
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testCaseDidStop:(XCTestRun *)testRun
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testCaseDidFail:(XCTestRun *)testRun withDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
