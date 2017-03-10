// TomboAFNetworkReachabilityManagerTests.h
// Copyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/)
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

#import "TomboAFTestCase.h"

#import "TomboAFNetworkReachabilityManager.h"
#import <netinet/in.h>

@interface TomboAFNetworkReachabilityManagerTests : TomboAFTestCase
@property (nonatomic, strong) TomboAFNetworkReachabilityManager *addressReachability;
@property (nonatomic, strong) TomboAFNetworkReachabilityManager *domainReachability;
@end

@implementation TomboAFNetworkReachabilityManagerTests

- (void)setUp {
    [super setUp];

    //both of these manager objects should always be reachable when the tests are run
    self.domainReachability = [TomboAFNetworkReachabilityManager managerForDomain:@"localhost"];

    //don't use the shared manager because it retains state between tests
    //but recreate it each time in the same way that the shared manager is created
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = TOMBO_AF_INET;
    self.addressReachability = [TomboAFNetworkReachabilityManager managerForAddress:&address];
}

- (void)tearDown
{
    [self.addressReachability stopMonitoring];
    [self.domainReachability stopMonitoring];

    [super tearDown];
}

- (void)testAddressReachabilityStartsInUnknownState {
    XCTAssertEqual(self.addressReachability.networkReachabilityStatus, TomboAFNetworkReachabilityStatusUnknown,
                   @"Reachability should start in an unknown state");
}

- (void)testDomainReachabilityStartsInUnknownState {
    XCTAssertEqual(self.domainReachability.networkReachabilityStatus, TomboAFNetworkReachabilityStatusUnknown,
                   @"Reachability should start in an unknown state");
}

- (void)verifyReachabilityNotificationGetsPostedWithManager:(TomboAFNetworkReachabilityManager *)manager
{
    [self expectationForNotification:TomboAFNetworkingReachabilityDidChangeNotification
                              object:nil
                             handler:^BOOL(NSNotification *note) {
                                 TomboAFNetworkReachabilityStatus status;
                                 status = [note.userInfo[TomboAFNetworkingReachabilityNotificationStatusItem] integerValue];
                                 BOOL reachable = (status == TomboAFNetworkReachabilityStatusReachableViaWiFi
                                                   || status == TomboAFNetworkReachabilityStatusReachableViaWWAN);

                                 XCTAssert(reachable,
                                           @"Expected network to be reachable but got '%@'",
                                           TomboAFStringFromNetworkReachabilityStatus(status));
                                 XCTAssertEqual(reachable, manager.isReachable, @"Expected status to match 'isReachable'");

                                 return YES;
                             }];

    [manager startMonitoring];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testAddressReachabilityNotification {
    [self verifyReachabilityNotificationGetsPostedWithManager:self.addressReachability];
}

- (void)testDomainReachabilityNotification {
    [self verifyReachabilityNotificationGetsPostedWithManager:self.domainReachability];
}

- (void)verifyReachabilityStatusBlockGetsCalledWithManager:(TomboAFNetworkReachabilityManager *)manager
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"reachability status change block gets called"];

    typeof(manager) __weak weakManager = manager;
    [manager setReachabilityStatusChangeBlock:^(TomboAFNetworkReachabilityStatus status) {
        BOOL reachable = (status == TomboAFNetworkReachabilityStatusReachableViaWiFi
                          || status == TomboAFNetworkReachabilityStatusReachableViaWWAN);

        XCTAssert(reachable, @"Expected network to be reachable but got '%@'", TomboAFStringFromNetworkReachabilityStatus(status));
        XCTAssertEqual(reachable, weakManager.isReachable, @"Expected status to match 'isReachable'");

        [expectation fulfill];
    }];

    [manager startMonitoring];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [manager setReachabilityStatusChangeBlock:nil];
    }];
}

- (void)testAddressReachabilityBlock {
    [self verifyReachabilityStatusBlockGetsCalledWithManager:self.addressReachability];
}

- (void)testDomainReachabilityBlock {
    [self verifyReachabilityStatusBlockGetsCalledWithManager:self.domainReachability];
}

@end
