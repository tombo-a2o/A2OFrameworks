#import <Foundation/Foundation.h>
#import <XCTest/XCTestProbe.h>

@implementation XCTestProbe
+ (BOOL)isTesting
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return NO;
}

@end
