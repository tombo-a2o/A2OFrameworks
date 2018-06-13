/*
 *  CMAccelerometerData.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#import <CoreMotion/CMLogItem.h>

typedef struct CMAcceleration {
    double x;
    double y;
    double z;
} CMAcceleration;

@interface CMAccelerometerData : CMLogItem
@property(readonly, nonatomic) CMAcceleration acceleration;
@end
