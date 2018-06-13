/*
 *  MCSession.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
