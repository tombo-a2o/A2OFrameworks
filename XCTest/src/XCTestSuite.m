/*
 *  XCTestSuite.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <XCTest/XCTestSuite.h>

@implementation XCTestSuite
+ (instancetype)defaultTestSuite
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (instancetype)testSuiteForBundlePath:(NSString *)bundlePath
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (instancetype)testSuiteForTestCaseWithName:(NSString *)name
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (instancetype)testSuiteForTestCaseClass:(Class)testCaseClass
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (instancetype)testSuiteWithName:(NSString *)name
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithName:(NSString *)name
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)addTest:(XCTest *)test
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
