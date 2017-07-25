#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@implementation XCTestProbe
+ (BOOL)isTesting
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return NO;
}

@end
