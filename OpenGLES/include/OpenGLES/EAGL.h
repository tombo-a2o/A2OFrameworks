#import <Foundation/NSObject.h>

typedef NS_ENUM(NSUInteger, EAGLRenderingAPI) {
    kEAGLRenderingAPIOpenGLES1         = 1,
    kEAGLRenderingAPIOpenGLES2         = 2,
    kEAGLRenderingAPIOpenGLES3         = 3,
};

@interface EAGLSharegroup : NSObject
@end

@interface EAGLContext : NSObject
+(EAGLContext*) currentContext;
+(BOOL)setCurrentContext:(EAGLContext *)context;
-(instancetype)initWithAPI:(EAGLRenderingAPI)api;
-(instancetype)initWithAPI:(EAGLRenderingAPI)api sharegroup:(EAGLSharegroup *)sharegroup;
-(BOOL)presentRenderbuffer:(NSUInteger)target;
@property(readonly) EAGLRenderingAPI API;
@property(readonly) EAGLSharegroup *sharegroup;
@property(copy, nonatomic) NSString *debugLabel;
@property(getter=isMultiThreaded, nonatomic) BOOL multiThreaded;
@end
