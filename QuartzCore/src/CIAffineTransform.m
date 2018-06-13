/*
 *  CIAffineTransform.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CIAffineTransform.h>
#import <Foundation/NSKeyedArchiver.h>
#import <Foundation/NSString.h>
#import <Foundation/NSException.h>

@implementation CIAffineTransform

-(void)encodeWithCoder:(NSCoder *)coder {
   [NSException raise:NSGenericException format:@"Unimplemented"];
}

-initWithCoder:(NSCoder *)coder {
   if([coder allowsKeyedCoding]){
    NSKeyedUnarchiver *keyed=(NSKeyedUnarchiver *)coder;

    _transform=[[keyed decodeObjectForKey:@"CI_inputTransform"] copy];
    _ciEnabled=[keyed decodeBoolForKey:@"CIEnabled"];
   }
   return self;
}

-(void)dealloc {
  [_transform release];
  [super dealloc];
}

-(NSAffineTransform *)affineTransform {
   return _transform;
}

@end
