/*
 *  MCNearbyServiceAdvertiser.h
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

@protocol MCNearbyServiceAdvertiserDelegate
@end

@interface MCNearbyServiceAdvertiser : NSObject
- (instancetype)initWithPeer:(MCPeerID *)myPeerID discoveryInfo:(NSDictionary *)info serviceType:(NSString *)serviceType;
- (void)startAdvertisingPeer;
- (void)stopAdvertisingPeer;
@property(weak, nonatomic) id< MCNearbyServiceAdvertiserDelegate > delegate;

@end
