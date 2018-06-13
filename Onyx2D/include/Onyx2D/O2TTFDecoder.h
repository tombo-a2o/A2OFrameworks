/*
 *  O2TTFDecoder.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2DataProvider.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/NSMapTable.h>
#import <Onyx2D/O2Path.h>

@class O2TTFDecoder;

typedef O2TTFDecoder *O2TTFDecoderRef;

@interface O2TTFDecoder : NSObject {
    O2DataProviderRef _dataProvider;
    CFDataRef _data;
    const uint8_t *_bytes;
    CFIndex _length;
    CFIndex _position;

    int _dump;
}

O2TTFDecoderRef O2TTFDecoderCreate(O2DataProviderRef dataProvider);

O2TTFDecoderRef O2TTFDecoderRetain(O2TTFDecoderRef self);
void O2TTFDecoderRelease(O2TTFDecoderRef self);

NSMapTable *O2TTFDecoderGetPostScriptNameMapTable(O2TTFDecoderRef self, int *numberOfGlyphs);

int *O2TTFDecoderGetGlyphLocations(O2TTFDecoderRef self, int numberOfGlyphs);

O2PathRef O2TTFDecoderGetGlyphOutline(O2TTFDecoderRef self, int glyphLocation);

void O2TTFDecoderGetNameTable(O2TTFDecoderRef self);

@end
