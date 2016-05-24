#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>

@protocol EAGLDrawable
@property(copy) NSDictionary *drawableProperties;
@end

extern NSString * const kEAGLDrawablePropertyColorFormat;
extern NSString * const kEAGLDrawablePropertyRetainedBacking;
extern NSString * const kEAGLColorFormatRGB565;
extern NSString * const kEAGLColorFormatRGBA8;
