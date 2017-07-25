#import <Foundation/Foundation.h>
#import <XCTest/XCTestObserver.h>

@implementation XCTestObserver
- (void)startObserving
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)stopObserving
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testSuiteDidStart:(XCTestRun *)testRun
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testSuiteDidStop:(XCTestRun *)testRun
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testCaseDidStart:(XCTestRun *)testRun
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testCaseDidStop:(XCTestRun *)testRun
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testCaseDidFail:(XCTestRun *)testRun withDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
