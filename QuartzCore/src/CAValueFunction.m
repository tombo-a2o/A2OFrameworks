/*
 *  CAValueFunction.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CAValueFunction.h>
#import <Foundation/NSString.h>

NSString * const kCAValueFunctionTranslate=@"kCAValueFunctionTranslate";
NSString * const kCAValueFunctionTranslateX=@"kCAValueFunctionTranslateX";
NSString * const kCAValueFunctionTranslateY=@"kCAValueFunctionTranslateY";
NSString * const kCAValueFunctionTranslateZ=@"kCAValueFunctionTranslateZ";

NSString * const kCAValueFunctionScale=@"kCAValueFunctionScale";
NSString * const kCAValueFunctionScaleX=@"kCAValueFunctionScaleX";
NSString * const kCAValueFunctionScaleY=@"kCAValueFunctionScaleY";
NSString * const kCAValueFunctionScaleZ=@"kCAValueFunctionScaleZ";

NSString * const kCAValueFunctionRotateX=@"kCAValueFunctionRotateX";
NSString * const kCAValueFunctionRotateY=@"kCAValueFunctionRotateY";
NSString * const kCAValueFunctionRotateZ=@"kCAValueFunctionRotateZ";

@implementation CAValueFunction

-initWithName:(NSString *)name {
   _name=[name copy];
   return self;
}

-(void)dealloc {
   [_name release];
   [super dealloc];
}

+functionWithName:(NSString *)name {
   return [[[self alloc] initWithName:name] autorelease];
}

-(NSString *)name {
   return _name;
}

@end
