#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MCPeerID.h>

@protocol MCNearbyServiceAdvertiserDelegate
@end

@interface MCNearbyServiceAdvertiser : NSObject
- (instancetype)initWithPeer:(MCPeerID *)myPeerID discoveryInfo:(NSDictionary *)info serviceType:(NSString *)serviceType;
- (void)startAdvertisingPeer;
- (void)stopAdvertisingPeer;
@property(weak, nonatomic) id< MCNearbyServiceAdvertiserDelegate > delegate;

@end
