/*
 *  GCController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

extern NSString *const GCControllerDidConnectNotification;
extern NSString *const GCControllerDidDisconnectNotification;

@class GCGamepad, GCExtendedGamepad;

@interface GCController : NSObject
@property(nonatomic, retain, readonly) GCGamepad *gamepad;
@property(nonatomic, retain, readonly) GCExtendedGamepad *extendedGamepad;
@property(nonatomic, readonly, copy) NSString *vendorName;
@property(nonatomic, copy, nonnull) void (^controllerPausedHandler)(GCController *controller);
@property(nonatomic, readonly, getter=isAttachedToDevice) BOOL attachedToDevice;
@end
