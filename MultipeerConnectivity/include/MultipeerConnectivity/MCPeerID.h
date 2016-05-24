#import <Foundation/NSObject.h>

@interface MCPeerID : NSObject
- (instancetype)initWithDisplayName:(NSString *)myDisplayName;
@property(readonly, nonatomic) NSString *displayName;
@end
