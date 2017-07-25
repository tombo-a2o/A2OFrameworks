#import <XCTest/XCTestDefines.h>

@interface XCTestExpectation : NSObject
- (instancetype)initWithDescription:(NSString *)expectationDescription;
@property(copy) NSString *expectationDescription;
- (void)fulfill;
@property(nonatomic) NSUInteger expectedFulfillmentCount;
@property(nonatomic) BOOL assertForOverFulfill;
@property(getter=isInverted) BOOL inverted;
@end

typedef void (^XCWaitCompletionHandler)(NSError *error);

@interface XCTestCase (Expectation)
- (XCTestExpectation *)expectationWithDescription:(NSString *)description;
- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout
                               handler:(XCWaitCompletionHandler)handler;
@end
