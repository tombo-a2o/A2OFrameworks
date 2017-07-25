#import <XCTest/XCTestDefines.h>

@interface XCTestExpectation : NSObject
- (instancetype)initWithDescription:(NSString *)expectationDescription;
@property(copy) NSString *expectationDescription;
- (void)fulfill;
@property(nonatomic) NSUInteger expectedFulfillmentCount;
@property(nonatomic) BOOL assertForOverFulfill;
@property(getter=isInverted) BOOL inverted;
@end
