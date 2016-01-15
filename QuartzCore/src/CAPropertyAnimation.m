#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CALayer.h>
#import "CAAnimation+Private.h"

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

-(void)_updateProperty:(CALayer*)layer currentTime:(CFTimeInterval)currentTime
{
    float scale = [self _calcScale:currentTime];
    NSValue *current = [layer valueForKeyPath:_keyPath];
    const char* type = current.objCType;
    NSValue *value = [self _interpolate:scale withType:type];
    [layer setValue:value forKeyPath:_keyPath];
}

-(NSValue*)_interpolate:(float)scale withType:(const char*)type
{
    if(strcmp(type, @encode(CGFloat)) == 0) {
        return [NSNumber numberWithFloat:[self _interpolateFloat:scale]];
    } else if(strcmp(type, @encode(CATransform3D)) == 0) {
        return [NSValue valueWithCATransform3D:[self _interpolateTransform3D:scale]];
    } else if(strcmp(type, @encode(CGAffineTransform)) == 0) {
        return [NSValue valueWithCGAffineTransform:[self _interpolateAffineTransform:scale]];
    } else if(strcmp(type, @encode(CGPoint)) == 0) {
        return [NSValue valueWithCGPoint:[self _interpolatePoint:scale]];
    } else if(strcmp(type, @encode(CGSize)) == 0) {
        return [NSValue valueWithCGSize:[self _interpolateSize:scale]];
    } else if(strcmp(type, @encode(CGRect)) == 0) {
        return [NSValue valueWithCGRect:[self _interpolateRect:scale]];
    } else {
        NSAssert(0, @"%s unimplemented type: %s", type);
    }
}

-(CGFloat)_interpolateFloat:(float)scale
{
    // abstract
    assert(0);
}

-(CATransform3D)_interpolateTransform3D:(float)scale
{
    // abstract
    assert(0);
}

-(CGAffineTransform)_interpolateAffineTransform:(float)scale
{
    // abstract
    assert(0);
}

-(CGPoint)_interpolatePoint:(float)scale
{
    // abstract
    assert(0);
}

-(CGSize)_interpolateSize:(float)scale
{
    // abstract
    assert(0);
}

-(CGRect)_interpolateRect:(float)scale
{
    // abstract
    assert(0);
}

@end
