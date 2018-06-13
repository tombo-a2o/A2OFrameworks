/*
 *  O2Font+PDF.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2Font.h>

@class O2PDFObject, O2PDFContext;

@interface O2Font (PDF)
- (void)getMacRomanBytes:(unsigned char *)bytes forGlyphs:(const O2Glyph *)glyphs length:(unsigned)length;
- (O2PDFObject *)encodeReferenceWithContext:(O2PDFContext *)context size:(O2Float)size;
@end
