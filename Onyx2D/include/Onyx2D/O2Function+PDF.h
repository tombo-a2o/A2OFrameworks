/*
 *  O2Function+PDF.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2Function.h>

@class O2PDFArray, O2PDFDictionary, O2PDFObject, O2PDFContext, O2PDFStream;

@interface O2Function (PDF)
- initWithDomain:(O2PDFArray *)domain range:(O2PDFArray *)range;
- (O2PDFObject *)encodeReferenceWithContext:(O2PDFContext *)context;
+ (O2Function *)createFunctionWithDictionary:(O2PDFDictionary *)dictionary;
+ (O2Function *)createFunctionWithStream:(O2PDFStream *)stream;
@end
