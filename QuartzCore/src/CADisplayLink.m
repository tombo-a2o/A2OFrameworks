#import <QuartzCore/CADisplayLink.h>

@implementation CADisplayLink {
    id _target;
    SEL _sel;
    CFTimeInterval _timestamp;
}

+ (CADisplayLink *)displayLinkWithTarget:(id)target selector:(SEL)sel {
    return [[CADisplayLink alloc] initWithTarget:target selector:sel];
}

- (CADisplayLink *)initWithTarget:(id)target selector:(SEL)sel {
    self = [super init];
    _target = target;
    _sel = sel;
    return self;
}

- (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode {
#warning TODO better implementation
    _timestamp = 0;
    [NSTimer scheduledTimerWithTimeInterval:1.0f/60 target:[NSBlockOperation blockOperationWithBlock:^{
        [_target performSelector:_sel withObject:self];
        _timestamp = CFAbsoluteTimeGetCurrent();
    }] selector:@selector(main) userInfo:nil repeats:YES];
}

- (void)removeFromRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode {
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (void)invalidate {
    NSLog(@"%s not implemented", __FUNCTION__);
}
- (CFTimeInterval)timestamp {
    return _timestamp;
}
@end
