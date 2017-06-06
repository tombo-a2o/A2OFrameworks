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

#import <UIKit/UIGeometry.h>
#import <Foundation/NSException.h>

const UIEdgeInsets UIEdgeInsetsZero = {0,0,0,0};
const UIOffset UIOffsetZero = {0,0};

NSString *NSStringFromCGPoint(CGPoint p)
{
    return NSStringFromPoint(NSPointFromCGPoint(p));
}

NSString *NSStringFromCGRect(CGRect r)
{
    return NSStringFromRect(NSRectFromCGRect(r));
}

NSString *NSStringFromCGSize(CGSize s)
{
    return NSStringFromSize(NSSizeFromCGSize(s));
}

NSString *NSStringFromCGAffineTransform(CGAffineTransform transform)
{
    return [NSString stringWithFormat:@"[%g, %g, %g, %g, %g, %g]", transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty];
}

NSString *NSStringFromUIEdgeInsets(UIEdgeInsets insets)
{
    return [NSString stringWithFormat:@"{%g, %g, %g, %g}", insets.top, insets.left, insets.bottom, insets.right];
}

NSString *NSStringFromUIOffset(UIOffset offset)
{
    return [NSString stringWithFormat:@"{%g, %g}", offset.horizontal, offset.vertical];
}

@implementation NSValue (NSValueUIGeometryExtensions)
+ (NSValue *)valueWithCGPoint:(CGPoint)point
{
    return [NSValue valueWithPoint:NSPointFromCGPoint(point)];
}

- (CGPoint)CGPointValue
{
    return NSPointToCGPoint([self pointValue]);
}

+ (NSValue *)valueWithCGRect:(CGRect)rect
{
    return [NSValue valueWithRect:NSRectFromCGRect(rect)];
}

- (CGRect)CGRectValue
{
    return NSRectToCGRect([self rectValue]);
}

+ (NSValue *)valueWithCGSize:(CGSize)size
{
    return [NSValue valueWithSize:NSSizeFromCGSize(size)];
}

- (CGSize)CGSizeValue
{
    return NSSizeToCGSize([self sizeValue]);
}

+ (NSValue *)valueWithUIEdgeInsets:(UIEdgeInsets)insets
{
    return [NSValue valueWithBytes: &insets objCType: @encode(UIEdgeInsets)];
}

- (UIEdgeInsets)UIEdgeInsetsValue
{
    if(strcmp([self objCType], @encode(UIEdgeInsets)) == 0)
    {
        UIEdgeInsets insets;
        [self getValue: &insets];
        return insets;
    }
    return UIEdgeInsetsZero;
}

+ (NSValue *)valueWithUIOffset:(UIOffset)offset
{
    return [NSValue valueWithBytes: &offset objCType: @encode(UIOffset)];
}

- (UIOffset)UIOffsetValue
{
    if(strcmp([self objCType], @encode(UIOffset)) == 0)
    {
        UIOffset offset;
        [self getValue: &offset];
        return offset;
    }
    return UIOffsetZero;
}
@end

@implementation NSCoder (NSCoderUIGeometryExtensions)

static double x,y,width,height;

- (CGRect)decodeCGRectForKey:(NSString *)key
{
    id obj = [self decodeObjectForKey:key];
    if(!obj) {
        return CGRectZero;
    }

    if([obj isKindOfClass:[NSString class]]) {
        return NSRectFromString(obj);
    } else {
        CGRect rect;
        NSData *data = obj;
        const char* bytes = [data bytes];
        memcpy(&x, bytes+1, sizeof(double));
        memcpy(&y, bytes+9, sizeof(double));
        memcpy(&width, bytes+17, sizeof(double));
        memcpy(&height, bytes+25, sizeof(double));
        rect.origin.x = x;
        rect.origin.y = y;
        rect.size.width = width;
        rect.size.height = height;

        return rect;
    }
}

- (CGSize)decodeCGSizeForKey:(NSString *)key
{
    id obj = [self decodeObjectForKey:key];
    if(!obj) {
        return CGSizeZero;
    }

    if([obj isKindOfClass:[NSString class]]) {
        return NSSizeFromString(obj);
    } else {
        CGSize size;
        NSData *data = obj;
        const char* bytes = [data bytes];
        memcpy(&width, bytes+1, sizeof(double));
        memcpy(&height, bytes+9, sizeof(double));
        size.width = width;
        size.height = height;

        return size;
    }
}

- (CGPoint)decodeCGPointForKey:(NSString *)key
{
    id obj = [self decodeObjectForKey:key];
    if(!obj) {
        return CGPointZero;
    }

    if([obj isKindOfClass:[NSString class]]) {
        return NSPointFromString(obj);
    } else {
        CGPoint point;
        NSData *data = obj;
        const char* bytes = [data bytes];
        memcpy(&x, bytes+1, sizeof(double));
        memcpy(&y, bytes+9, sizeof(double));
        point.x = x;
        point.y = y;

        return point;
    }
}

- (void)encodeCGPoint:(CGPoint)point forKey:(NSString *)key
{
    NSAssert(0, @"%s not implemented", __FUNCTION__);
}

- (void)encodeCGSize:(CGSize)size forKey:(NSString *)key
{
    NSAssert(0, @"%s not implemented", __FUNCTION__);
}

- (void)encodeCGRect:(CGRect)rect forKey:(NSString *)key
{
    NSAssert(0, @"%s not implemented", __FUNCTION__);
}

@end
