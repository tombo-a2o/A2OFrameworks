/*
 *  CIImage.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CIImage.h>

@implementation CIImage

+(CIImage *)emptyImage {
   return [[self alloc] initWithCGImage:NULL];
}

-initWithCGImage:(CGImageRef)cgImage {
   _cgImage=CGImageRetain(cgImage);
   _filter=nil;
   return self;
}

-(void)dealloc {
   CGImageRelease(_cgImage);
   [_filter release];
   [super dealloc];
}

-(CGRect)extent {
   CGRect result;

   result.origin.x=0;
   result.origin.y=0;
   result.size.width=CGImageGetWidth(_cgImage);
   result.size.height=CGImageGetHeight(_cgImage);

   return result;
}

-(CGImageRef)CGImage {
   return _cgImage;
}

-(CIFilter *)filter {
   return _filter;
}

-(void)setFilter:(CIFilter *)filter {
   filter=[filter retain];
   [_filter release];
   _filter=filter;
}

@end
