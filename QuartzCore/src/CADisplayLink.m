#import <QuartzCore/CADisplayLink.h>

@implementation CADisplayLink {
    id _target;
    SEL _sel;
    CFTimeInterval _timestamp;
    NSTimer *_timer;
}

+ (CADisplayLink *)displayLinkWithTarget:(id)target selector:(SEL)sel {
    return [[CADisplayLink alloc] initWithTarget:target selector:sel];
}

- (CADisplayLink *)initWithTarget:(id)target selector:(SEL)sel {
    self = [super init];
    _target = [target retain];
    _sel = sel;
    _timestamp = 0;
    return self;
}

- (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode {
#warning TODO better implementation
    _timer = [NSTimer timerWithTimeInterval:1.0f/60 target:[NSBlockOperation blockOperationWithBlock:^{
        [_target performSelector:_sel withObject:self];
        _timestamp = CFAbsoluteTimeGetCurrent();
    }] selector:@selector(main) userInfo:nil repeats:YES];
    [runloop addTimer:_timer forMode:mode];
}

- (void)removeFromRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode {
    [_timer invalidate];
}

- (void)invalidate {
    [_timer invalidate];
    [_timer release];
    [_target release];
    _target = nil;
    _sel = nil;
}

- (CFTimeInterval)timestamp {
    return _timestamp;
}

- (NSInteger)frameInterval {
    return 0;
}
- (void)setFrameInterval:(NSInteger)frameInterval {
}
- (CFTimeInterval) duration {
    return 0.0;
}
@end
