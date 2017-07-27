#import <XCTest/XCTest.h>

@interface XCTestExpectation ()
@property NSUInteger fulfillmentCount;
@end

@implementation XCTestExpectation

- (instancetype)initWithDescription:(NSString *)expectationDescription
{
    self = [super init];
    _expectationDescription = expectationDescription;
    _expectedFulfillmentCount = 1;
    _fulfillmentCount = 0;
    return self;
}

- (void)fulfill
{
    _fulfillmentCount++;
}

- (BOOL)isFullfilled
{
    return _expectedFulfillmentCount == _fulfillmentCount;
}

@end
