#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CALayerContext.h>
#import <QuartzCore/CATransaction.h>
#import <Foundation/NSDictionary.h>

#import <Onyx2D/O2BitmapContext.h>
#import <OpenGLES/ES2/gl.h>

#import <UIKit/UIKit.h>

NSString * const kCAFilterLinear=@"linear";
NSString * const kCAFilterNearest=@"nearest";
NSString * const kCAFilterTrilinear=@"trilinear";

NSString * const kCAGravityCenter = @"center";
NSString * const kCAGravityTop = @"top";
NSString * const kCAGravityBottom = @"bottom";
NSString * const kCAGravityLeft = @"left";
NSString * const kCAGravityRight = @"right";
NSString * const kCAGravityTopLeft = @"topleft";
NSString * const kCAGravityTopRight = @"topright";
NSString * const kCAGravityBottomLeft = @"bottomleft";
NSString * const kCAGravityBottomRight = @"bottomright";
NSString * const kCAGravityResize = @"resize";
NSString * const kCAGravityResizeAspect = @"resizeAspect";
NSString * const kCAGravityResizeAspectFill = @"resizeAspectFill";

NSString * const kCAOnOrderIn = @"onOrderIn";
NSString * const kCAOnOrderOut = @"onOrderOut";
NSString * const kCATransition = @"transition";

@implementation CALayer {
    CGImageRef _imageRef;
    GLuint _textureId;
    BOOL _flipTexture;
}

+layer {
    return [[[self alloc] init] autorelease];
}


-(CALayerContext *)_context {
    return _context;
}

-(void)_setContext:(CALayerContext *)context {
    _context=context;
    [_sublayers makeObjectsPerformSelector:@selector(_setContext:) withObject:context];
}

-(CALayer *)superlayer {
    return _superlayer;
}

-(NSArray *)sublayers {
    return _sublayers;
}

-(void)setSublayers:(NSArray *)sublayers {
    sublayers=[sublayers copy];
    [_sublayers release];
    _sublayers=sublayers;
    [_sublayers makeObjectsPerformSelector:@selector(_setSuperLayer:) withObject:self];
    [_sublayers makeObjectsPerformSelector:@selector(_setContext:) withObject:_context];
}

-(id)delegate {
    return _delegate;
}

-(void)setDelegate:value {
    _delegate=value;
}

-(CGPoint)anchorPoint {
    return _anchorPoint;
}

-(void)setAnchorPoint:(CGPoint)value {
    _anchorPoint=value;
}

-(CGPoint)position {
    return _position;
}

-(void)setPosition:(CGPoint)value {
   CAAnimation *animation=[self animationForKey:@"position"];

   if(animation==nil && ![CATransaction disableActions]){
       id action=[self actionForKey:@"position"];

       if(action!=nil)
           [self addAnimation:action forKey:@"position"];
   }

   _position=value;
}

-(CGRect)bounds {
    return _bounds;
}

-(void)setBounds:(CGRect)value {
   CAAnimation *animation=[self animationForKey:@"bounds"];

   if(animation==nil && ![CATransaction disableActions]){
       id action=[self actionForKey:@"bounds"];

       if(action!=nil)
           [self addAnimation:action forKey:@"bounds"];
   }

   if(_bounds.size.width != value.size.width || _bounds.size.height != value.size.height) {
       [self setNeedsLayout];
       [self.superlayer setNeedsLayout];
       [self setNeedsDisplay];
   }

   _bounds=value;
}

-(CGRect)frame {
    CGRect result;

    result.size=_bounds.size;
    result.origin.x=_position.x-result.size.width*_anchorPoint.x;
    result.origin.y=_position.y-result.size.height*_anchorPoint.y;

    return result;
}

-(void)setFrame:(CGRect)value {

    CGPoint position;

    position.x=value.origin.x+value.size.width*_anchorPoint.x;
    position.y=value.origin.y+value.size.height*_anchorPoint.y;

    [self setPosition:position];

    CGRect bounds=_bounds;

    bounds.size=value.size;

    [self setBounds:bounds];
}

-(float)opacity {
    return _opacity;
}

-(void)setOpacity:(float)value {
   CAAnimation *animation=[self animationForKey:@"opacity"];

   if(animation==nil && ![CATransaction disableActions]){
       id action=[self actionForKey:@"opacity"];

       if(action!=nil)
           [self addAnimation:action forKey:@"opacity"];
   }

   _opacity=value;
}

-(BOOL)opaque {
    return _opaque;
}

-(void)setOpaque:(BOOL)value {
    _opaque=value;
}

-(id)contents {
    return _contents;
}

-(void)setContents:(id)value {
    value=[value retain];
    [_contents release];
    _contents=value;
}

-(CATransform3D)transform {
    return _transform;
}

-(void)setTransform:(CATransform3D)value {
    _transform=value;
}

-(CATransform3D)sublayerTransform {
    return _sublayerTransform;
}

-(void)setSublayerTransform:(CATransform3D)value {
    _sublayerTransform=value;
}

-(NSString *)minificationFilter {
    return _minificationFilter;
}

-(void)setMinificationFilter:(NSString *)value {
    value=[value copy];
    [_minificationFilter release];
    _minificationFilter=value;
}

-(NSString *)magnificationFilter {
    return _magnificationFilter;
}

-(void)setMagnificationFilter:(NSString *)value {
    value=[value copy];
    [_magnificationFilter release];
    _magnificationFilter=value;
}

-init {
    _superlayer=nil;
    _sublayers=[NSArray new];
    _delegate=nil;
    _anchorPoint=CGPointMake(0.5,0.5);
    _position=CGPointZero;
    _bounds=CGRectZero;
    _opacity=1.0;
    _opaque=YES;
    _contents=nil;
    _transform=CATransform3DIdentity;
    _sublayerTransform=CATransform3DIdentity;
    _minificationFilter=kCAFilterLinear;
    _magnificationFilter=kCAFilterLinear;
    _animations=[[NSMutableDictionary alloc] init];
    _needsDisplay = YES;
    _needsLayout = YES;
    _textureId = 0;
    _imageRef = nil;
    _flipTexture = NO;
    return self;
}

-(void)dealloc {
    [self _setTextureId:0]; // delete texture
    [self setContents:nil]; // release contents
    [_sublayers makeObjectsPerformSelector:@selector(_setSuperLayer:) withObject:nil];
    [_sublayers release];
    [_animations release];
    [_minificationFilter release];
    [_magnificationFilter release];
    [super dealloc];
}

-(void)_setSuperLayer:(CALayer *)parent {
    _superlayer=parent;
}

-(void)_removeSublayer:(CALayer *)child {
    NSMutableArray *layers=[_sublayers mutableCopy];
    [layers removeObjectIdenticalTo:child];
    [self setSublayers:layers];
    [layers release];
}

-(void)addSublayer:(CALayer *)layer {
    NSUInteger current = [_sublayers indexOfObject:layer];
    
    if(current != [_sublayers count] - 1) {
        [self setNeedsLayout];
        [layer setNeedsLayout];

        NSMutableArray *layers=[_sublayers mutableCopy];
        if(current != NSNotFound) {
            [layers removeObjectAtIndex:current];
        }

        [self setSublayers:[layers arrayByAddingObject:layer]];
        [layers release];
    }
}

-(void)replaceSublayer:(CALayer *)layer with:(CALayer *)other {
    if(layer != other) {
        [self setNeedsLayout];
        [layer setNeedsLayout];

        NSMutableArray *layers=[_sublayers mutableCopy];
        NSUInteger      index=[_sublayers indexOfObjectIdenticalTo:layer];

        [layers replaceObjectAtIndex:index withObject:other];

        [self setSublayers:layers];
        [layers release];

        layer->_superlayer=nil;
    }
}

- (void)insertSublayer:(CALayer *)layer atIndex:(unsigned int)index {
    NSUInteger current = [_sublayers indexOfObject:layer];

    if(current != index && (current == NSNotFound || current+1 != index)) {
        [self setNeedsLayout];
        [layer setNeedsLayout];

        NSMutableArray *layers = [_sublayers mutableCopy];
        if(current != NSNotFound) {
            if(current < index) index--;
            [layers removeObjectAtIndex:current];
        }

        [layers insertObject:layer atIndex:index];
        [self setSublayers:layers];
        [layers release];
    }
}

- (void)insertSublayer:(CALayer *)layer below:(CALayer *)sublayer {
   NSUInteger      index=[_sublayers indexOfObjectIdenticalTo:layer];

   [self insertSublayer:layer atIndex:index];
}

- (void)insertSublayer:(CALayer *)layer above:(CALayer *)sublayer {
   NSUInteger      index=[_sublayers indexOfObjectIdenticalTo:layer];

   [self insertSublayer:layer atIndex:index+1];
}

-(void)display {
    if(_bounds.size.width == 0 || _bounds.size.height == 0) return;
    
    if([_delegate respondsToSelector:@selector(displayLayer:)]) {
        [_delegate displayLayer:self];
        _flipTexture = NO;
    } else {
#warning TODO reuse context
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(
                NULL,
                _bounds.size.width,
                _bounds.size.height,
                8,
                0,
                colorSpace,
                kO2BitmapByteOrder32Big|kO2ImageAlphaLast);
        CGColorSpaceRelease(colorSpace); // colorSpace is retained by context
        assert(context);
        [self drawInContext:context];
        [self setContents:context];
        _flipTexture = YES;
    }
}

-(void)displayIfNeeded {
    if(_needsDisplay) {
        [self display];
        [self _setTextureId:0];
    }
    _needsDisplay = NO;
}

-(void)drawInContext:(CGContextRef)context {
    if([_delegate respondsToSelector:@selector(drawLayer:inContext:)])
        [_delegate drawLayer:self inContext:context];
}

-(BOOL)needsDisplay {
    return _needsDisplay;
}

-(void)removeFromSuperlayer {
    [_superlayer _removeSublayer:self];
    _superlayer=nil;
    //[self _setContext:nil];
}

-(void)setNeedsDisplay {
    _needsDisplay=YES;
}

-(void)setNeedsDisplayInRect:(CGRect)rect {
    _needsDisplay=YES;
}

-(void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key {
    if(_context==nil)
        return;
    
    key = key ?: [NSNull null];

    [_animations setObject:animation forKey:key];
}

-(CAAnimation *)animationForKey:(NSString *)key {
    return [_animations objectForKey:key];
}

-(void)removeAllAnimations {
    [_animations removeAllObjects];
}

-(void)removeAnimationForKey:(NSString *)key {
   [_animations removeObjectForKey:key];
}

-(NSArray *)animationKeys {
    return [_animations allKeys];
}

-valueForKey:(NSString *)key {
    // FIXME: KVC appears broken for structs

    if([key isEqualToString:@"bounds"])
        return [NSValue valueWithRect:_bounds];
    if([key isEqualToString:@"frame"])
        return [NSValue valueWithRect:[self frame]];
    if([key isEqualToString:@"transform"])
        return [NSValue valueWithCATransform3D:[self transform]];

    return [super valueForKey:key];
}

-(id <CAAction>)actionForKey:(NSString *)key {
   CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:key];

   [basic setFromValue:[self valueForKey:key]];

   return basic;
}

-(GLuint)_textureId {
	return _textureId;
}

-(void)_setTextureId:(GLuint)value {
	//NSLog(@"%s %d -> %d", __FUNCTION__, _textureId, value);
	if(_textureId) {
		glDeleteTextures(1, &_textureId);
	}
	_textureId = value;
}

-(CGImageRef)_imageRef{
    return _imageRef;
}

-(void)_setImageRef:(CGImageRef)value {
    _imageRef = value;
}

- (BOOL)needsLayout {
    return _needsLayout;
}

- (void)setNeedsLayout {
    _needsLayout = YES;
}

// Layout logic is derived from WinObjC
- (NSArray*)_listNeededLayoutLayers {
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    if(_needsLayout) [result addObject:self];
    for(CALayer *layer in _sublayers) {
        [result addObjectsFromArray:[layer _listNeededLayoutLayers]];
    }
    return result;
}

- (void) _doLayout {
    NSArray *layouts;
    do {
        layouts = [self _listNeededLayoutLayers];
        for(CALayer *layout in layouts) {
            layout->_needsLayout = NO;
            [layout layoutSublayers];
        }
    } while([layouts count] > 0);
}

- (void)layoutIfNeeded {
    CALayer *current = self;
    while(current) {
        if(!current.superlayer || !current.superlayer.needsLayout) {
            [current _doLayout];
            return;
        }
        current = current.superlayer;
    }
}

- (void)layoutSublayers {
    if ([_delegate respondsToSelector:@selector(layoutSublayersOfLayer:)]) {
        [_delegate performSelector:@selector(layoutSublayersOfLayer:) withObject:self];
    }
}

- (CGAffineTransform)transformToWindow {
    CGAffineTransform t;
    if(self.superlayer) {
        t = [self.superlayer transformToWindow];
    } else {
        t = CGAffineTransformIdentity;
    }

#warning TODO affineTransform
    return CGAffineTransformTranslate(t, self.frame.origin.x, self.frame.origin.y);
}

- (CGPoint)convertPoint:(CGPoint)aPoint fromLayer:(CALayer *)layer {
    if(!layer) return aPoint;

    CGAffineTransform x = [self transformToWindow];
    CGAffineTransform y = [layer transformToWindow];
    CGAffineTransform z = CGAffineTransformConcat(y, CGAffineTransformInvert(x));
    return CGPointApplyAffineTransform(aPoint, z);
}

- (CGPoint)convertPoint:(CGPoint)aPoint toLayer:(CALayer *)layer {
    if(!layer) return aPoint;

    CGAffineTransform x = [self transformToWindow];
    CGAffineTransform y = [layer transformToWindow];
    CGAffineTransform z = CGAffineTransformConcat(x, CGAffineTransformInvert(y));
    return CGPointApplyAffineTransform(aPoint, z);
}

- (CGAffineTransform)affineTransform {
    return CATransform3DGetAffineTransform(_transform);
}

- (void)setAffineTransform:(CGAffineTransform)m {
    _transform = CATransform3DMakeAffineTransform(m);
}

- (id)presentationLayer {
    assert(0);
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@: %p>", [self class], self];
}

-(BOOL)_flipTexture {
    return _flipTexture;
}


@end
