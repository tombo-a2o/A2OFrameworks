/*
 *  XCTestLog.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <XCTest/XCTestLog.h>

@implementation XCTestLog
- (void)testLogWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testLogWithFormat:(NSString *)format arguments:(va_list)arguments NS_FORMAT_FUNCTION(1,0)
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
