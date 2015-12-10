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

#import <UIKit/UIFont.h>
#import <CoreGraphics/CGFont.h>

@implementation UIFont
+ (UIFont *)systemFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"Arial" size:fontSize];
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"ArialBold" size:fontSize];
}

+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    return [[UIFont alloc] initWithName:fontName size:fontSize];
}

+ (NSArray *)familyNames
{
    assert(0);
}

+ (NSArray *)fontNamesForFamilyName:(NSString *)familyName
{
    assert(0);
}

+ (UIFont *)preferredFontForTextStyle:(NSString *)style
{
    assert(0);
}

- (id)initWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    CGFontRef cgFont = CGFontCreateWithFontName((__bridge CFStringRef)fontName);
    if(!cgFont) {
        return nil;
    }
    self = [super init];
    _cgFont = CFRetain(cgFont);
    _pointSize = fontSize;
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    BOOL systemfont = [coder decodeBoolForKey:@"UISystemFont"];
    float size = [coder decodeFloatForKey:@"UIFontPointSize"];
    assert(systemfont);
    
    return [self initWithName:@"Arial" size:size];
}

- (void)dealloc
{
    if (_cgFont) CFRelease(_cgFont);
}

- (NSString *)fontName
{
    return (NSString *)CFBridgingRelease(CGFontCopyFullName(_cgFont));
}

- (CGFloat)ascender
{
    return CGFontGetAscent(_cgFont) * _pointSize / CGFontGetUnitsPerEm(_cgFont);
}

- (CGFloat)descender
{
    return CGFontGetDescent(_cgFont) * _pointSize / CGFontGetUnitsPerEm(_cgFont);
}

- (CGFloat)pointSize
{
    return _pointSize;
}

- (CGFloat)xHeight
{
    NSLog(@"incorrect value");
    return CGFontGetXHeight(_cgFont) * _pointSize / CGFontGetUnitsPerEm(_cgFont);
}

- (CGFloat)capHeight
{
    NSLog(@"incorrect value");
    return CGFontGetCapHeight(_cgFont) * _pointSize / CGFontGetUnitsPerEm(_cgFont);
}

- (CGFloat)lineHeight
{
    // this seems to compute heights that are very close to what I'm seeing on iOS for fonts at
    // the same point sizes. however there's still subtle differences between fonts on the two
    // platforms (iOS and Mac) and I don't know if it's ever going to be possible to make things
    // return exactly the same values in all cases.
    return ceilf(self.ascender) - floorf(self.descender) + ceilf(CGFontGetLeading(_cgFont) * _pointSize / CGFontGetUnitsPerEm(_cgFont));
}

- (NSString *)familyName
{
    assert(0);
}

- (UIFont *)fontWithSize:(CGFloat)fontSize
{
    assert(0);
}

- (CGFontRef)CGFont
{
    return _cgFont;
}
@end
