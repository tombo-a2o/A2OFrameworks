#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MCPeerID.h>

typedef NS_ENUM (NSInteger, MCSessionState) {
    MCSessionStateNotConnected,
    MCSessionStateConnecting,
    MCSessionStateConnected 
};

typedef NS_ENUM (NSInteger, MCSessionSendDataMode ) {
    MCSessionSendDataReliable,
    MCSessionSendDataUnreliable 
};

typedef NS_ENUM (NSInteger, MCEncryptionPreference ) {
    MCEncryptionOptional                = 0,
    MCEncryptionRequired                = 1,
    MCEncryptionNone                    = 2,
};

@protocol MCSessionDelegate
@end

@interface MCSession : NSObject
- (instancetype)initWithPeer:(MCPeerID *)myPeerID securityIdentity:(NSArray *)identity encryptionPreference:(MCEncryptionPreference)encryptionPreference;
- (BOOL)sendData:(NSData *)data toPeers:(NSArray *)peerIDs withMode:(MCSessionSendDataMode)mode error:(NSError **)error;
@property(weak, nonatomic) id< MCSessionDelegate > delegate;

@end
