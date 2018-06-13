/*
 *  CADisplayLink.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CADisplayLink.h>
#import <dispatch/dispatch.h>

@implementation CADisplayLink {
    id _target;
    SEL _sel;
    CFTimeInterval _timestamp;
    dispatch_source_t _source;
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

- (void)dealloc {
    [self invalidate];
    [super dealloc];
}

- (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode {
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 1<<10, dispatch_get_current_queue());
    dispatch_source_set_timer(_source, 0, 0, 0);
    dispatch_source_set_event_handler(_source, ^{
        [_target performSelector:_sel withObject:self];
        _timestamp = CFAbsoluteTimeGetCurrent();
    });
    dispatch_resume(_source);
}

- (void)removeFromRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode {
    dispatch_source_cancel(_source);
}

- (void)invalidate {
    dispatch_source_cancel(_source);
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
