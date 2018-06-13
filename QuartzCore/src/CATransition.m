/*
 *  CATransition.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CATransition.h>

@implementation CATransition

-(NSString *)type {
   return _type;
}

-(void)setType:(NSString *)value {
   value=[value copy];
   [_type release];
   _type=value;
}

-(NSString *)subtype {
   return _subtype;
}

-(void)setSubtype:(NSString *)value {
   value=[value copy];
   [_subtype release];
   _subtype=value;
}

-(float)startProgress {
  return _startProgress;
}

-(void)setStartProgress:(float)value {
   _startProgress=value;
}

-(float)endProgress {
   return _endProgress;
}

-(void)setEndProgress:(float)value {
   _endProgress=value;
}

@end
