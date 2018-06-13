/*
 *  XCTWaiter.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <XCTest/XCTWaiter.h>
#import <XCTest/XCTestExpectation.h>

@implementation XCTWaiter {
    NSMutableArray<XCTestExpectation*> *_expectations;
    XCTWaiterResultHandler _callback;
}

- (instancetype)initWithDelegate:(id<XCTWaiterDelegate>)delegate
{
    self = [super init];
    _delegate = delegate;
    return self;
}

- (XCTWaiterResult)waitForExpectations:(NSArray<XCTestExpectation *> *)expectations timeout:(NSTimeInterval)seconds
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return XCTWaiterResultInterrupted;
}

- (XCTWaiterResult)waitForExpectations:(NSArray<XCTestExpectation *> *)expectations timeout:(NSTimeInterval)seconds enforceOrder:(BOOL)enforceOrderOfFulfillment
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return XCTWaiterResultInterrupted;
}

+ (XCTWaiterResult)waitForExpectations:(NSArray<XCTestExpectation *> *)expectations timeout:(NSTimeInterval)seconds
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return XCTWaiterResultInterrupted;
}

+ (XCTWaiterResult)waitForExpectations:(NSArray<XCTestExpectation *> *)expectations timeout:(NSTimeInterval)seconds enforceOrder:(BOOL)enforceOrderOfFulfillment
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return XCTWaiterResultInterrupted;
}

- (void)waitForExpectationsAsync:(NSArray<XCTestExpectation *> *)expectations timeout:(NSTimeInterval)timeout callback:(XCTWaiterResultHandler)callback
{
    _expectations = [expectations copy];
    _callback = callback;

    if([self isAllFullfilled]) {
        callback(XCTWaiterResultCompleted);
    } else {
        for(XCTestExpectation *expectation in _expectations) {
            [expectation addObserver:self forKeyPath:@"fulfillmentCount" options:NSKeyValueObservingOptionNew context:nil];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (![self isAllFullfilled]) {
                _callback(XCTWaiterResultTimedOut);
            }
            for(XCTestExpectation *expectation in _expectations) {
                [expectation removeObserver:self forKeyPath:@"fulfillmentCount"];
            }
        });
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([self isAllFullfilled]) {
        _callback(XCTWaiterResultCompleted);
    }
}

- (BOOL)isAllFullfilled
{
    BOOL result = YES;
    for(XCTestExpectation *expectation in _expectations) {
        result = result && [expectation isFullfilled];
    }
    return result;
}

@end
