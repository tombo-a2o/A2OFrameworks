/*
 *  O2Font_ttf.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2Font.h>

@class NSMapTable;

@interface O2Font_ttf : O2Font {
    NSMapTable *_nameToGlyph;
    int *_glyphLocations;
}

- initWithDataProvider:(O2DataProviderRef)provider;

@end
