/*
 *  O2PDFCharWidths.h
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

@class O2PDFArray;

@interface O2PDFCharWidths : NSObject {
    O2Float _widths[256];
}

- initWithArray:(O2PDFArray *)array firstChar:(int)firstChar lastChar:(int)lastChar missingWidth:(CGFloat)missingWidth;

void O2PDFCharWidthsGetAdvances(O2PDFCharWidths *self, O2Size *advances, const uint8_t *bytes, int length);

@end
