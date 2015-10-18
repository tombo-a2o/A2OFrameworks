#import <CoreGraphics/A2OWindow.h>

CGRect CGInsetRectForNativeWindowBorder(CGRect frame, unsigned styleMask) {
    return frame;
}
CGRect CGOutsetRectForNativeWindowBorder(CGRect frame, unsigned styleMask) {
    return frame;
}


@implementation A2OWindow

-initWithFrame:(O2Rect)frame styleMask:(unsigned)styleMask isPanel:(BOOL)isPanel backingType:(NSUInteger)backingType {
    _frame = frame;
    _backingType = backingType;
    _deviceDictionary = [NSMutableDictionary new];
    return self;
}

-(void)dealloc {
    [_deviceDictionary release];
    [super dealloc];
}

-(void)setDelegate:delegate {
    _delegate = delegate;
}

-delegate {
    return _delegate;
}

-(void)setLevel:(int)value {
    _level=value;
}

-(BOOL)isMiniaturized {
    return NO;
}

-(void)setTitle:(NSString *)title {
    /*
    setWindowTitle ? document.title ?
    */
}

-(void)placeAboveWindow:(int)otherNumber {
}

-(O2Context *)createCGContextIfNeeded {
    if(_context==nil)
        _context=[O2Context createContextWithSize:_frame.size window:self];

    assert(_context);

    return _context;
}

-(O2Context *)createBackingCGContextIfNeeded {
    if(_backingContext==nil){
        _backingContext=[O2Context createBackingContextWithSize:_frame.size context:[self createCGContextIfNeeded] deviceDictionary:_deviceDictionary];
    }

    assert(_backingContext);

    return _backingContext;
}

-(O2Context *)cgContext {
    switch(_backingType){
    case CGSBackingStoreRetained:
    case CGSBackingStoreNonretained:
    default:
        return [self createCGContextIfNeeded];
    case CGSBackingStoreBuffered:
        return [self createBackingCGContextIfNeeded];
    }
    return nil;
}

//extern CGLError CGLCreateContextForWindow(CGLPixelFormatObj pixelFormat,CGLContextObj share,CGLContextObj *resultp,Display *display,XVisualInfo *visualInfo,Window window);

-(void)createCGLContextObjIfNeeded {
    if(_eaglContext==NULL){
        _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if(!_eaglContext)
            NSLog(@"glXCreateContext failed at %s %d",__FILE__,__LINE__);
    }
    if(_eaglContext!=NULL && _caContext==NULL){
        _caContext=[[CAWindowOpenGLContext alloc] initWithEAGLContext:_eaglContext];
    }
}

-(void)openGLFlushBuffer {
   [self createCGLContextObjIfNeeded];
   if(_caContext==NULL)
    return;

   O2Surface *surface=[_backingContext surface];
   size_t width=O2ImageGetWidth(surface);
   size_t height=O2ImageGetHeight(surface);

   [_caContext prepareViewportWidth:width height:height];
   [_caContext renderSurface:surface];

#if 1
    assert(0);
#else
   glFlush();
   glXSwapBuffers(_display,_window);
#endif
}

-(void)flushBuffer {
    switch(_backingType){
    case CGSBackingStoreRetained:
    case CGSBackingStoreNonretained:
        O2ContextFlush(_context);
        break;

    case CGSBackingStoreBuffered:
        if(_backingContext!=nil){
            O2ContextFlush(_backingContext);
            [self openGLFlushBuffer];
        }
        break;
    }
}

-(O2Rect)frame
{
    return _frame;
//   return [self transformFrame:_frame];
}
@end
