#import <QuartzCore/CADisplayLink.h>

@implementation CADisplayLink {
    id _target;
    SEL _sel;
}

+ (CADisplayLink *)displayLinkWithTarget:(id)target selector:(SEL)sel {
    return [[CADisplayLink alloc] initWithTarget:target selector:sel];
}

- (CADisplayLink *)initWithTarget:(id)target selector:(SEL)sel {
   _target = target;
   _sel = sel;
}

- (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode {
#warning TODO better implementation
    [NSTimer scheduledTimerWithTimeInterval:1.0f/60 target:_target selector:_sel userInfo:nil repeats:YES];
}

- (void)removeFromRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode {
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (void)invalidate {
    NSLog(@"%s not implemented", __FUNCTION__);
}
@end
