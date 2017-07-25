#import <Foundation/Foundation.h>
#import <XCTest/XCTestCaseRun.h>

@implementation XCTestCaseRun
- (void)recordFailureInTest:(XCTestCase *)testCase withDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected DEPRECATED_ATTRIBUTE
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
