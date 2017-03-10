#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CALayer.h>
#import "CAAnimation+Private.h"
#import <UIKit/UIGeometry.h>

@implementation CAPropertyAnimation

-initWithKeyPath:(NSString *)keyPath {
   [super init];
   _keyPath=[keyPath copy];
   _additive=NO;
   _cumulative=NO;
   return self;
}

+animationWithKeyPath:(NSString *)keyPath {
   return [[[self alloc] initWithKeyPath:keyPath] autorelease];
}

-(NSString *)keyPath {
   return _keyPath;
}

-(void)setKeyPath:(NSString *)value {
   value=[value copy];
   [_keyPath release];
   _keyPath=value;
}

-(BOOL)isAdditive {
   return _additive;
}

-(void)setAdditive:(BOOL)value {
   _additive=value;
}

-(BOOL)isCumulative {
   return _cumulative;
}

-(void)setCumulative:(BOOL)value {
   _cumulative=value;
}

static CGFloat _interpolateFloat(float x, float y, float ratio)
{
    return x + (y - x) * ratio;
}

static CATransform3D _interpolateTransform3D(CATransform3D t1, CATransform3D t2, float ratio)
{
    CATransform3D resultTransform = CATransform3DIdentity;
    
    CGFloat det1, det2;
    
    det1 = t1.m11*t1.m22 - t1.m12*t1.m21;
    det2 = t2.m11*t2.m22 - t2.m12*t2.m21;
    
#define EPS 1e-5
    if(abs(det1) < EPS || abs(det2) < EPS) {
        // linear
        resultTransform.m11 = t1.m11 + (t2.m11-t1.m11) * ratio;
        resultTransform.m21 = t1.m21 + (t2.m21-t1.m21) * ratio;
        resultTransform.m12 = t1.m12 + (t2.m12-t1.m12) * ratio;
        resultTransform.m22 = t1.m22 + (t2.m22-t1.m22) * ratio;
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
        
        sx = sx1 + (sx2-sx1) * ratio;
        sy = sy1 + (sy2-sy1) * ratio;
        CGFloat d = rot2 - rot1;
        if(d > M_PI) d -= M_PI*2;
        if(d < -M_PI) d += M_PI*2;
        rot = rot1 + d * ratio;
        skew = skew1 + (skew2-skew1) * ratio;
        
        resultTransform.m11 = sx * cos(rot);
        resultTransform.m12 = sy * (skew*cos(rot) - sin(rot));
        resultTransform.m21 = sx * sin(rot);
        resultTransform.m22 = sy * (skew*cos(rot) + cos(rot));
    }
    resultTransform.m41 = t1.m41 + (t2.m41-t1.m41) * ratio;
    resultTransform.m42 = t1.m42 + (t2.m42-t1.m42) * ratio;

    return resultTransform;
}

static CGSize _interpolateSize(CGSize s1, CGSize s2, float ratio)
{
    CGSize resultRect;

    resultRect.width = s1.width + (s2.width-s1.width) * ratio;
    resultRect.height = s1.height + (s2.height-s1.height) * ratio;

    return resultRect;
}

static CGPoint _interpolatePoint(CGPoint p1, CGPoint p2, float ratio)
{
    CGPoint resultPoint;

    resultPoint.x = p1.x + (p2.x-p1.x) * ratio;
    resultPoint.y = p1.y + (p2.y-p1.y) * ratio;

    return resultPoint;
}

static CGRect _interpolateRect(CGRect r1, CGRect r2, float ratio)
{
    CGRect resultRect;

    resultRect.origin.x = r1.origin.x + (r2.origin.x-r1.origin.x) * ratio;
    resultRect.origin.y = r1.origin.y + (r2.origin.y-r1.origin.y) * ratio;
    resultRect.size.width = r1.size.width + (r2.size.width-r1.size.width) * ratio;
    resultRect.size.height = r1.size.height + (r2.size.height-r1.size.height) * ratio;

    return resultRect;
}

// calcluate x * (1-ratio) + y * ratio
-(NSValue*)_interpolate:(NSValue*)x with:(NSValue*)y ratio:(float)ratio type:(const char*)type {
    if(strcmp(type, @encode(CGFloat)) == 0) {
        return [NSNumber numberWithFloat:_interpolateFloat([x floatValue], [y floatValue], ratio)];
    } else if(strcmp(type, @encode(CATransform3D)) == 0) {
        return [NSValue valueWithCATransform3D:_interpolateTransform3D([x CATransform3DValue], [y CATransform3DValue], ratio)];
    } else if(strcmp(type, @encode(CGPoint)) == 0) {
        return [NSValue valueWithCGPoint:_interpolatePoint([x pointValue], [y pointValue], ratio)];
    } else if(strcmp(type, @encode(CGSize)) == 0) {
        return [NSValue valueWithCGSize:_interpolateSize([x sizeValue], [y sizeValue], ratio)];
    } else if(strcmp(type, @encode(CGRect)) == 0) {
        return [NSValue valueWithCGRect:_interpolateRect([x rectValue], [y rectValue], ratio)];
    } else {
        NSLog(@"%s unimplemented type: %s", __FUNCTION__, type);
        assert(0);
    }
}

-(void)_updateProperty:(CALayer*)layer withValue:(id)value
{
    [layer.presentationLayer setValue:value forKeyPath:_keyPath];
}

@end
