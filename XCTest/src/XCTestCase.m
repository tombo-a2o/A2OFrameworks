#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface XCTestCase () <XCTWaiterDelegate>
@property(getter=isFailed) BOOL failed;
@property(getter=isFinished) BOOL finished;
- (void)invokeTestAsyncWithCallback:(void (^)(void))callback;
@end

@implementation XCTestCase {
    NSMutableArray<XCTestExpectation*> *_expectations;
    XCTWaiter *_waiter;
}

+ (instancetype)testCaseWithInvocation:(NSInvocation *)invocation
{
    return [[XCTestCase alloc] initWithInvocation:invocation];
}

- (instancetype)initWithInvocation:(NSInvocation *)invocation
{
    _invocation = invocation;
    _failed = NO;
    _finished = NO;
    _expectations = [[NSMutableArray alloc] init];
    _waiter = [[XCTWaiter alloc] initWithDelegate:self];
    return self;
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
    [_invocation invokeWithTarget:self];
    if(_expectations.count == 0) {
        _finished = YES;
    }
}

- (void)invokeTestAsyncWithCallback:(void (^)(void))callback
{
    [_invocation invokeWithTarget:self];
    if(_expectations.count == 0) {
        _finished = YES;
        callback();
        return;
    }
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_current_queue());
    dispatch_source_set_timer(source, DISPATCH_TIME_NOW, NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(source, ^{
        if(_finished) {
            callback();
            dispatch_suspend(source);
        }
    });
    dispatch_resume(source);
}

- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected
{
    _failed = YES;
    NSLog(@"%@:%d: error: %@ : %@", filePath, lineNumber, [self description], description);
}

+ (NSArray <NSInvocation *> *)testInvocations
{
    unsigned int count = 0;
    Method* methods = class_copyMethodList(self, &count);

    NSMutableArray <NSInvocation *> *ret = [NSMutableArray arrayWithCapacity:count];
    for(int i = 0; i < count; i++) {
        Method meth = methods[i];
        SEL sel = method_getName(meth);
        const char* name = sel_getName(sel);
        char* returnType = method_copyReturnType(meth);
        if(method_getNumberOfArguments(meth) == 2 && returnType[0] == 'v' && strncmp(name, "test", 4) == 0) {
            const char* signature = method_getTypeEncoding(meth);
            NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:signature];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
            invocation.selector = sel;
            [ret addObject:invocation];
            // NSLog(@"%s %s", name, signature);
        }
        free(returnType);
    }

    // NSLog(@"%s %@", __FUNCTION__, ret);

    return ret;
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

- (void)removeUIInterruptionMonitor:(id <NSObject>)monitor
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

+ (XCTestSuite *)defaultTestSuite
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

+ (void)setUp
{
    // abstract method
}

+ (void)tearDown
{
    // abstract method
}

- (void)setUp
{
    // abstract method
}

- (void)tearDown
{
    // abstract method
}

- (XCTestExpectation *)expectationWithDescription:(NSString *)description
{
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:description];
    [_expectations addObject:expectation];
    return expectation;
}

- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout
                               handler:(XCWaitCompletionHandler)handler
{
    [_waiter waitForExpectationsAsync:_expectations timeout:timeout callback:^(XCTWaiterResult result){
        NSError *error = nil;
        if(result != XCTWaiterResultCompleted) {
            error = [NSError errorWithDomain:@"com.apple.XCTestErrorDomain" code:result userInfo:nil];
            _failed = YES;
        }
        handler(error);
        _finished = YES;
    }];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"-[%@ %s]", [self class], sel_getName(_invocation.selector)];
}
@end
