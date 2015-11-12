#import "O2Context_builtin_FT.h"
#import <Onyx2D/O2GraphicsState.h>
#import "O2Font_FT.h"
#import "O2Font_canvas.h"
#import <Onyx2D/O2Paint_color.h>

@implementation O2Context_builtin_FT

+(BOOL)canInitBackingWithContext:(O2Context *)context deviceDictionary:(NSDictionary *)deviceDictionary {
    return YES;
}

-initWithSurface:(O2Surface *)surface flipped:(BOOL)flipped {
   if([super initWithSurface:surface flipped:flipped]==nil)
       return nil;

   return self;
}

-(void)dealloc {

    [super dealloc];
}

-(void)establishFontStateInDeviceIfDirty {
    O2GState *gState=O2ContextCurrentGState(self);

    if(gState->_fontIsDirty){
        O2GStateClearFontIsDirty(gState);
    }
}

static O2Paint *paintFromColor(O2ColorRef color) {
    size_t count = O2ColorGetNumberOfComponents(color);
    const float *components = O2ColorGetComponents(color);

    if(count==2)
        return [[O2Paint_color alloc] initWithGray:components[0] alpha:components[1] surfaceToPaintTransform:O2AffineTransformIdentity];
    if(count==4)
        return [[O2Paint_color alloc] initWithRed:components[0] green:components[1] blue:components[2] alpha:components[3] surfaceToPaintTransform:O2AffineTransformIdentity];

    return [[O2Paint_color alloc] initWithGray:0 alpha:1 surfaceToPaintTransform:O2AffineTransformIdentity];
}

static void applyCoverageToSpan_lRGBA8888_PRE(O2argb8u *dst,unsigned char *coverageSpan,O2argb8u *src,int length){
    int i;

    for(i=0;i<length;i++,src++,dst++){
        int coverage=coverageSpan[i];
        int oneMinusCoverage=inverseCoverage(coverage);
        O2argb8u r=*src;
        O2argb8u d=*dst;

        *dst=O2argb8uAdd(O2argb8uMultiplyByCoverage(r , coverage) , O2argb8uMultiplyByCoverage(d , oneMinusCoverage));
    }
}

#define DEBUG_drawFreeTypeBitmap 0
#if DEBUG_drawFreeTypeBitmap
#define PRINTBUFFER(buffer, length, color) do{for(int i=0;i<length;i++) printf("%x", buffer[i].color>>4);puts("");}while(0)
#else
#define PRINTBUFFER(buffer, length, color)
#endif

static void drawFreeTypeBitmap(O2Context_builtin_FT *self, O2Surface *surface, uint8_t *coverage, int bitmapWidth, int bitmapHeight, int left, int top, O2Paint *paint) {
    // FIXME: clipping
    int surfaceWidth = O2ImageGetWidth(surface);
    int surfaceHeight = O2ImageGetHeight(surface);
    O2argb8u      *dstBuffer = __builtin_alloca(bitmapWidth*sizeof(O2argb8u));
    O2argb8u      *srcBuffer = __builtin_alloca(bitmapWidth*sizeof(O2argb8u));

#if DEBUG_drawFreeTypeBitmap
    for(int j = 0; j < bitmapHeight; j++) {
    for(int i = 0; i < bitmapWidth; i++) {
        printf("%x", coverage[i + j*bitmapWidth]>>4);
    }
    puts("");
    }
    puts("");
#endif

    //NSLog(@"bitmap=(%d,%d), left,top=(%d, %d) surface=(%d,%d)", bitmapWidth, bitmapHeight, left, top, surfaceWidth, surfaceHeight);
    for(int row = MAX(0, -top), y = MAX(0, top); row < bitmapHeight && y < surfaceHeight; row++, y++) {
        int x = left;
        int length = MIN(bitmapWidth, surfaceWidth - left);
        if(length < 0) break;

        O2argb8u *dst = dstBuffer;
        O2argb8u *src = srcBuffer;

        // read surface and copy it to dst
        O2argb8u *direct = surface->_read_argb8u(surface, x, y, dst, length);

        PRINTBUFFER(dstBuffer, bitmapWidth, a);

        if(direct != NULL)
            dst = direct;

        while(YES){
            // read paint pattern to src (filled with constant value if paint is color)
            // if paint is color, chunk = length
            // if paint is image, chunk = pattern length ?
            int chunk = O2PaintReadSpan_argb8u_PRE(paint, x, y, src, length);
            PRINTBUFFER(srcBuffer, bitmapWidth, a);

            if(chunk < 0) {
                chunk = -chunk;
            } else {
                // blend dst(original image) into src(paint). If copy, do nothing (src left unchanged)
                self->_blend_argb8u_PRE(src, dst, chunk);

                PRINTBUFFER(srcBuffer, bitmapWidth, a);

                // dst = src(paint) * c + dst * (1-c)
                applyCoverageToSpan_lRGBA8888_PRE(dst, coverage, src, chunk);

                PRINTBUFFER(dstBuffer, bitmapWidth, a);

                if(direct==NULL) {
                    // write back dst to surface
                    O2SurfaceWriteSpan_argb8u_PRE(surface, x, y, dst, chunk);
                }
            }
            coverage += chunk;

            length -= chunk;
            x += chunk;
            src += chunk;
            dst += chunk;

            if(length == 0)
                break;

        }
    }

}

-(void)showGlyphs:(const O2Glyph *)glyphs advances:(const O2Size *)advances count:(unsigned)count {
    O2GState *gState = O2ContextCurrentGState(self);

    if([gState->_font isKindOfClass:[O2Font_canvas class]]) {
        [self showGlyphs_canvas:glyphs advances:advances count:count];
    } else if([gState->_font isKindOfClass:[O2Font_FT class]]) {
        [self showGlyphs_FT:glyphs advances:advances count:count];
    }
}

-(void)showGlyphs_canvas:(const O2Glyph *)glyphs advances:(const O2Size *)advances count:(unsigned)count {
    O2AffineTransform transform = O2ContextGetUserSpaceToDeviceSpaceTransform(self);
    O2GState *gState = O2ContextCurrentGState(self);
    O2Paint *paint = paintFromColor(gState->_fillColor);
    O2Point point = O2PointApplyAffineTransform(NSMakePoint(_textMatrix.tx, _textMatrix.ty), transform);
    O2Font_canvas *font = (O2Font_canvas*)gState->_font;

    NSString *text = [NSString stringWithCharacters:glyphs length:count];
    int width, height, left, top;
    NSString *fontName = (NSString*)O2FontCopyFullName(font);
    uint8_t *bitmap = a2o_renderFontToBitmapBuffer([fontName UTF8String], gState->_pointSize, [text UTF8String], transform.a, transform.b, transform.c, transform.d, &width, &height, &left, &top);

    drawFreeTypeBitmap(self, _surface, bitmap, width, height, point.x + left, point.y - top, paint);

    free(bitmap);
}

-(void)showGlyphs_FT:(const O2Glyph *)glyphs advances:(const O2Size *)advances count:(unsigned)count {
    // FIXME: use advances if not NULL

    O2AffineTransform transform = O2ContextGetUserSpaceToDeviceSpaceTransform(self);
    O2GState *gState = O2ContextCurrentGState(self);
    O2Paint *paint = paintFromColor(gState->_fillColor);
    O2Point point = O2PointApplyAffineTransform(NSMakePoint(_textMatrix.tx, _textMatrix.ty), transform);

    [self establishFontStateInDeviceIfDirty];

    O2Font_FT *font = (O2Font_FT *)gState->_font;
    FT_Face face = [font face];

    int i;
    FT_Error ftError;

    if(face == NULL) {
        NSLog(@"face is NULL");
        return;
    }

    FT_GlyphSlot slot = face->glyph;

#warning TODO use device specific value?
    if ((ftError = FT_Set_Char_Size(face, 0, gState->_pointSize * 64, 72.0, 72.0))) {
        NSLog(@"FT_Set_Char_Size returned %d", ftError);
        return;
    }

    FT_Matrix matrix = {transform.a * 65536, transform.c * 65536, transform.b * 65536, transform.d * 65536};
    FT_Set_Transform(face, &matrix, NULL);

    for(i = 0; i < count; i++) {
        ftError = FT_Load_Glyph(face, glyphs[i], FT_LOAD_DEFAULT);
        if(ftError)
            continue;

        ftError = FT_Render_Glyph(face->glyph, FT_RENDER_MODE_NORMAL);
        if(ftError)
            continue;

        drawFreeTypeBitmap(self, _surface, slot->bitmap.buffer, slot->bitmap.width, slot->bitmap.rows,
            point.x + slot->bitmap_left, point.y - slot->bitmap_top, paint);

        point.x += slot->advance.x >> 6;
    }
    FT_Set_Transform(face, NULL, NULL);

    O2PaintRelease(paint);

/*
    int glyphAdvances[count];
    O2Float unitsPerEm = O2FontGetUnitsPerEm(font);

    O2FontGetGlyphAdvances(font, glyphs, count, glyphAdvances);

    O2Float total=0;

    for(i = 0; i < count; i++)
        total += glyphAdvances[i];

    total = (total/unitsPerEm) * gState->_pointSize;

    self->_textMatrix.tx += total;
    self->_textMatrix.ty += 0;
*/
}

@end
