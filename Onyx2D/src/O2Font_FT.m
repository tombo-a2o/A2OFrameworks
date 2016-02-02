/* Copyright (c) 2008 Johannes Fortmann
   Copyright (c) 2009 Christopher J. W. Lloyd - <cjwl@objc.net>

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
#import "O2Font_FT.h"

O2FontRef O2FontCreateWithFontName_freetype(NSString *name) {
    return [[O2Font_FT alloc] initWithFontName:name];
}

O2FontRef O2FontCreateWithDataProvider_platform(O2DataProviderRef provider) {
#ifdef FREETYPE_PRESENT
    return [[O2Font_freetype alloc] initWithDataProvider:provider];
#else
    return nil;
#endif

}

/*
@implementation O2Font(FreeType)

    +allocWithZone:(NSZone *)zone {
        return NSAllocateObject([O2Font_FT class],0,NULL);
    }

@end
*/

@implementation O2Font_FT

FT_Library O2FontSharedFreeTypeLibrary(){
    static FT_Library library=NULL;

    if(library==NULL){
        if(FT_Init_FreeType(&library)!=0)
            NSLog(@"FT_Init_FreeType failed");
    }

    return library;
}

+(NSString*)filenameForPattern:(NSString *)pattern {
    return [self searchFontFileName:pattern];
}

-initWithFontName:(NSString *)name {
   [super initWithFontName:name];

   NSString *filename=[[self class] filenameForPattern:name];

   FT_Error ret=FT_New_Face(O2FontSharedFreeTypeLibrary(),[filename fileSystemRepresentation],0,&_face);

   if(ret!=0) {
       NSLog(@"FT_New_Face returned %d %@ %@", ret, name, filename);
       return nil;
   }

   FT_Select_Charmap(_face, FT_ENCODING_UNICODE);
   //  FT_Set_Char_Size(_face,0,2048*64,72,72);

   if(!(_face->face_flags&FT_FACE_FLAG_SCALABLE))
       NSLog(@"FreeType font face is not scalable");

   _unitsPerEm=(float)_face->units_per_EM;
   _ascent=_face->ascender;
   _descent=_face->descender;
   _leading=0;
   _capHeight=_face->height;
   _xHeight=_face->height;
   _italicAngle=0;
   _stemV=0;
   _bbox.origin.x=_face->bbox.xMin;
   _bbox.origin.y=_face->bbox.yMin;
   _bbox.size.width=_face->bbox.xMax-_face->bbox.xMin;
   _bbox.size.height=_face->bbox.yMax-_face->bbox.yMin;
   _numberOfGlyphs=_face->num_glyphs;
   _advances=NULL;

   return self;
}

-(void)dealloc {
    FT_Done_Face(_face);
    [super dealloc];
}

-(FT_Face)face {
    return _face;
}

-(O2Glyph)glyphWithGlyphName:(NSString *)name {
                    // FIXME: implement
    return 0;
}

-(void)fetchAdvances {
    O2Glyph glyph;

#warning TODO use device specific value
    FT_Set_Char_Size(_face,0,_unitsPerEm*64,72,72);

    _advances=NSZoneMalloc(NULL,sizeof(int)*_numberOfGlyphs);

    for(glyph=0;glyph<_numberOfGlyphs;glyph++){
        FT_Load_Glyph(_face, glyph, FT_LOAD_DEFAULT);

        _advances[glyph]=_face->glyph->advance.x/(float)(2<<5);
    }
}

-(CGFloat)getTextWidth:(const unichar *)codes count:(size_t)count fontSize:(CGFloat)fontSize {
    CGFloat result = 0;

    FT_Set_Char_Size(_face, 0, fontSize * 64, 72, 72);
    for(int i = 0; i < count; i++) {
        O2Glyph glyph = FT_Get_Char_Index(_face, codes[i]);
        FT_Error ftError = FT_Load_Glyph(_face, glyph, FT_LOAD_DEFAULT);
        if(ftError) {
            continue;
        }
        //printf("%d %d\n", i, _face->glyph->advance.x >> 6);
        result += _face->glyph->advance.x / 64.0;
    }
    return result;
}

-(int)suggestLineBreak:(const unichar *)codes count:(size_t)count fontSize:(CGFloat)fontSize start:(size_t)start width:(CGFloat)width {
    CGFloat result = 0;

    FT_Set_Char_Size(_face, 0, fontSize * 64, 72, 72);
    for(int i = start; i < count; i++) {
        O2Glyph glyph = FT_Get_Char_Index(_face, codes[i]);
        FT_Error ftError = FT_Load_Glyph(_face, glyph, FT_LOAD_DEFAULT);
        if(ftError) {
            continue;
        }
        result += _face->glyph->advance.x / 64.0;
        
        if(result > width) {
            return i - start;
        }
    }
    return count - start;
}

-(O2Encoding *)createEncodingForTextEncoding:(O2TextEncoding)encoding {
    O2Glyph glyphs[256];
    uint16_t unicode[256];
    int     i;

    for(i=0;i<256;i++){
        glyphs[i] = FT_Get_Char_Index(_face, i);
        unicode[i] = i;
    }

    return [[O2Encoding alloc] initWithGlyphs:glyphs unicode:unicode];
}

-(void)getGlyphsForCodePoints:(const unichar *)codes glyphs:(O2Glyph *)glyphs length:(int)length {
    int i;

    for(i=0;i<length;i++) {
        glyphs[i]=FT_Get_Char_Index(_face, codes[i]);
    }
}

@end
