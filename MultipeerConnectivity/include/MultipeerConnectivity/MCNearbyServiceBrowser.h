#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MCPeerID.h>
#import <MultipeerConnectivity/MCSession.h>

@protocol MCNearbyServiceBrowserDelegate
@end

@interface MCNearbyServiceBrowser : NSObject
- (instancetype)initWithPeer:(MCPeerID *)myPeerID serviceType:(NSString *)serviceType;
- (void)invitePeer:(MCPeerID *)peer toSession:(MCSession *)session withContext:(NSData *)context timeout:(NSTimeInterval)timeout;
- (void)startBrowsingForPeers;
- (void)stopBrowsingForPeers;
@property(weak, nonatomic) id< MCNearbyServiceBrowserDelegate > delegate;
@property(readonly, nonatomic) MCPeerID *myPeerID;
@property(readonly, nonatomic) NSString *serviceType;

@end
