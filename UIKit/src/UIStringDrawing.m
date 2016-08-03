/*
 * Copyright (c) 2011, The Iconfactory. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of The Iconfactory nor the names of its contributors may
 *    be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE ICONFACTORY BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <UIKit/UIStringDrawing.h>
#import <UIKit/UIFont.h>
#import <UIKit/UIGraphics.h>
#import "UIFont+UIPrivate.h"
#import <UIKit/NSParagraphStyle.h>

NSString *const UITextAttributeFont = @"UITextAttributeFont";
NSString *const UITextAttributeTextColor = @"UITextAttributeTextColor";
NSString *const UITextAttributeTextShadowColor = @"UITextAttributeTextShadowColor";
NSString *const UITextAttributeTextShadowOffset = @"UITextAttributeTextShadowOffset";

static NSArray* CreateCTLinesForString(NSString *string, CGSize constrainedToSize, UIFont *font, NSLineBreakMode lineBreakMode, CGSize *renderSize)
{
    NSMutableArray* lines = [NSMutableArray array];
    CGSize drawSize = CGSizeZero;

    if (font) {
        CGFontRef cgFont = [font CGFont];

        const CFIndex stringLength = [string length];
        unichar *text = malloc(stringLength * sizeof(unichar));
        [string getCharacters:text range:NSMakeRange(0, stringLength)];
        const CGFloat lineHeight = font.lineHeight;

        CFIndex start = 0;
        BOOL isLastLine = NO;

        while (start < stringLength && !isLastLine) {
            drawSize.height += lineHeight;
            isLastLine = (drawSize.height + lineHeight > constrainedToSize.height);

            CFIndex usedCharacters = 0;
            NSString *line = nil;

            if (isLastLine && (lineBreakMode != NSLineBreakByWordWrapping && lineBreakMode != NSLineBreakByCharWrapping)) {
                if (lineBreakMode == NSLineBreakByClipping) {
                    usedCharacters = CGFontSuggestLineBreak(cgFont, text, stringLength, font.pointSize, start, constrainedToSize.width);
                    line = [string substringWithRange:NSMakeRange(start, usedCharacters)];
                } else {
                    // CTLineTruncationType truncType;
                    // 
                    // if (lineBreakMode == NSLineBreakByHeadTruncation) {
                    //     truncType = kCTLineTruncationStart;
                    // } else if (lineBreakMode == NSLineBreakByTailTruncation) {
                    //     truncType = kCTLineTruncationEnd;
                    // } else {
                    //     truncType = kCTLineTruncationMiddle;
                    // }
                    // 
                    usedCharacters = stringLength - start;
                    line = [string substringWithRange:NSMakeRange(start, usedCharacters)];
                    // CFAttributedStringRef ellipsisString = CFAttributedStringCreate(NULL, CFSTR("…"), attributes);
                    // CTLineRef ellipsisLine = CTLineCreateWithAttributedString(ellipsisString);
                    // CTLineRef tempLine = CTTypesetterCreateLine(typesetter, CFRangeMake(start, usedCharacters));
                    // line = CTLineCreateTruncatedLine(tempLine, constrainedToSize.width, truncType, ellipsisLine);
                    // CFRelease(tempLine);
                    // CFRelease(ellipsisLine);
                    // CFRelease(ellipsisString);
                }
            } else {
                // if (lineBreakMode == NSLineBreakByCharWrapping) {
                //     usedCharacters = CTTypesetterSuggestClusterBreak(typesetter, start, constrainedToSize.width);
                // } else {
                //     usedCharacters = CTTypesetterSuggestLineBreak(typesetter, start, constrainedToSize.width);
                // }
                // line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, usedCharacters));
                usedCharacters = CGFontSuggestLineBreak(cgFont, text, stringLength, font.pointSize, start, constrainedToSize.width);
                
                // TODO re-implement with ICU
                NSString *prohibitsAtBegin = @"、。）」ぁぃぅぇぉっゃゅょァィゥェォッャュョ";
                NSString *prohibitsAtLast = @"（「";
                
                NSString *lastChar = [string substringWithRange:NSMakeRange(start+usedCharacters-1, 1)];
                NSString *nextChar = start + usedCharacters < stringLength ? [string substringWithRange:NSMakeRange(start+usedCharacters, 1)] : nil;
                if([prohibitsAtLast rangeOfString:lastChar options:0].location != NSNotFound || (nextChar && [prohibitsAtBegin rangeOfString:nextChar options:0].location != NSNotFound)) {
                    usedCharacters--;
                }
                
                line = [string substringWithRange:NSMakeRange(start, usedCharacters)];
            }

            if (usedCharacters) {
                // drawSize.width = MAX(drawSize.width, ceilf(CTLineGetTypographicBounds(line,NULL,NULL,NULL)));
                drawSize.width = MAX(drawSize.width, ceilf(CGFontGetTextWidth(cgFont, text + start, usedCharacters, font.pointSize)));
                
                [lines addObject:line];
            }

            start += usedCharacters;
        }
        free(text);
    }

    if (renderSize) {
        *renderSize = drawSize;
    }

    return lines;
}

@implementation NSString (UIStringDrawing)

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX,font.lineHeight)];
}

- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(width,font.lineHeight) lineBreakMode:lineBreakMode];
}

- (CGSize)sizeWithFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return CGSizeZero;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize resultingSize = CGSizeZero;
    CreateCTLinesForString(self, size, font, lineBreakMode, &resultingSize);
    return resultingSize;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)drawAtPoint:(CGPoint)point withFont:(UIFont *)font
{
    return [self drawAtPoint:point forWidth:CGFLOAT_MAX withFont:font lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    return CGSizeZero;
}

- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    UIFont *adjustedFont = ([font pointSize] != fontSize)? [font fontWithSize:fontSize] : font;
    return [self drawInRect:CGRectMake(point.x,point.y,width,adjustedFont.lineHeight) withFont:adjustedFont lineBreakMode:lineBreakMode];
}

- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self drawAtPoint:point forWidth:width withFont:font fontSize:[font pointSize] lineBreakMode:lineBreakMode baselineAdjustment:UIBaselineAdjustmentNone];
}

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment
{
    CGSize actualSize = CGSizeZero;
    CGSize s = rect.size;
    NSArray* lines = CreateCTLinesForString(self, rect.size, font, lineBreakMode, &actualSize);

    if (lines) {
        const CGFloat fontLineHeight = font.lineHeight;
        CGFloat textOffset = 0;

        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y + font.ascender);
        CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1,-1));
        CGContextSetFont(ctx, [font CGFont]);
        CGContextSetFontSize(ctx, [font pointSize]);

        for(NSString *line in lines) {
            float flush;
            switch (alignment) {
                case UITextAlignmentCenter:	flush = 0.5;	break;
                case UITextAlignmentRight:	flush = 1;		break;
                case UITextAlignmentLeft:
                default:					flush = 0;		break;
            }
            size_t len = [line length];
            unichar *text = malloc(len * sizeof(unichar));
            [line getCharacters:text range:NSMakeRange(0, len)];
            
            CGFloat textWidth = CGFontGetTextWidth([font CGFont], text, len, font.pointSize);
            CGFloat penOffset = flush * (rect.size.width - textWidth);
            
            CGContextShowUnicodeTextAtPoint(ctx, penOffset, textOffset, text, len);
            
            free(text);
            
            textOffset += fontLineHeight;
        }
        CGContextRestoreGState(ctx);
    }

    // the real UIKit appears to do this.. so shall we.
    actualSize.height = MIN(actualSize.height, rect.size.height);
    return actualSize;
}

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font
{
    return [self drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:UITextAlignmentLeft];
}

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:UITextAlignmentLeft];
}

@end
