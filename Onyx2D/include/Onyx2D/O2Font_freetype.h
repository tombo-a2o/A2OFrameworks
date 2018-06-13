/*
 *  O2Font_freetype.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2Font.h>
//#import "O2Defines_FreeType.h"

#ifdef FREETYPE_PRESENT

#include <ft2build.h>
#include FT_FREETYPE_H

@interface O2Font_freetype : O2Font {
    FT_Face _face;
    FT_Encoding _ftEncoding;
    O2Encoding *_macRomanEncoding;
    O2Encoding *_macExpertEncoding;
    O2Encoding *_winAnsiEncoding;
}

- initWithDataProvider:(O2DataProviderRef)provider;

FT_Face O2FontFreeTypeFace(O2Font_freetype *self);

@end

#endif
