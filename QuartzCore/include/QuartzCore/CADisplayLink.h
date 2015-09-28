#import <Foundation/Foundation.h>

@interface CADisplayLink : NSObject
+ (CADisplayLink *)displayLinkWithTarget:(id)target selector:(SEL)sel;
- (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode;
- (void)removeFromRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode;
- (void)invalidate;
@property(readonly, nonatomic) CFTimeInterval duration;
@property(nonatomic) NSInteger frameInterval;
@property(getter=isPaused, nonatomic) BOOL paused;
@property(readonly, nonatomic) CFTimeInterval timestamp;
@end
