#import <XCTest/XCTest.h>

@implementation XCTestExpectation

- (instancetype)initWithDescription:(NSString *)expectationDescription
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)fulfill
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
