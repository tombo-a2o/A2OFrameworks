#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CALayerContext.h>
#import <QuartzCore/CATransaction.h>
#import <Foundation/NSDictionary.h>

#import <Onyx2D/O2BitmapContext.h>

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

@implementation CALayer

+layer {
    return [[[self alloc] init] autorelease];
}


-(CALayerContext *)_context {
    return _context;
}

-(void)_setContext:(CALayerContext *)context {
    if(_context!=context){
        [_context deleteTextureId:_textureId];
        [_textureId release];
        _textureId=nil;
    }

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
    return self;
}

-(void)dealloc {
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
    [self setNeedsLayout];
    [layer setNeedsLayout];

    [self setSublayers:[_sublayers arrayByAddingObject:layer]];
}

-(void)replaceSublayer:(CALayer *)layer with:(CALayer *)other {
    [self setNeedsLayout];
    [layer setNeedsLayout];

    NSMutableArray *layers=[_sublayers mutableCopy];
    NSUInteger      index=[_sublayers indexOfObjectIdenticalTo:layer];

    [layers replaceObjectAtIndex:index withObject:other];

    [self setSublayers:layers];
    [layers release];

    layer->_superlayer=nil;
}

- (void)insertSublayer:(CALayer *)aLayer atIndex:(unsigned int)index {
    [self setNeedsLayout];
    [aLayer setNeedsLayout];

    NSMutableArray *layers=[_sublayers mutableCopy];

    [layers insertObject:aLayer atIndex:index];
    [self setSublayers:layers];
    [layers release];
}

- (void)insertSublayer:(CALayer *)aLayer below:(CALayer *)sublayer {
   NSUInteger      index=[_sublayers indexOfObjectIdenticalTo:aLayer];

   [self insertSublayer:aLayer atIndex:index];
}

- (void)insertSublayer:(CALayer *)aLayer above:(CALayer *)sublayer {
   NSUInteger      index=[_sublayers indexOfObjectIdenticalTo:aLayer];

   [self insertSublayer:aLayer atIndex:index+1];
}

-(void)display {
    if([_delegate respondsToSelector:@selector(displayLayer:)]) {
        [_delegate displayLayer:self];
    } else {
        CGContextRef context = CGBitmapContextCreate(
                NULL,
                _bounds.size.width,
                _bounds.size.height,
                8,
                0,
                CGColorSpaceCreateDeviceRGB(),
                kO2BitmapByteOrder32Big|kO2ImageAlphaLast);
        assert(context);
        [self drawInContext:context];
        [self setContents:context];
    }
}

-(void)displayIfNeeded {
    if(_needsDisplay) {
        [self display];
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
    [self _setContext:nil];
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

    [_animations setObject:animation forKey:key];
    [_context startTimerIfNeeded];
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

    return [super valueForKey:key];
}

-(id <CAAction>)actionForKey:(NSString *)key {
   CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:key];

   [basic setFromValue:[self valueForKey:key]];

   return basic;
}

-(NSNumber *)_textureId {
    return _textureId;
}

-(void)_setTextureId:(NSNumber *)value {
    value=[value copy];
    [_textureId release];
    _textureId=value;
}

- (BOOL)needsLayout {
    return _needsLayout;
}

- (void)setNeedsLayout {
    _needsLayout = YES;
}

// Layout logic is derived from WinObjC
- (NSArray*)_listNeededLayoutLayers {
    NSMutableArray *result = [[NSMutableArray alloc] init];
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

- (CGPoint)convertPoint:(CGPoint)aPoint fromLayer:(CALayer *)layer {
    assert(0);
}

- (CGPoint)convertPoint:(CGPoint)aPoint toLayer:(CALayer *)layer {
    assert(0);
}

- (CGAffineTransform)affineTransform {
    NSLog(@"%s is not implemented. Ignored.", __FUNCTION__);
}

- (void)setAffineTransform:(CGAffineTransform)m {
    NSLog(@"%s is not implemented. Ignored.", __FUNCTION__);
}

- (id)presentationLayer {
    assert(0);
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@: %p>", [self class], self];
}
@end
