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

#import "UIColor+UIPrivate.h"
#import "UIColorRep.h"
#import "UIImage+UIPrivate.h"
#import <UIKit/UIGraphics.h>

static UIColor *BlackColor = nil;
static UIColor *DarkGrayColor = nil;
static UIColor *LightGrayColor = nil;
static UIColor *WhiteColor = nil;
static UIColor *GrayColor = nil;
static UIColor *RedColor = nil;
static UIColor *GreenColor = nil;
static UIColor *BlueColor = nil;
static UIColor *CyanColor = nil;
static UIColor *YellowColor = nil;
static UIColor *MagentaColor = nil;
static UIColor *OrangeColor = nil;
static UIColor *PurpleColor = nil;
static UIColor *BrownColor = nil;
static UIColor *ClearColor = nil;
static UIColor *LightTextColor = nil;

@implementation UIColor {
    NSArray *_representations;
}

+ (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha
{
    return [[self alloc] initWithWhite:white alpha:alpha];
}

+ (UIColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha
{
    return [[self alloc] initWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [[self alloc] initWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithCGColor:(CGColorRef)ref
{
    return [[self alloc] initWithCGColor:ref];
}

+ (UIColor *)colorWithPatternImage:(UIImage *)patternImage
{
    return [[self alloc] initWithPatternImage:patternImage];
}

+ (UIColor *)blackColor			{ return BlackColor ?: (BlackColor = [self colorWithWhite:0.0 alpha:1.0]); }
+ (UIColor *)darkGrayColor		{ return DarkGrayColor ?: (DarkGrayColor = [self colorWithWhite:1.0/3.0 alpha:1.0]); }
+ (UIColor *)lightGrayColor		{ return LightGrayColor ?: (LightGrayColor = [self colorWithWhite:2.0/3.0 alpha:1.0]); }
+ (UIColor *)whiteColor			{ return WhiteColor ?: (WhiteColor = [self colorWithWhite:1.0 alpha:1.0]); }
+ (UIColor *)grayColor			{ return GrayColor ?: (GrayColor = [self colorWithWhite:0.5 alpha:1.0]); }
+ (UIColor *)redColor			{ return RedColor ?: (RedColor = [self colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]); }
+ (UIColor *)greenColor			{ return GreenColor ?: (GreenColor = [self colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]); }
+ (UIColor *)blueColor			{ return BlueColor ?: (BlueColor = [self colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]); }
+ (UIColor *)cyanColor			{ return CyanColor ?: (CyanColor = [self colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0]); }
+ (UIColor *)yellowColor		{ return YellowColor ?: (YellowColor = [self colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0]); }
+ (UIColor *)magentaColor		{ return MagentaColor ?: (MagentaColor = [self colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0]); }
+ (UIColor *)orangeColor		{ return OrangeColor ?: (OrangeColor = [self colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]); }
+ (UIColor *)purpleColor		{ return PurpleColor ?: (PurpleColor = [self colorWithRed:0.5 green:0.0 blue:0.5 alpha:1.0]); }
+ (UIColor *)brownColor			{ return BrownColor ?: (BrownColor = [self colorWithRed:0.6 green:0.4 blue:0.2 alpha:1.0]); }
+ (UIColor *)clearColor			{ return ClearColor ?: (ClearColor = [self colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]); }
+ (UIColor *)lightTextColor		{ return LightTextColor ?: (LightTextColor = [self colorWithWhite:1 alpha:0.6]); }
+ (UIColor *)darkTextColor      { return [self blackColor]; }

- (id)initWithWhite:(CGFloat)white alpha:(CGFloat)alpha
{
    return [self initWithCGColor:CGColorCreateGenericGray(white,alpha)];
}

- (id)initWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha
{
#if 1
    assert(0);
#else
    float red,green,blue;
    NSColorHSBToRGB(hue,saturation,brightness,&red,&green,&blue);
    return [self initWithCGColor:CGColorCreateGenericRGB(red,green,blue,alpha)];
#endif
}

- (id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [self initWithCGColor:CGColorCreateGenericRGB(red,green,blue,alpha)];
}

- (id)_initWithRepresentations:(NSArray *)reps
{
    if ([reps count] == 0) {
        self = nil;
    } else if ((self=[super init])) {
        _representations = [reps copy];
    }
    return self;
}

- (id)initWithCGColor:(CGColorRef)ref
{
    return [self _initWithRepresentations:[NSArray arrayWithObjects:[[UIColorRep alloc] initWithCGColor:ref], nil]];
}

- (id)initWithPatternImage:(UIImage *)patternImage
{
    NSArray *imageReps = [patternImage _representations];
    NSMutableArray *colorReps = [NSMutableArray arrayWithCapacity:[imageReps count]];

    for (UIImageRep *imageRep in imageReps) {
        [colorReps addObject:[[UIColorRep alloc] initWithPatternImageRepresentation:imageRep]];
    }

    return [self _initWithRepresentations:colorReps];
}

- (id)initWithCoder:(NSCoder*)coder
{
    float red = [coder decodeFloatForKey:@"UIRed"];
    float green  = [coder decodeFloatForKey:@"UIGreen"];
    float blue = [coder decodeFloatForKey:@"UIBlue"];
    float alpha = [coder decodeFloatForKey:@"UIAlpha"];
    return [self initWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColorRep *)_bestRepresentationForProposedScale:(CGFloat)scale
{
    UIColorRep *bestRep = nil;

    for (UIColorRep *rep in _representations) {
        if (rep.scale > scale) {
            break;
        } else {
            bestRep = rep;
        }
    }

    return bestRep ?: [_representations lastObject];
}

- (BOOL)_isOpaque
{
    for (UIColorRep *rep in _representations) {
        if (!rep.opaque) {
            return NO;
        }
    }

    return YES;
}

- (void)set
{
    [self setFill];
    [self setStroke];
}

- (void)setFill
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [self _bestRepresentationForProposedScale:_UIGraphicsGetContextScaleFactor(ctx)].CGColor);
}

- (void)setStroke
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [self _bestRepresentationForProposedScale:_UIGraphicsGetContextScaleFactor(ctx)].CGColor);
}

- (CGColorRef)CGColor
{
    return [self _bestRepresentationForProposedScale:1].CGColor;
}

- (UIColor *)colorWithAlphaComponent:(CGFloat)alpha
{
    CGColorRef newColor = CGColorCreateCopyWithAlpha(self.CGColor, alpha);
    UIColor *resultingUIColor = [UIColor colorWithCGColor:newColor];
    CGColorRelease(newColor);
    return resultingUIColor;
}

- (NSString *)description
{
    // The color space string this gets isn't exactly the same as Apple's implementation.
    // For instance, Apple's implementation returns UIDeviceRGBColorSpace for [UIColor redColor]
    // This implementation returns kCGColorSpaceDeviceRGB instead.
    // Apple doesn't actually define UIDeviceRGBColorSpace or any of the other responses anywhere public,
    // so there isn't any easy way to emulate it.
    CGColorSpaceRef colorSpaceRef = CGColorGetColorSpace(self.CGColor);
    NSString *colorSpace = [NSString stringWithFormat:@"%@", (NSString *)CFBridgingRelease(CGColorSpaceCopyName(colorSpaceRef))];

    const size_t numberOfComponents = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    NSMutableString *componentsString = [NSMutableString stringWithString:@"{"];

    for (NSInteger index = 0; index < numberOfComponents; index++) {
        if (index) [componentsString appendString:@", "];
        [componentsString appendFormat:@"%.0f", components[index]];
    }
    [componentsString appendString:@"}"];

    return [NSString stringWithFormat:@"<%@: %p; colorSpace = %@; components = %@>", NSStringFromClass([self class]), self, colorSpace, componentsString];
}

- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    UIColor* color = (UIColor*) object;
    return CGColorEqualToColor(self.CGColor, color.CGColor);
}

@end
