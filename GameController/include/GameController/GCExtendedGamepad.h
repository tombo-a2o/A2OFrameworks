/*
 *  GCExtendedGamepad.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

@class GCController, GCControllerButtonInput, GCControllerDirectionPad, GCControllerElement;

typedef void (^GCExtendedGamepadValueChangedHandler)(GCExtendedGamepad *gamepad, GCControllerElement *element);

@interface GCExtendedGamepad : NSObject
@property(nonatomic, readonly, assign) GCController *controller;
@property(nonatomic, copy) GCExtendedGamepadValueChangedHandler valueChangedHandler;
@property(nonatomic, readonly) GCControllerButtonInput *leftShoulder;
@property(nonatomic, readonly) GCControllerButtonInput *rightShoulder;
@property(nonatomic, readonly) GCControllerDirectionPad *dpad;
@property(nonatomic, readonly) GCControllerButtonInput *buttonA;
@property(nonatomic, readonly) GCControllerButtonInput *buttonB;
@property(nonatomic, readonly) GCControllerButtonInput *buttonX;
@property(nonatomic, readonly) GCControllerButtonInput *buttonY;
@property(nonatomic, readonly) GCControllerDirectionPad *leftThumbstick;
@property(nonatomic, readonly) GCControllerDirectionPad *rightThumbstick;
@property(nonatomic, readonly) GCControllerButtonInput *leftTrigger;
@property(nonatomic, readonly) GCControllerButtonInput *rightTrigger;
@end
