/*
 *  CMMotionManager.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreMotion/CoreMotion.h>

@implementation CMMotionManager
- (void)startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAccelerometerHandler)handler
{
  NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)startAccelerometerUpdates;
{
  NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)stopAccelerometerUpdates;
{
  NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
