#import <Foundation/Foundation.h>
#import <XCTest/XCTestAssertionsImpl.h>

@implementation _XCTestCaseInterruptionException
@end

void _XCTFailureHandler(XCTestCase *test, BOOL expected, const char *filePath, NSUInteger lineNumber, NSString *condition, NSString * __nullable format, ...)
{
    NSString *description;
    if(format) {
        va_list args;
        va_start(args, format);
        NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        description = [NSString stringWithFormat:@"%@ - %@", condition, str];
    } else {
        description = condition;
    }
    [test recordFailureWithDescription:description inFile:[NSString stringWithUTF8String:filePath] atLine:lineNumber expected:expected];
}

NSString* _XCTFailureFormat (_XCTAssertionType assertionType, NSUInteger formatIndex)
{
    if(formatIndex != 0) return @"failed (detailed message is not implemented)";

    switch(assertionType) {
    case _XCTAssertion_Fail:
        return @"failed";
    case _XCTAssertion_Nil:
        return @"((%@) is nil failed: (%@) is not nil.";
    case _XCTAssertion_NotNil:
        return @"((%@) is not nil failed: (%@) is nil.";
    case _XCTAssertion_EqualObjects:
        return @"((%@) equal to (%@) failed: (%@) is not equal to (%@).";
    case _XCTAssertion_NotEqualObjects:
        return @"((%@) not equal to (%@) failed: (%@) is equal to (%@).";
    case _XCTAssertion_Equal:
        return @"((%@) equal to (%@) failed: (%@) is not equal to (%@).";
    case _XCTAssertion_NotEqual:
        return @"((%@) not equal to (%@) failed: (%@) is equal to (%@).";
    case _XCTAssertion_EqualWithAccuracy:
        return @"((%@) equal to (%@) with accurary %@ failed: (%@) is not equal to (%@) with %@.";
    case _XCTAssertion_NotEqualWithAccuracy:
        return @"((%@) not equal to (%@) with accurary %@ failed: (%@) is equal to (%@) with %@.";
    case _XCTAssertion_GreaterThan:
        return @"((%@) is greater than (%@) failed: (%@) is not greater than (%@).";
    case _XCTAssertion_GreaterThanOrEqual:
        return @"((%@) is greater than or equal to (%@) failed: (%@) is less than (%@).";
    case _XCTAssertion_LessThan:
        return @"((%@) is less than (%@) failed: (%@) is not less than (%@).";
    case _XCTAssertion_LessThanOrEqual:
        return @"((%@) is less than or equal to (%@) failed: (%@) is greater than (%@).";
    case _XCTAssertion_True:
        return @"((%@) is true failed.";
    case _XCTAssertion_False:
        return @"((%@) is false failed.";
    case _XCTAssertion_Throws:
        return @"((%@) throws exception failed.";
    case _XCTAssertion_ThrowsSpecific:
        return @"((%@) throws %@ failed. %@ (reason: %@) is thrown.";
    case _XCTAssertion_ThrowsSpecificNamed:
        return @"((%@) throws %@ with name(%@) failed. %@ (name: %@, reason: %@) is thrown.";
    case _XCTAssertion_NoThrow:
        return @"((%@) doesn't throw exception failed. Exception (reason: %@) is thrown.";
    case _XCTAssertion_NoThrowSpecific:
        return @"((%@) doesn't throw %@ failed. reason: %@ (reason: %@) is thrown.";
    case _XCTAssertion_NoThrowSpecificNamed:
        return @"((%@) doesn't throw %@ with name(%@) failed. %@ (name: %@, reason: %@) is thrown.";
    }
    assert(0);
}
