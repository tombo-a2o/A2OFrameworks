/*
 *  GCControllerDirectionPad.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <GameController/GCControllerElement.h>

@class GCControllerAxisInput, GCControllerButtonInput;

@interface GCControllerDirectionPad : GCControllerElement
@property(nonatomic, readonly) GCControllerAxisInput *xAxis;
@property(nonatomic, readonly) GCControllerAxisInput *yAxis;
@property(nonatomic, readonly) GCControllerButtonInput *up;
@property(nonatomic, readonly) GCControllerButtonInput *down;
@property(nonatomic, readonly) GCControllerButtonInput *left;
@property(nonatomic, readonly) GCControllerButtonInput *right;
@end
