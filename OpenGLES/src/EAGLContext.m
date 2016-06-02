#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <emscripten/html5.h>
#import <QuartzCore/CAEAGLLayer.h>
#import <QuartzCore/CALayer+Private.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <emscripten.h>

NSString * const kEAGLDrawablePropertyColorFormat = @"EAGLDrawablePropertyColorFormat";
NSString * const kEAGLDrawablePropertyRetainedBacking = @"EAGLDrawablePropertyRetainedBacking";
NSString * const kEAGLColorFormatRGB565 = @"EAGLColorFormat565";
NSString * const kEAGLColorFormatRGBA8 = @"EAGLColorFormatRGBA8";

@implementation EAGLSharegroup
@end

@implementation EAGLContext {
    NSMutableDictionary *_renderBufferEAGLLayer;
}

// TODO multithread
static EAGLContext *_currentContext = nil;

+(EAGLContext*) currentContext {
    return _currentContext;
}

+(BOOL)setCurrentContext:(EAGLContext *)context {
    _currentContext = context;
    return YES;
}

-(instancetype)initWithAPI:(EAGLRenderingAPI)api {
  return [self initWithAPI:api sharegroup:[[EAGLSharegroup alloc] init]];
}

-(instancetype)initWithAPI:(EAGLRenderingAPI)api sharegroup:(EAGLSharegroup *)sharegroup {
    self = [super init];
    _API = api;
    _sharegroup = sharegroup;
    _renderBufferEAGLLayer = [[NSMutableDictionary alloc] init];

    return self;
}

-(BOOL)renderbufferStorage:(NSUInteger)target fromDrawable:(id<EAGLDrawable>)drawable {
    if(![drawable isKindOfClass:[CAEAGLLayer class]]) {
        NSLog(@"drawable is not CAEAGLLayer class");
        return NO;
    }

    CAEAGLLayer *layer = (CAEAGLLayer*)drawable;

    GLint renderbuffer;
    glGetIntegerv(GL_RENDERBUFFER_BINDING, &renderbuffer);
    //NSLog(@"%d -> %@", renderbuffer, layer);
    [_renderBufferEAGLLayer setObject:layer forKey:[NSNumber numberWithInt:renderbuffer]];

    NSString *pixelFormat = [layer.drawableProperties objectForKey:kEAGLDrawablePropertyColorFormat];
    GLenum format = GL_RGBA8_OES; // default but not available
    if([pixelFormat isEqualToString:kEAGLColorFormatRGB565]) {
        format = GL_RGB565;
    }

    NSNumber *ratainedBacking = [layer.drawableProperties objectForKey:kEAGLDrawablePropertyRetainedBacking];
    if([ratainedBacking boolValue]) {
        NSLog(@"%s kEAGLDrawablePropertyRetainedBacking=YES is not supported", __FUNCTION__);
    }

    CGFloat scale = layer.contentsScale;
    GLint width = layer.bounds.size.width * scale;
    GLint height = layer.bounds.size.height * scale;

    glRenderbufferStorage(target, format, width, height);

    return glGetError() == GL_NO_ERROR;
}

-(BOOL)presentRenderbuffer:(NSUInteger)target {
    GLint renderbuffer;
    glGetIntegerv(GL_RENDERBUFFER_BINDING, &renderbuffer);
    //NSLog(@"renderbuffer %d", renderbuffer);
    CAEAGLLayer *layer = [_renderBufferEAGLLayer objectForKey:[NSNumber numberWithInt:renderbuffer]];
    if(!layer) {
        NSLog(@"Layer not found renderbuffer=%d", renderbuffer);
        return NO;
    }

    CGFloat scale = layer.contentsScale;
    GLint width = layer.bounds.size.width * scale;
    GLint height = layer.bounds.size.height * scale;

    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
    glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, width, height, 0);
    
#if DEBUG
    if(glGetError() != GL_NO_ERROR) {
        NSLog(@"failed to glCopyTexImage2D");
        return NO;
    }
#endif
    //NSLog(@"presentRenderbuffer %d (%d, %d)", texture, width, height);

    glBindTexture(GL_TEXTURE_2D, 0);
    [layer _setTextureId:texture];

    return YES;
}
@end
