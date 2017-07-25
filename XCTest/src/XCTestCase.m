#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@implementation XCTestCase
+ (instancetype)testCaseWithInvocation:(NSInvocation *)invocation
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithInvocation:(NSInvocation *)invocation
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (instancetype)testCaseWithSelector:(SEL)selector
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (instancetype)initWithSelector:(SEL)selector
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)invokeTest
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

+ (NSArray <NSInvocation *> *)testInvocations
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (NSArray <NSString *> *)defaultPerformanceMetrics
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)measureBlock:(void (^)(void))block
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)measureMetrics:(NSArray <NSString *> *)metrics automaticallyStartMeasuring:(BOOL)automaticallyStartMeasuring forBlock:(void (^)(void))block
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)startMeasuring
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)stopMeasuring
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (id <NSObject>)addUIInterruptionMonitorWithDescription:(NSString *)handlerDescription handler:(BOOL (^)(XCUIElement *interruptingElement))handler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (XCTestSuite *)defaultTestSuite
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (void)setUp
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

+ (void)tearDown
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
