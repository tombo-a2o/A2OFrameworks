#import "UIRuntimeConnection.h"

@implementation UIRuntimeConnection
- (instancetype)initWithCoder:(NSCoder*)coder {
    source = [coder decodeObjectForKey:@"UISource"];
    destination = [coder decodeObjectForKey:@"UIDestination"];
    label = [coder decodeObjectForKey:@"UILabel"];
    return self;
}

- (void)makeConnection {
}

@end
