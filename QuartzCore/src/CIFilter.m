/*
 *  CIFilter.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CIFilter.h>
#import <QuartzCore/CIImage.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSException.h>

@interface CIImage(private)
-(void)setFilter:(CIFilter *)filter;
@end

@implementation CIFilter

-initWithName:(NSString *)name {
   _keyValues=[NSMutableDictionary new];
   [_keyValues setObject:name forKey:@"kCIAttributeFilterName"];
   return self;
}

-(void)dealloc {
   [_keyValues release];
   [super dealloc];
}

+(CIFilter *)filterWithName:(NSString *)name {
   return [[[self alloc] initWithName:name] autorelease];
}

-(void)setDefaults {
   // [NSException raise:NSGenericException format:@"Unimplemented"];
}

-(void)setValue:value forKey:(NSString *)key {
   if(value)
    [_keyValues setObject:value forKey:key];
   else
    [_keyValues removeObjectForKey:key];
}

-valueForKey:(NSString *)key {
   if([key isEqual:@"outputImage"]){
    CIImage *image=[CIImage emptyImage];

    [image setFilter:self];
    return image;
   }

   return [_keyValues objectForKey:key];
}

@end
