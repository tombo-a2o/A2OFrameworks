#import <Foundation/Foundation.h>
#import <XCTest/XCTestRun.h>

@implementation XCTestRun
+ (instancetype)testRunWithTest:(XCTest *)test
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithTest:(XCTest *)test
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)start
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)stop
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
