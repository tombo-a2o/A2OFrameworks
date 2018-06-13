/*
 *  MCNearbyServiceBrowser.h
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
