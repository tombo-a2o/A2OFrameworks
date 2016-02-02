#import "O2Font_canvas.h"

O2FontRef O2FontCreateWithFontName_canvas(NSString *name) {
    return [[O2Font_canvas alloc] initWithFontName:name];
}

@implementation O2Font_canvas
-initWithFontName:(NSString *)name {
    self = [super initWithFontName:name];

    _unitsPerEm=100;
    a2o_getFontMetrics([_name UTF8String], _unitsPerEm, &_ascent, &_descent, &_capHeight, &_xHeight);
    _descent = -_descent; // descent should be negative value
    return self;
}

-(CGFloat)getTextWidth:(const unichar *)codes count:(size_t)count fontSize:(CGFloat)fontSize {
    // ucnihar -> utf8 char*
    NSString *text = [NSString stringWithCharacters:codes length:count];
    return a2o_getTextWidth([_name UTF8String], fontSize, [text UTF8String]);
}

-(int)suggestLineBreak:(const unichar *)codes count:(size_t)count fontSize:(CGFloat)fontSize start:(size_t)start width:(CGFloat)width {
    NSString *text = [NSString stringWithCharacters:codes length:count];
    return a2o_suggestLineBreak([_name UTF8String], fontSize, [text UTF8String], start, width);
}

-(void)getGlyphsForCodePoints:(const unichar *)codes glyphs:(O2Glyph *)glyphs length:(int)length {
    // glyph = code point
    for(int i = 0; i < length; i++) {
        glyphs[i] = codes[i];
    }
}

@end
