#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CATransaction.h>
#import <Foundation/NSDictionary.h>

#import <Onyx2D/O2BitmapContext.h>
#import <OpenGLES/ES2/gl.h>

#import <UIKit/UIKit.h>

#import "CAAnimation+Private.h"

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
    GLuint _textureId;
    BOOL _flipTexture;
    NSMutableArray *_implicitAnimations;
    CALayer *_presentationLayer;
    CALayer *_modelLayer;
}

+layer {
    return [[[self alloc] init] autorelease];
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
   CAAnimation *animation = [self animationForKey:@"position"];

   if(animation == nil && ![CATransaction disableActions]){
       id action = [self actionForKey:@"position"];

       if(action != nil) {
           [action runActionForKey:@"position" object:self arguments:nil];
       }
   }

   _position=value;
}

-(CGRect)bounds {
    return _bounds;
}

-(void)setBounds:(CGRect)value {
   CAAnimation *animation = [self animationForKey:@"bounds"];

   if(animation == nil && ![CATransaction disableActions]){
       id action = [self actionForKey:@"bounds"];

       if(action!=nil) {
           [action runActionForKey:@"bounds" object:self arguments:nil];
       }
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
   CAAnimation *animation = [self animationForKey:@"opacity"];

   if(animation == nil && ![CATransaction disableActions]){
       id action = [self actionForKey:@"opacity"];

       if(action != nil) {
           [action runActionForKey:@"opacity" object:self arguments:nil];
       }
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
    if(_contents != value) {
        value = [value retain];
        [_contents release];
        _contents=value;
        [self _setTextureId:0];
    }
}

-(CATransform3D)transform {
    return _transform;
}

-(void)setTransform:(CATransform3D)value {
    CAAnimation *animation = [self animationForKey:@"transform"];

    if(animation == nil && ![CATransaction disableActions]){
        id action = [self actionForKey:@"transform"];

        if(action != nil) {
            [action runActionForKey:@"transform" object:self arguments:nil];
        }
    }

    _transform=value;
}

-(CATransform3D)sublayerTransform {
    return _sublayerTransform;
}

-(void)setSublayerTransform:(CATransform3D)value {
    CAAnimation *animation = [self animationForKey:@"sublayerTransform"];

    if(animation == nil && ![CATransaction disableActions]){
        id action = [self actionForKey:@"sublayerTransform"];

        if(action != nil) {
            [action runActionForKey:@"sublayerTransform" object:self arguments:nil];
        }
    }

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
    _implicitAnimations = [[NSMutableArray alloc] init];
    _needsDisplay = YES;
    _needsLayout = YES;
    _textureId = 0;
    _flipTexture = NO;
    _zPosition = 0;
    _anchorPointZ = 0.0;
    _borderColor = CGColorCreateGenericGray(0.0, 1.0);
    _contentsScale = 1.0;
    return self;
}

-(id)initWithLayer:(id)layer_
{
    self = [super init];
    CALayer *layer = layer_;
    _superlayer = nil;
    _sublayers = nil;
    _delegate = layer.delegate;
    _anchorPoint = layer.anchorPoint;
    _position = layer.position;
    _bounds = layer.bounds;
    _opacity = layer.opacity;
    _opaque = layer.opaque;
    _contents = [layer.contents retain];
    _transform = layer.transform;
    _sublayerTransform = layer.sublayerTransform;
    _minificationFilter = layer.minificationFilter;
    _magnificationFilter = layer.magnificationFilter;
    _autoresizingMask = layer.autoresizingMask;
    _cornerRadius = layer.cornerRadius;
    _layoutManager = layer.layoutManager;
    _zPosition = layer.zPosition;
    _anchorPointZ = layer.anchorPointZ;
    _masksToBounds = layer.masksToBounds;
    _hidden = layer.isHidden;
    _backgroundColor = CGColorRetain(layer.backgroundColor);
    _contentsGravity = layer.contentsGravity;
    _contentsCenter = layer.contentsCenter;
    _contentsScale = layer.contentsScale;
    _borderWidth = layer.borderWidth;
    _borderColor = CGColorRetain(layer.borderColor);
    _animations = [layer->_animations mutableCopy];
    _implicitAnimations = [layer->_implicitAnimations mutableCopy];
    _needsDisplay = YES;
    _needsLayout = YES;
    _textureId = layer->_textureId;
    _flipTexture = layer->_flipTexture;
    return self;
}

-(void)dealloc {
    if(!_modelLayer) [self _setTextureId:0]; // delete texture unless self is presentationLayer
    [_contents release];
    _presentationLayer->_modelLayer = nil;
    [_presentationLayer release];
    [_sublayers makeObjectsPerformSelector:@selector(_setSuperLayer:) withObject:nil];
    [_sublayers release];
    [_animations release];
    [_implicitAnimations release];
    [_minificationFilter release];
    [_magnificationFilter release];
    CGColorRelease(_backgroundColor);
    CGColorRelease(_borderColor);
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
        CGFloat scale = self.contentsScale;
        if(scale == 0.0) NSLog(@"scale zero %@", self);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(
                NULL,
                _bounds.size.width * scale,
                _bounds.size.height * scale,
                8,
                0,
                colorSpace,
                kO2BitmapByteOrder32Big|kO2ImageAlphaLast);
        CGColorSpaceRelease(colorSpace); // colorSpace is retained by context
        CGContextScaleCTM(context, scale, scale);
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
}

-(void)setNeedsDisplay {
    _needsDisplay=YES;
}

-(void)setNeedsDisplayInRect:(CGRect)rect {
    _needsDisplay=YES;
}

-(void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key {
    if(animation.duration == 0.0) {
        animation.duration = [CATransaction animationDuration];
    }
    if(!animation.timingFunction) {
        animation.timingFunction = [CATransaction animationTimingFunction];
    }
    void (^block)(void) = [CATransaction completionBlock];
    if(block) {
        [animation _setCompletionBlock:block];
        [CATransaction _retainCompletionBlock:block];
    }
    
    if(key) {
        [_animations setObject:animation forKey:key];
    } else {
        [_implicitAnimations addObject:animation];
    }
}

-(CAAnimation *)animationForKey:(NSString *)key {
    return [_animations objectForKey:key];
}

-(void)removeAllAnimations {
    [_animations removeAllObjects];
    [_implicitAnimations removeAllObjects];
}

-(void)removeAnimationForKey:(NSString *)key {
   [_animations removeObjectForKey:key];
}

-(NSArray *)animationKeys {
    return [_animations allKeys];
}

// -valueForKey:(NSString *)key {
//     // FIXME: KVC appears broken for structs
// 
//     if([key isEqualToString:@"bounds"])
//         return [NSValue valueWithRect:_bounds];
//     if([key isEqualToString:@"frame"])
//         return [NSValue valueWithRect:[self frame]];
//     if([key isEqualToString:@"transform"])
//         return [NSValue valueWithCATransform3D:[self transform]];
// 
//     return [super valueForKey:key];
// }

-(id <CAAction>)actionForKey:(NSString *)key {
    id action = nil;
    if([_delegate respondsToSelector:@selector(actionForLayer:forKey:)]) {
        action = [_delegate actionForLayer:self forKey:key];
    }
    if(action) return [action isEqual:[NSNull null]] ? nil : action;
    
    action = [self.actions objectForKey:key];
    if(action) return [action isEqual:[NSNull null]] ? nil : action;
    
    NSDictionary *style = self.style;
    while(style) {
        NSDictionary *actions = [style objectForKey:@"actions"];
        action = [actions objectForKey:key];
        if(action) return [action isEqual:[NSNull null]] ? nil : action;
        
        style = [style objectForKey:@"style"];
    }
    
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:key];

    [basic setFromValue:[self valueForKey:key]];

    return basic;
}

- (NSDictionary*)actions
{
    return nil;
}

+ (id<CAAction>)defaultActionForKey:(NSString *)key
{
    return nil;
}

- (NSDictionary*)style
{
    return nil;
}

-(GLuint)_textureId {
	return _textureId;
}

-(void)_setTextureId:(GLuint)value {
	if(_textureId && _modelLayer._textureId != _textureId) {
		glDeleteTextures(1, &_textureId);
	}
	_textureId = value;
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
    return CGAffineTransformTranslate(t, self.frame.origin.x-self.bounds.origin.x, self.frame.origin.y-self.bounds.origin.y);
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
    return CATransform3DGetAffineTransform(self.transform);
}

- (void)setAffineTransform:(CGAffineTransform)m {
    self.transform = CATransform3DMakeAffineTransform(m);
}

- (id)presentationLayer {
    return _presentationLayer;
}

- (id)modelLayer {
    return _modelLayer;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@: %p>", [self class], self];
}

-(BOOL)_flipTexture {
    return _flipTexture;
}

-(void)_generatePresentationLayer {
    [_presentationLayer release];
    _presentationLayer = [[[self class] alloc] initWithLayer:self];
    assert(_presentationLayer);
    _presentationLayer->_modelLayer = self;
    NSMutableArray *sublayers = [NSMutableArray array];
    for(CALayer *child in self.sublayers) {
        [child _generatePresentationLayer];
        [sublayers addObject:child.presentationLayer];
    }
    _presentationLayer.sublayers = sublayers;
}

-(void)_updateAnimations:(CFTimeInterval)currentTime {
    if(_modelLayer) return; // return self is presentationLayer
    
    for(NSString *key in self.animationKeys){
        CAAnimation *animation = [self animationForKey:key];
        
        [animation _updateLayer:self currentTime:currentTime];
        
        if([animation _isFinished] && animation.isRemovedOnCompletion){
            [self removeAnimationForKey:key];
        }
    }
    
    NSArray *implicitAnimations = [NSArray arrayWithArray:_implicitAnimations];
    for(CAAnimation *animation in implicitAnimations) {
        [animation _updateLayer:self currentTime:currentTime];
            
        if([animation _isFinished] && animation.isRemovedOnCompletion){
            [_implicitAnimations removeObject:animation];
        }
    }
    
    for(CALayer *child in _sublayers) {
        [child _updateAnimations:currentTime];
    }
}

-(NSArray*)_zOrderedSublayers {
    return [_sublayers sortedArrayUsingComparator:^(CALayer *l1, CALayer *l2) {
        CGFloat z1 = l1.zPosition;
        CGFloat z2 = l2.zPosition;
        if(z1 > z2) {
            return NSOrderedDescending;
        } else if(z1 < z2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
}
@end
