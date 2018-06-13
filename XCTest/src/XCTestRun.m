/*
 *  XCTestRun.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <XCTest/XCTestRun.h>

@implementation XCTestRun
+ (instancetype)testRunWithTest:(XCTest *)test
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithTest:(XCTest *)test
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)start
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)stop
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
