/*
 *  CMMotionManager.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

@class CMAccelerometerData;

typedef void (^CMAccelerometerHandler)(CMAccelerometerData *accelerometerData, NSError *error);

@interface CMMotionManager : NSObject
@property(assign, nonatomic) NSTimeInterval accelerometerUpdateInterval;
- (void)startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue
                             withHandler:(CMAccelerometerHandler)handler;
- (void)startAccelerometerUpdates;
- (void)stopAccelerometerUpdates;
@end
