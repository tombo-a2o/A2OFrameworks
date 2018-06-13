/*
 *  O2ClipState.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>
#import <Onyx2D/O2Geometry.h>
#import <Onyx2D/O2AffineTransform.h>

@class NSArray, NSMutableArray, O2Path, O2Image, O2ClipMask;

typedef enum {
    O2ClipStateTypeNone,
    O2ClipStateTypeOneRect,
    O2ClipStateTypeOnePath,
    O2ClipStateTypeOneRectOnePath,
    O2ClipStateTypeOneRectManyPaths,
    O2ClipStateTypeManyPaths,
    O2ClipStateTypeManyPathsAndMasks,
} O2ClipStateType;

@interface O2ClipState : NSObject {
    O2ClipStateType _type;
    O2Rect _rect;
    BOOL _evenOdd;
    O2Path *_path;
    NSMutableArray *_phases;
    O2Rect _integralRect;
    O2ClipMask *_integralMask;
}

O2ClipStateType O2ClipStateGetType(O2ClipState *self);

O2ClipState *O2ClipStateCreateCopy(O2ClipState *self);

void O2ClipStateReset(O2ClipState *self);

O2Path *O2ClipStateOnePath(O2ClipState *self);

O2Rect O2ClipStateIntegralRect(O2ClipState *self);
O2ClipMask *O2ClipStateIntegralMask(O2ClipState *self);

- (NSArray *)clipPhases;
- (void)addNonZeroWindingPath:(O2Path *)path;
- (void)addEvenOddWindingPath:(O2Path *)path;
- (void)addMask:(O2Image *)image inRect:(O2Rect)rect transform:(O2AffineTransform)transform;

@end
