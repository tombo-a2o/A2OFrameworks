/*
 *  O2ColorSpace+PDF.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2ColorSpace.h>

@class O2PDFObject, O2PDFContext;

@interface O2ColorSpace (PDF)
- (O2PDFObject *)encodeReferenceWithContext:(O2PDFContext *)context;
+ (O2ColorSpaceRef)createColorSpaceFromPDFObject:(O2PDFObject *)object;
@end
