#import <CoreGraphics/CGWindow.h>
#import <Onyx2D/O2Surface.h>
#import <OpenGLES/EAGL.h>
#import <QuartzCore/CAWindowOpenGLContext.h>

@interface A2OWindow : CGWindow {
    O2Rect _frame;
    int _level;
    id _delegate;
    NSMutableDictionary *_deviceDictionary;
    CGSBackingStoreType _backingType;
    EAGLContext *_eaglContext;
    CAWindowOpenGLContext *_caContext;
    O2Context *_context;
    O2Context *_backingContext;
}
-initWithFrame:(O2Rect)frame styleMask:(unsigned)styleMask isPanel:(BOOL)isPanel backingType:(NSUInteger)backingType;
- (O2Rect)frame;
@end
