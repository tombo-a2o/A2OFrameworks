#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>
#import <OpenGLES/EAGL.h>

@protocol EAGLDrawable
@property(copy) NSDictionary *drawableProperties;
@end

extern NSString * const kEAGLDrawablePropertyColorFormat;
extern NSString * const kEAGLDrawablePropertyRetainedBacking;
extern NSString * const kEAGLColorFormatRGB565;
extern NSString * const kEAGLColorFormatRGBA8;

@interface EAGLContext (EAGLDrawableAddition)
-(BOOL)renderbufferStorage:(NSUInteger)target fromDrawable:(id<EAGLDrawable>)drawable;
@end
