/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import <Onyx2D/O2AffineTransform.h>

const O2AffineTransform O2AffineTransformIdentity={1,0,0,1,0,0};

O2AffineTransform O2AffineTransformMake(O2Float a,O2Float b,O2Float c,O2Float d,O2Float tx,O2Float ty){
   O2AffineTransform xform={a,b,c,d,tx,ty};
   return xform;
}

O2AffineTransform O2AffineTransformMakeRotation(O2Float radians){
   O2AffineTransform xform={cosf(radians),sinf(radians),-sinf(radians),cosf(radians),0,0};
   return xform;
}

O2AffineTransform O2AffineTransformMakeScale(O2Float scalex,O2Float scaley){
   O2AffineTransform xform={scalex,0,0,scaley,0,0};
   return xform;
}

O2AffineTransform O2AffineTransformMakeTranslation(O2Float tx,O2Float ty){
   O2AffineTransform xform={1,0,0,1,tx,ty};
   return xform;
}

O2AffineTransform O2AffineTransformConcat(O2AffineTransform xform,O2AffineTransform append){
   O2AffineTransform result;

   result.a=xform.a*append.a+xform.b*append.c;
   result.b=xform.a*append.b+xform.b*append.d;
   result.c=xform.c*append.a+xform.d*append.c;
   result.d=xform.c*append.b+xform.d*append.d;
   result.tx=xform.tx*append.a+xform.ty*append.c+append.tx;
   result.ty=xform.tx*append.b+xform.ty*append.d+append.ty;

   return result;
}

O2AffineTransform O2AffineTransformInvert(O2AffineTransform xform){
   O2AffineTransform result;
   O2Float determinant;

   determinant=xform.a*xform.d-xform.c*xform.b;
   if(determinant==0){
    return xform;
   }

   result.a=xform.d/determinant;
   result.b=-xform.b/determinant;
   result.c=-xform.c/determinant;
   result.d=xform.a/determinant;
   result.tx=(-xform.d*xform.tx+xform.c*xform.ty)/determinant;
   result.ty=(xform.b*xform.tx-xform.a*xform.ty)/determinant;

   return result;
}

O2AffineTransform O2AffineTransformRotate(O2AffineTransform xform,O2Float radians){
   O2AffineTransform rotate=O2AffineTransformMakeRotation(radians);
   return O2AffineTransformConcat(rotate,xform);
}

O2AffineTransform O2AffineTransformScale(O2AffineTransform xform,O2Float scalex,O2Float scaley){
   O2AffineTransform scale=O2AffineTransformMakeScale(scalex,scaley);
   return O2AffineTransformConcat(scale,xform);
}

O2AffineTransform O2AffineTransformTranslate(O2AffineTransform xform,O2Float tx,O2Float ty){
   O2AffineTransform translate=O2AffineTransformMakeTranslation(tx,ty);
   return O2AffineTransformConcat(translate,xform);
}

O2Point O2PointApplyAffineTransform(O2Point point,O2AffineTransform xform){
    O2Point p;

    p.x=xform.a*point.x+xform.c*point.y+xform.tx;
    p.y=xform.b*point.x+xform.d*point.y+xform.ty;

    return p;
}

O2Size O2SizeApplyAffineTransform(O2Size size,O2AffineTransform xform){
    O2Size s;

    s.width=xform.a*size.width+xform.c*size.height;
    s.height=xform.b*size.width+xform.d*size.height;

    return s;
}

O2Rect O2RectApplyAffineTransform(O2Rect rect, O2AffineTransform xform){
    O2Rect r;

    double x1 = (double)xform.a * rect.size.width;
    double x2 = (double)xform.c * rect.size.height;
    double y1 = (double)xform.b * rect.size.width;
    double y2 = (double)xform.d * rect.size.height;
    // left = min(0, x1, x2, x1+x2) = min(x1,0) + min(x2,0)
    // bottom = min(0, y1, y2, y1+y2) = min(y1,0) + min(y2,0)

#define _min(x,y) (x>y ? y : x)
#define _min4(x1,x2) (_min(x1,0)+_min(x2,0))
#define _abs(x) (x>=0 ? x : -x)

    r.origin.x = (CGFloat)((double)xform.a * rect.origin.x + (double)xform.c * rect.origin.y + xform.tx + _min4(x1,x2));
    r.origin.y = (CGFloat)((double)xform.b * rect.origin.x + (double)xform.d * rect.origin.y + xform.ty + _min4(y1,y2));
    r.size.width = (CGFloat)(_abs(x1) + _abs(x2));
    r.size.height = (CGFloat)(_abs(y1) + _abs(y2));

#undef _min
#undef _min4
#undef _abs

    return r;
}
