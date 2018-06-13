/*
 *  O2PDFBlock.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import "O2PDFBlock.h"
#import <Foundation/NSArray.h>

@implementation O2PDFBlock

+pdfBlock {
   return [[[O2PDFBlock alloc] init] autorelease];
}

-init {
   _objects=[[NSMutableArray alloc] init];
   return self;
}

-(void)dealloc {
   [_objects release];
   [super dealloc];
}

-(O2PDFObjectType)objectType {
   return kO2PDFObjectTypeBlock;
}

-(NSArray *)objects {
   return _objects;
}

-(void)addObject:object {
   [_objects addObject:object];
}

-(NSString *)description {
   return [NSString stringWithFormat:@"<%@ %x> { %@ }",[self class],self,_objects];
}

@end
