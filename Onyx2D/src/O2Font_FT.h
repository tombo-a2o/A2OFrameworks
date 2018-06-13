/*
 *  O2Font_FT.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2Font.h>

#import <stddef.h>
#import <ft2build.h>
#import FT_FREETYPE_H
#import FT_RENDER_H
#import <freetype/freetype.h>

@interface O2Font_FT : O2Font {
    FT_Face _face;
}

- (FT_Face)face;
- (void)getGlyphsForCodePoints:(const unichar *)codes glyphs:(O2Glyph *)glyphs length:(int)length;

@end

FT_Library O2FontSharedFreeTypeLibrary();

//FcConfig *O2FontSharedFontConfig();
