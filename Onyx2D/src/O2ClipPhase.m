/*
 *  O2ClipPhase.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2ClipPhase.h>

@implementation O2ClipPhase

O2ClipPhase *O2ClipPhaseInitWithNonZeroPath(O2ClipPhase *self,O2Path *path){
   self->_type=O2ClipPhaseNonZeroPath;
   self->_object=[path copy];
   return self;
}

-initWithEOPath:(O2Path *)path {
   _type=O2ClipPhaseEOPath;
   _object=[path copy];
   return self;
}

-initWithMask:(O2Image *)mask rect:(O2Rect)rect transform:(O2AffineTransform)transform {
   _type=O2ClipPhaseMask;
   _object=[mask retain];
   _rect=rect;
   _transform=transform;
   return self;
}

-(void)dealloc {
   [_object release];
   [super dealloc];
}

O2ClipPhaseType O2ClipPhasePhaseType(O2ClipPhase *self) {
   return self->_type;
}

id O2ClipPhaseObject(O2ClipPhase *self) {
   return self->_object;
}

@end
