/*
 *  KTFont+PDF.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import "KTFont.h"

@class KGPDFObject, KGPDFContext;

@interface KTFont (PDF)
- (void)getBytes:(unsigned char *)bytes forGlyphs:(const CGGlyph *)glyphs length:(unsigned)length;
- (KGPDFObject *)encodeReferenceWithContext:(KGPDFContext *)context;
@end
