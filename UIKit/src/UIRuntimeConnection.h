#import <Foundation/NSObject.h>

@interface UIRuntimeConnection : NSObject {
@public
    id source;
    id destination;
    id label;
}
- (instancetype)initWithCoder:(NSCoder*)coder;
- (void)makeConnection;
@end
