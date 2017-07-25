#import <Foundation/Foundation.h>
#import <XCTest/XCTestSuite.h>

@implementation XCTestSuite
+ (instancetype)defaultTestSuite
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (instancetype)testSuiteForBundlePath:(NSString *)bundlePath
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (instancetype)testSuiteForTestCaseWithName:(NSString *)name
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (instancetype)testSuiteForTestCaseClass:(Class)testCaseClass
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (instancetype)testSuiteWithName:(NSString *)name
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithName:(NSString *)name
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)addTest:(XCTest *)test
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
