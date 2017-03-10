// UIRefreshControl+TomboAFNetworking.m
//
// Copyright (c) 2014 TomboAFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIRefreshControl+TomboAFNetworking.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import "TomboAFHTTPRequestOperation.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#import "TomboAFURLSessionManager.h"
#endif

@implementation UIRefreshControl (TomboAFNetworking)

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
- (void)setRefreshingWithStateOfTask:(NSURLSessionTask *)task {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter removeObserver:self name:TomboAFNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:TomboAFNetworkingTaskDidSuspendNotification object:nil];
    [notificationCenter removeObserver:self name:TomboAFNetworkingTaskDidCompleteNotification object:nil];

    if (task) {
        if (task.state == NSURLSessionTaskStateRunning) {
            [self beginRefreshing];

            [notificationCenter addObserver:self selector:@selector(af_beginRefreshing) name:TomboAFNetworkingTaskDidResumeNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_endRefreshing) name:TomboAFNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_endRefreshing) name:TomboAFNetworkingTaskDidSuspendNotification object:task];
        } else {
            [self endRefreshing];
        }
    }
}
#endif

- (void)setRefreshingWithStateOfOperation:(TomboAFURLConnectionOperation *)operation {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter removeObserver:self name:TomboAFNetworkingOperationDidStartNotification object:nil];
    [notificationCenter removeObserver:self name:TomboAFNetworkingOperationDidFinishNotification object:nil];

    if (operation) {
        if (![operation isFinished]) {
            if ([operation isExecuting]) {
                [self beginRefreshing];
            } else {
                [self endRefreshing];
            }

            [notificationCenter addObserver:self selector:@selector(af_beginRefreshing) name:TomboAFNetworkingOperationDidStartNotification object:operation];
            [notificationCenter addObserver:self selector:@selector(af_endRefreshing) name:TomboAFNetworkingOperationDidFinishNotification object:operation];
        }
    }
}

#pragma mark -

- (void)af_beginRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self beginRefreshing];
    });
}

- (void)af_endRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endRefreshing];
    });
}

@end

#endif
