#import <XCTest/XCTestDefines.h>
#import <XCTest/XCTestCase.h>

@interface XCTestExpectation : NSObject
- (instancetype)initWithDescription:(NSString *)expectationDescription;
@property(copy) NSString *expectationDescription;
- (void)fulfill;
@property(nonatomic) NSUInteger expectedFulfillmentCount;
@property(nonatomic) BOOL assertForOverFulfill;
@property(getter=isInverted) BOOL inverted;
- (BOOL)isFullfilled;
@end

typedef void (^XCWaitCompletionHandler)(NSError *error);

@interface XCTestCase (Expectation)
- (XCTestExpectation *)expectationWithDescription:(NSString *)description;
- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout
                               handler:(XCWaitCompletionHandler)handler;
@end
