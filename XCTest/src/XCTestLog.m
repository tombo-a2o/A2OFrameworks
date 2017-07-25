#import <Foundation/Foundation.h>
#import <XCTest/XCTestLog.h>

@implementation XCTestLog
- (void)testLogWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)testLogWithFormat:(NSString *)format arguments:(va_list)arguments NS_FORMAT_FUNCTION(1,0)
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
