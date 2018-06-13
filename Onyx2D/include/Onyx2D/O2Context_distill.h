/*
 *  O2Context_distill.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2Context.h>

// This is used by PDFKit, it should be possible to implement this functionality
// using the exposed CG* PDF API's with the operator table, but it is more work

@interface O2Context_distill : O2Context {
    id _delegate;
}

- delegate;
- (void)setDelegate:delegate;

@end

@interface NSObject (O2Context_distill)

- (void)distiller:(O2Context_distill *)distiller unicode:(unichar *)unicode rects:(O2Rect *)rect count:(NSUInteger)count;

@end
