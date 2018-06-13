/*
 *  CAMediaTimingFunction.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>
#import <QuartzCore/CABase.h>

CA_EXPORT NSString *const kCAMediaTimingFunctionLinear;
CA_EXPORT NSString *const kCAMediaTimingFunctionEaseIn;
CA_EXPORT NSString *const kCAMediaTimingFunctionEaseOut;
CA_EXPORT NSString *const kCAMediaTimingFunctionEaseInEaseOut;
CA_EXPORT NSString *const kCAMediaTimingFunctionDefault;

@interface CAMediaTimingFunction : NSObject {
    float _c1x;
    float _c1y;
    float _c2x;
    float _c2y;
}

- (id)initWithControlPoints:(float)c1x:(float)c1y:(float)c2x:(float)c2y;

+ functionWithControlPoints:(float)c1x:(float)c1y:(float)c2x:(float)c2y;

+ functionWithName:(NSString *)name;

- (void)getControlPointAtIndex:(size_t)index values:(float[2])ptr;

@end
