#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CATransform3D.h>

@implementation CABasicAnimation

-fromValue {
   return _fromValue;
}

-(void)setFromValue:value {
   value=[value retain];
   [_fromValue release];
   _fromValue=value;
}

-toValue {
   return _toValue;
}

-(void)setToValue:value {
   value=[value retain];
   [_toValue release];
   _toValue=value;
}

-byValue {
   return _byValue;
}

-(void)setByValue:value {
   value=[value retain];
   [_byValue release];
   _byValue=value;
}

-(CGFloat)_interpolateFloat:(float)scale
{
    float fromFloat = [_fromValue floatValue];
    float toFloat = [_toValue floatValue];
    
    float resultFloat = fromFloat + (toFloat-fromFloat) * scale;

    return resultFloat;
}

-(CATransform3D)_interpolateTransform3D:(float)scale
{
    CATransform3D t1=[_fromValue CATransform3DValue];
    CATransform3D t2=[_toValue CATransform3DValue];

    CATransform3D resultTransform;
    
    CGFloat det1, det2;
    
    det1 = t1.m11*t1.m22 - t1.m12*t1.m21;
    det2 = t2.m11*t2.m22 - t2.m12*t2.m21;
    
    if(det1 == 0.0 || det2 == 0.0) {
        // linear
        resultTransform.m11 = t1.m11 + (t2.m11-t1.m11) * scale;
        resultTransform.m21 = t1.m21 + (t2.m21-t1.m21) * scale;
        resultTransform.m12 = t1.m12 + (t2.m12-t1.m12) * scale;
        resultTransform.m22 = t1.m22 + (t2.m22-t1.m22) * scale;
    } else {
        // |a b|  = |cos -sin| |1  skew| |sx  0 |
        // |c d|    |sin  cos| |0  1   | |0   sy|
        // http://math.stackexchange.com/questions/78137/decomposition-of-a-nonsquare-affine-matrix
        
        CGFloat rot, rot1, rot2;
        CGFloat skew, skew1, skew2;
        CGFloat sx, sx1, sx2;
        CGFloat sy, sy1, sy2;
        
        sx1 = sqrt(t1.m11*t1.m11 + t1.m21*t1.m21);
        sx2 = sqrt(t2.m11*t2.m11 + t2.m21*t2.m21);
        
        sy1 = det1 / sx1;
        sy2 = det2 / sx2;
        
        rot1 = atan2(t1.m21, t1.m11);
        rot2 = atan2(t2.m21, t2.m11);
        
        skew1 = (t1.m11*t1.m12+t1.m21*t1.m22) / det1;
        skew2 = (t2.m11*t2.m12+t2.m21*t2.m22) / det2;
        
        sx = sx1 + (sx2-sx1) * scale;
        sy = sy1 + (sy2-sy1) * scale;
        CGFloat d = rot2 - rot1;
        if(d > M_PI) d -= M_PI*2;
        if(d < -M_PI) d += M_PI*2;
        rot = rot1 + d * scale;
        skew = skew1 + (skew2-skew1) * scale;
        
        resultTransform.m11 = sx * cos(rot);
        resultTransform.m12 = sy * (skew*cos(rot) - sin(rot));
        resultTransform.m21 = sx * sin(rot);
        resultTransform.m22 = sy * (skew*cos(rot) + cos(rot));
    }
    resultTransform.m41 = t1.m41 + (t2.m41-t1.m41) * scale;
    resultTransform.m42 = t1.m42 + (t2.m42-t1.m42) * scale;

    return resultTransform;   
}

-(CGAffineTransform)_interpolateAffineTransform:(float)scale
{
    assert(0);
}

-(CGSize)_interpolateSize:(float)scale
{
    CGSize fromRect = [_fromValue sizeValue];
    CGSize toRect = [_toValue sizeValue];

    CGSize resultRect;

    resultRect.width = fromRect.width + (toRect.width-fromRect.width) * scale;
    resultRect.height = fromRect.height + (toRect.height-fromRect.height) * scale;

    return resultRect;
}

-(CGPoint)_interpolatePoint:(float)scale
{
    CGPoint fromPoint = [_fromValue pointValue];
    CGPoint toPoint = [_toValue pointValue];

    CGPoint resultPoint;

    resultPoint.x = fromPoint.x + (toPoint.x-fromPoint.x) * scale;
    resultPoint.y = fromPoint.y + (toPoint.y-fromPoint.y) * scale;

    return resultPoint;
}

-(CGRect)_interpolateRect:(float)scale
{
    CGRect fromRect = [_fromValue rectValue];
    CGRect toRect = [_toValue rectValue];

    CGRect resultRect;

    resultRect.origin.x = fromRect.origin.x + (toRect.origin.x-fromRect.origin.x) * scale;
    resultRect.origin.y = fromRect.origin.y + (toRect.origin.y-fromRect.origin.y) * scale;
    resultRect.size.width = fromRect.size.width + (toRect.size.width-fromRect.size.width) * scale;
    resultRect.size.height = fromRect.size.height + (toRect.size.height-fromRect.size.height) * scale;

    return resultRect;
}

@end
