
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CATransform3D.h>
#import <QuartzCore/CAAction.h>
#import <QuartzCore/CAMediaTiming.h>

@class CAAnimation;

typedef enum {
    kCALayerNotSizable = 0x00,
    kCALayerMinXMargin = 0x01,
    kCALayerWidthSizable = 0x02,
    kCALayerMaxXMargin = 0x04,
    kCALayerMinYMargin = 0x08,
    kCALayerHeightSizable = 0x10,
    kCALayerMaxYMargin = 0x20,
} CAAutoresizingMask;

CA_EXPORT NSString *const kCAFilterLinear;
CA_EXPORT NSString *const kCAFilterNearest;
CA_EXPORT NSString *const kCAFilterTrilinear;

CA_EXPORT NSString * const kCAGravityCenter;
CA_EXPORT NSString * const kCAGravityTop;
CA_EXPORT NSString * const kCAGravityBottom;
CA_EXPORT NSString * const kCAGravityLeft;
CA_EXPORT NSString * const kCAGravityRight;
CA_EXPORT NSString * const kCAGravityTopLeft;
CA_EXPORT NSString * const kCAGravityTopRight;
CA_EXPORT NSString * const kCAGravityBottomLeft;
CA_EXPORT NSString * const kCAGravityBottomRight;
CA_EXPORT NSString * const kCAGravityResize;
CA_EXPORT NSString * const kCAGravityResizeAspect;
CA_EXPORT NSString * const kCAGravityResizeAspectFill;

CA_EXPORT NSString * const kCAOnOrderIn;
CA_EXPORT NSString * const kCAOnOrderOut;
CA_EXPORT NSString * const kCATransition;

@interface CALayer : NSObject<NSCoding, CAMediaTiming> {
    CALayer *_superlayer;
    NSArray *_sublayers;
    id _delegate;
    CGPoint _anchorPoint;
    CGPoint _position;
    CGRect _bounds;
    float _opacity;
    BOOL _opaque;
    id _contents;
    CATransform3D _transform;
    CATransform3D _sublayerTransform;
    NSString *_minificationFilter;
    NSString *_magnificationFilter;
    CGFloat _cornerRadius;
    CGFloat _zPosition;
    CGFloat _anchorPointZ;
    BOOL _masksToBounds;
    BOOL _hidden;
    CGColorRef _backgroundColor;
    CGRect _contentsCenter;
    CGFloat _contentsScale;
    CGFloat _borderWidth;
    CGColorRef _borderColor;
    BOOL _doubleSided;
    BOOL _needsDisplay;
    NSMutableDictionary *_animations;
    BOOL _needsLayout;
}

+ layer;
+ (id<CAAction>)defaultActionForKey:(NSString *)key;

@property(readonly) CALayer *superlayer;
@property(copy) NSArray *sublayers;
@property(assign) id delegate;
@property CGPoint anchorPoint;
@property CGPoint position;
@property CGRect bounds;
@property CGRect frame;
@property float opacity;
@property BOOL opaque;
@property(retain) id contents;
@property CATransform3D transform;
@property CATransform3D sublayerTransform;

@property(copy) NSString *minificationFilter;
@property(copy) NSString *magnificationFilter;

@property CAAutoresizingMask autoresizingMask;
@property CGFloat cornerRadius;
@property(strong) id layoutManager;
@property CGFloat zPosition;
@property CGFloat anchorPointZ;
@property BOOL masksToBounds;
@property(getter=isHidden) BOOL hidden;
@property CGColorRef backgroundColor;
@property BOOL needsDisplayOnBoundsChange;
@property(copy) NSString *contentsGravity;
@property CGRect contentsCenter;
@property CGFloat contentsScale;
@property CGFloat borderWidth;
@property CGColorRef borderColor;
@property(copy) NSDictionary *actions;
@property(copy) NSDictionary *style;
@property(getter=isDoubleSided) BOOL doubleSided;

- (instancetype)init;
- (instancetype)initWithLayer:(id)layer;

- (void)addSublayer:(CALayer *)layer;
- (void)replaceSublayer:(CALayer *)layer with:(CALayer *)other;
- (void)insertSublayer:(CALayer *)aLayer atIndex:(unsigned int)index;
- (void)insertSublayer:(CALayer *)aLayer below:(CALayer *)sublayer;
- (void)insertSublayer:(CALayer *)aLayer above:(CALayer *)sublayer;
- (void)display;
- (void)displayIfNeeded;
- (void)drawInContext:(CGContextRef)context;
- (BOOL)needsDisplay;
- (void)removeFromSuperlayer;
- (void)setNeedsDisplay;
- (void)setNeedsDisplayInRect:(CGRect)rect;

- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key;
- (CAAnimation *)animationForKey:(NSString *)key;
- (void)removeAllAnimations;
- (void)removeAnimationForKey:(NSString *)key;
- (NSArray *)animationKeys;

- (id<CAAction>)actionForKey:(NSString *)key;

- (void)setNeedsLayout;
- (void)layoutIfNeeded;
- (void)layoutSublayers;
- (CGPoint)convertPoint:(CGPoint)aPoint fromLayer:(CALayer *)layer;
- (CGPoint)convertPoint:(CGPoint)aPoint toLayer:(CALayer *)layer;
- (CGAffineTransform)affineTransform;
- (void)setAffineTransform:(CGAffineTransform)m;
- (id)presentationLayer;
- (id)modelLayer;

@end

@interface NSObject(CALayerDelegate)
- (void)displayLayer:(CALayer *)layer;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context;
- (void)layoutSublayersOfLayer:(CALayer *)layer;
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key;
@end
