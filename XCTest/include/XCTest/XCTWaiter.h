#import <XCTest/XCTestDefines.h>

@class XCTWaiter, XCTestExpectation;

@protocol XCTWaiterDelegate
- (void)waiter:(XCTWaiter *)waiter didTimeoutWithUnfulfilledExpectations:(NSArray<XCTestExpectation *> *)unfulfilledExpectations;
- (void)nestedWaiter:(XCTWaiter *)waiter wasInterruptedByTimedOutWaiter:(XCTWaiter *)outerWaiter;
- (void)waiter:(XCTWaiter *)waiter fulfillmentDidViolateOrderingConstraintsForExpectation:(XCTestExpectation *)expectation
requiredExpectation:(XCTestExpectation *)requiredExpectation;
- (void)waiter:(XCTWaiter *)waiter didFulfillInvertedExpectation:(XCTestExpectation *)expectation;
@end

typedef NS_ENUM(NSInteger, XCTWaiterResult) {
    XCTWaiterResultCompleted = 1,
    XCTWaiterResultTimedOut,
    XCTWaiterResultIncorrectOrder,
    XCTWaiterResultInvertedFulfillment,
    XCTWaiterResultInterrupted,
};

typedef void (^XCTWaiterResultHandler)(XCTWaiterResult result);

@interface XCTWaiter : NSObject
- (instancetype)initWithDelegate:(id<XCTWaiterDelegate>)delegate;
- (XCTWaiterResult)waitForExpectations:(NSArray<XCTestExpectation *> *)expectations
                               timeout:(NSTimeInterval)seconds;
- (XCTWaiterResult)waitForExpectations:(NSArray<XCTestExpectation *> *)expectations
                               timeout:(NSTimeInterval)seconds
                          enforceOrder:(BOOL)enforceOrderOfFulfillment;
- (void)waitForExpectationsAsync:(NSArray<XCTestExpectation *> *)expectations timeout:(NSTimeInterval)timeout callback:(XCTWaiterResultHandler)callback;
+ (XCTWaiterResult)waitForExpectations:(NSArray<XCTestExpectation *> *)expectations
                               timeout:(NSTimeInterval)seconds;
+ (XCTWaiterResult)waitForExpectations:(NSArray<XCTestExpectation *> *)expectations
                               timeout:(NSTimeInterval)seconds
                          enforceOrder:(BOOL)enforceOrderOfFulfillment;
@property(weak) id<XCTWaiterDelegate> delegate;
@property(readonly) NSArray<XCTestExpectation *> *fulfilledExpectations;
@end
