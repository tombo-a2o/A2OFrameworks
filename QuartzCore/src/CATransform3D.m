//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#import <QuartzCore/CATransform3D.h>
#include <math.h>

typedef struct _CATransform3D {
    CGFloat m[4][4];
} _CATransform3D;

const CATransform3D CATransform3DIdentity =
    {1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f};

bool CATransform3DIsIdentity(CATransform3D curTransform) {
    if (memcmp(&curTransform, &CATransform3DIdentity, sizeof(curTransform)) == 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

bool CATransform3DEqualToTransform(CATransform3D a, CATransform3D b) {
    if (memcmp(&a, &b, sizeof(CATransform3D)) == 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

CATransform3D CATransform3DMakeTranslation(float tx, float ty, float tz) {
    CATransform3D ret;
    memset(&ret, 0, sizeof(CATransform3D));

    ret.m11 = 1.0f;
    ret.m22 = 1.0f;
    ret.m33 = 1.0f;
    ret.m44 = 1.0f;
    ret.m41 = tx;
    ret.m42 = ty;
    ret.m43 = tz;
    
    return ret;
}

CATransform3D CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz) {
    CATransform3D ret;
    memset(&ret, 0, sizeof(CATransform3D));

    ret.m11 = sx;
    ret.m22 = sy;
    ret.m33 = sz;
    ret.m44 = 1.0f;
    
    return ret;
}

CATransform3D CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z) {
    CATransform3D ret;
    memset(&ret, 0, sizeof(CATransform3D));

    ret.m11 = 1.0f + (1 - cosf(angle)) * (x * x - 1);
    ret.m21 = -z * sinf(angle) + (1.0f - cosf(angle)) * x * y;
    ret.m31 = y * sinf(angle) + (1.0f - cosf(angle)) * x * z;
    ret.m12 = z * sinf(angle) + (1.0f - cosf(angle)) * x * y;
    ret.m22 = 1.0f + (1.0f - cos(angle)) * (y * y - 1.0f);
    ret.m32 = -x * sinf(angle) + (1.0f - cosf(angle)) * y * z;
    ret.m13 = -y * sinf(angle) + (1.0f - cosf(angle)) * x * z;
    ret.m23 = x * sinf(angle) + (1.0f - cos(angle)) * y * z;
    ret.m33 = 1.0f + (1.0f - cosf(angle)) * (z * z - 1.0f);
    ret.m44 = 1.0f;
    
    return ret;
}

CATransform3D CATransform3DTranslate(CATransform3D t, CGFloat tx, CGFloat ty, CGFloat tz) {
    t.m41 += tx;
    t.m42 += ty;
    t.m43 += tz;
    return t;
}

CATransform3D CATransform3DScale(CATransform3D t, CGFloat sx, CGFloat sy, CGFloat sz) {
    CATransform3D other = CATransform3DMakeScale(sx, sy, sz);
    return CATransform3DConcat(other, t);
}

CATransform3D CATransform3DRotate(CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z) {
    CATransform3D other = CATransform3DMakeRotation(angle, x, y, z);
    return CATransform3DConcat(other, t);
}

// CATransform3D CATransform3DMakeOrtho(CGFloat left, CGFloat right, CGFloat bottom, CGFloat top, CGFloat near, CGFloat far) {
//     CATransform3D ret;
//     
//     ret.m11 = 2.f / (right - left);
//     ret.m21 = 0.f;
//     ret.m31 = 0.f;
//     ret.m41 = -((right + left) / (right - left));
//     ret.m12 = 0.f;
//     ret.m22 = 2.f / (top - bottom);
//     ret.m32 = 0.f;
//     ret.m42 = -((top + bottom) / (top - bottom));
//     ret.m13 = 0.f;
//     ret.m23 = 0.f;
//     // m33 = -2.f / (far - near);
//     // m43 = -((far + near) / (far - near));
//     ret.m33 = 1.f;
//     ret.m43 = 0.f;
//     //
//     ret.m14 = 0.f;
//     ret.m24 = 0.f;
//     ret.m34 = 0.f;
//     ret.m44 = 1.f;
//     
//     return ret;
// }

CATransform3D CATransform3DConcat(CATransform3D a, CATransform3D b) {
    CATransform3D ret;
    _CATransform3D *mat0 = (_CATransform3D*)&ret;
    _CATransform3D *mat1 = (_CATransform3D*)&a;
    _CATransform3D *mat2 = (_CATransform3D*)&b;
    int i, j, k;

    for (i = 0; i < 4; i++)
        for (j = 0; j < 4; j++)
            for (k = 0, mat0->m[i][j] = 0; k < 4; k++)
                mat0->m[i][j] += mat1->m[i][k] * mat2->m[k][j];

    return ret;
}

CATransform3D CATransform3DMakeAffineTransform(CGAffineTransform m) {
    CATransform3D ret;
    memset(&ret, 0, sizeof(CATransform3D));

    ret.m11 = m.a;
    ret.m21 = m.c;
    ret.m31 = 0.0;
    ret.m41 = m.tx;
    
    ret.m12 = m.b;
    ret.m22 = m.d;
    ret.m32 = 0.0;
    ret.m42 = m.ty;
    
    ret.m13 = 0.0;
    ret.m23 = 0.0;
    ret.m33 = 1.0;
    ret.m43 = 0.0;
    
    ret.m14 = 0.0;
    ret.m24 = 0.0;
    ret.m34 = 0.0;
    ret.m44 = 1.0;
    
    return ret;
}

bool CATransform3DIsAffine(CATransform3D t) {
    return t.m13 == 0.0 && t.m23 == 0.0 && t.m31 == 0.0 && t.m32 == 0.0 && t.m33 == 1.0;
}

CGAffineTransform CATransform3DGetAffineTransform(CATransform3D t) {
    CGAffineTransform ret;
    memset(&ret, 0, sizeof(CGAffineTransform));

    ret.a = t.m11;
    ret.c = t.m21;
    ret.tx = t.m41;
    
    ret.b = t.m12;
    ret.d = t.m22;
    ret.ty = t.m42;
    
    return ret;
}

@implementation NSValue (CATransform3DAdditions)
+ (NSValue*)valueWithCATransform3D:(CATransform3D)t
{
    return [NSValue valueWithBytes:&t objCType:@encode(CATransform3D)];
}

- (CATransform3D)CATransform3DValue
{
    CATransform3D transform = CATransform3DIdentity;
    [self getValue:&transform];
    return transform;
}

@end
