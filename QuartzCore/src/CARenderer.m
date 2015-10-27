#import <QuartzCore/CARenderer.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
//#import <CoreVideo/CoreVideo.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <Onyx2D/O2Surface.h>
#import <CoreGraphics/CGBitmapContext.h>
#import "CAUtil.h"

@interface CALayer(private)
-(void)_setContext:(CALayerContext *)context;
-(void)_setTextureId:(NSNumber *)value;
-(NSNumber *)_textureId;
-(CGFloat)textureSize;
@end

@implementation CARenderer {
    GLuint _program;
    GLint _attrPosition;
    GLint _attrTexCoord;
    GLint _unifTransform;
    GLint _unifOpacity;
    GLint _unifHasTexure;
    GLint _unifBgColor;
}

-(CGRect)bounds {
   return _bounds;
}

-(void)setBounds:(CGRect)value {
   _bounds=value;
}

@synthesize layer=_rootLayer;

static const char *vertexShaderSource =
    "precision mediump float;\n"
    "attribute vec3 position;\n"
    "attribute vec2 texcoord;\n"
    "uniform mat3 transform;\n"
    "varying vec2 texcoordVarying;\n"
    "void main() { \n"
    "   gl_Position = vec4((transform * vec3(position.xy, 1.0)).xy, position.z, 1.0);\n"
    "   texcoordVarying = texcoord;\n"
    "}\n";
static const char *fragmentShaderSource =
    "precision mediump float;\n"
    "varying vec2 texcoordVarying;\n"
    "uniform sampler2D texture;\n"
    "uniform float opacity;\n"
    "uniform bool hasTexture;\n"
    "uniform vec4 bgColor;\n"
    "void main() {\n"
    "    if(hasTexture) {\n"
    "        vec4 texColor = texture2D(texture, texcoordVarying);\n"
    "        gl_FragColor = texColor * opacity;\n"
//    "        gl_FragColor = bgColor * opacity;\n"
//    "        gl_FragColor = mix(bgColor, texColor, texColor.a) * opacity;\n"
    "    } else {\n"
    "        gl_FragColor = bgColor * opacity;\n"
    "    }\n"
    "}\n";


-initWithEAGLContext:(void *)eaglContext options:(NSDictionary *)options {
   _eaglContext=eaglContext;
   _bounds=CGRectZero;
   _rootLayer=nil;

   _program = loadAndLinkShader(vertexShaderSource, fragmentShaderSource);
   _attrPosition = glGetAttribLocation(_program, "position");
   _attrTexCoord = glGetAttribLocation(_program, "texcoord");
   _unifTransform = glGetUniformLocation(_program, "transform");
   _unifOpacity = glGetUniformLocation(_program, "opacity");
   _unifHasTexure = glGetUniformLocation(_program, "hasTexture");
   _unifBgColor = glGetUniformLocation(_program, "bgColor");
   assert(_attrPosition >= 0);
   assert(_attrTexCoord >= 0);
   assert(_unifTransform >= 0);
   assert(_unifOpacity >= 0);
   assert(_unifHasTexure >= 0);
   assert(_unifBgColor >= 0);

   return self;
}

#warning TODO dealloc

+(CARenderer *)rendererWithEAGLContext:(void *)eaglContext options:(NSDictionary *)options {
   return [[[self alloc] initWithEAGLContext:eaglContext options:options] autorelease];
}

static void startAnimationsInLayer(CALayer *layer,CFTimeInterval currentTime){
    NSArray *keys=[layer animationKeys];

    for(NSString *key in keys){
        CAAnimation *check=[layer animationForKey:key];

        if([check beginTime]==0.0)
            [check setBeginTime:currentTime];
        if(currentTime>[check beginTime]+[check duration]){
            [layer removeAnimationForKey:key];
        }
    }

    for(CALayer *child in layer.sublayers)
        startAnimationsInLayer(child,currentTime);
}

-(void)beginFrameAtTime:(CFTimeInterval)currentTime timeStamp:(/*CVTimeStamp*/void *)timeStamp {
    assert(!timeStamp);
    startAnimationsInLayer(_rootLayer,currentTime);
}

static inline float cubed(float value){
   return value*value*value;
}

static inline float squared(float value){
   return value*value;
}

static float applyMediaTimingFunction(CAMediaTimingFunction *function,float t){
    float result;
    float cp1[2];
    float cp2[2];

    [function getControlPointAtIndex:1 values:cp1];
    [function getControlPointAtIndex:2 values:cp2];

    double x=cubed(1.0-t)*0.0+3*squared(1-t)*t*cp1[0]+3*(1-t)*squared(t)*cp2[0]+cubed(t)*1.0;
    double y=cubed(1.0-t)*0.0+3*squared(1-t)*t*cp1[1]+3*(1-t)*squared(t)*cp2[1]+cubed(t)*1.0;

// this is wrong
    return y;
}

static float mediaTimingScale(CAAnimation *animation,CFTimeInterval currentTime){
    CFTimeInterval begin=[animation beginTime];
    CFTimeInterval duration=[animation duration];
    CFTimeInterval delta=currentTime-begin;
    double         zeroToOne=delta/duration;
    CAMediaTimingFunction *function=[animation timingFunction];

    if(function==nil)
        function=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

    return applyMediaTimingFunction(function,zeroToOne);
}

static float interpolateFloatInLayerKey(CALayer *layer,NSString *key,CFTimeInterval currentTime){
    CAAnimation *animation=[layer animationForKey:key];

    if(animation==nil)
        return [[layer valueForKey:key] floatValue];

    if([animation isKindOfClass:[CABasicAnimation class]]){
        CABasicAnimation *basic=(CABasicAnimation *)animation;

        id fromValue=[basic fromValue];
        id toValue=[basic toValue];

        if(toValue==nil)
            toValue=[layer valueForKey:key];

        float fromFloat=[fromValue floatValue];
        float toFloat=[toValue floatValue];

        float        resultFloat;
        double timingScale=mediaTimingScale(animation,currentTime);

        resultFloat=fromFloat+(toFloat-fromFloat)*timingScale;

        return resultFloat;
    }

    return 0;
}

static CGPoint interpolatePointInLayerKey(CALayer *layer,NSString *key,CFTimeInterval currentTime){
    CAAnimation *animation=[layer animationForKey:key];

    if(animation==nil) {
        // NSLog(@"no animation %@ %@", layer, key);
        return [[layer valueForKey:key] pointValue];
    }

    if([animation isKindOfClass:[CABasicAnimation class]]){
        // NSLog(@"animation exists %@ %@", layer, key);
        CABasicAnimation *basic=(CABasicAnimation *)animation;

        id fromValue=[basic fromValue];
        id toValue=[basic toValue];

        if(toValue==nil)
            toValue=[layer valueForKey:key];

        CGPoint fromPoint=[fromValue pointValue];
        CGPoint toPoint=[toValue pointValue];

        CGPoint        resultPoint;
        double timingScale=mediaTimingScale(animation,currentTime);

        resultPoint.x=fromPoint.x+(toPoint.x-fromPoint.x)*timingScale;
        resultPoint.y=fromPoint.y+(toPoint.y-fromPoint.y)*timingScale;

        return resultPoint;
    }

    return CGPointMake(0,0);
}

static CGRect interpolateRectInLayerKey(CALayer *layer,NSString *key,CFTimeInterval currentTime){
    CAAnimation *animation=[layer animationForKey:key];

    if(animation==nil){
        return [[layer valueForKey:key] rectValue];
    }

    if([animation isKindOfClass:[CABasicAnimation class]]){
        CABasicAnimation *basic=(CABasicAnimation *)animation;

        id fromValue=[basic fromValue];
        id toValue=[basic toValue];

        if(toValue==nil)
            toValue=[layer valueForKey:key];

        CGRect fromRect=[fromValue rectValue];
        CGRect toRect=[toValue rectValue];

        double timingScale=mediaTimingScale(animation,currentTime);

        CGRect        resultRect;

        resultRect.origin.x=fromRect.origin.x+(toRect.origin.x-fromRect.origin.x)*timingScale;
        resultRect.origin.y=fromRect.origin.y+(toRect.origin.y-fromRect.origin.y)*timingScale;
        resultRect.size.width=fromRect.size.width+(toRect.size.width-fromRect.size.width)*timingScale;
        resultRect.size.height=fromRect.size.height+(toRect.size.height-fromRect.size.height)*timingScale;

        return resultRect;
    }

    return CGRectMake(0,0,0,0);
}

static GLint interpolationFromName(NSString *name){
    if(name==kCAFilterLinear)
        return GL_LINEAR;
    else if(name==kCAFilterNearest)
        return GL_NEAREST;
    else if([name isEqualToString:kCAFilterLinear])
        return GL_LINEAR;
    else if([name isEqualToString:kCAFilterNearest])
        return GL_NEAREST;
    else
        return GL_LINEAR;
}

void CATexImage2DCGBitmapContext(CGContextRef context) {
    size_t            imageWidth=CGBitmapContextGetWidth(context);
    size_t            imageHeight=CGBitmapContextGetHeight(context);
    CGBitmapInfo      bitmapInfo=CGBitmapContextGetBitmapInfo(context);
    const uint8_t    *pixelBytes=CGBitmapContextGetData(context);

#warning TODO check bitmap info
    GLenum glFormat = GL_RGBA;
    GLenum glType = GL_UNSIGNED_BYTE;
    glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,imageWidth,imageHeight,0,glFormat,glType,pixelBytes);
}

void CATexImage2DCGImage(CGImageRef image){
    size_t            imageWidth=CGImageGetWidth(image);
    size_t            imageHeight=CGImageGetHeight(image);
    CGBitmapInfo      bitmapInfo=CGImageGetBitmapInfo(image);

    CGDataProviderRef provider=CGImageGetDataProvider(image);
    CFDataRef         data=CGDataProviderCopyData(provider);
    const uint8_t    *pixelBytes=CFDataGetBytePtr(data);

    GLenum glFormat=GL_BGRA;
    GLenum glType=GL_UNSIGNED_INT;

    CGImageAlphaInfo alphaInfo=bitmapInfo&kCGBitmapAlphaInfoMask;
    CGBitmapInfo     byteOrder=bitmapInfo&kCGBitmapByteOrderMask;

    switch(alphaInfo){

        case kCGImageAlphaNone:
            break;

        case kCGImageAlphaPremultipliedLast:
            if(byteOrder==kO2BitmapByteOrder32Big){
                glFormat=GL_RGBA;
                glType=GL_UNSIGNED_INT;
            }
            break;

        case kCGImageAlphaPremultipliedFirst: // ARGB
            if(byteOrder==kCGBitmapByteOrder32Little){
                glFormat=GL_BGRA;
                glType=GL_UNSIGNED_INT;
            }
            break;

        case kCGImageAlphaLast:
            if(byteOrder==kO2BitmapByteOrder32Big){
                glFormat=GL_RGBA;
                glType=GL_UNSIGNED_BYTE;
            }
            break;

        case kCGImageAlphaFirst:
            break;

        case kCGImageAlphaNoneSkipLast:
            break;

        case kCGImageAlphaNoneSkipFirst:
            break;

        case kCGImageAlphaOnly:
            break;
    }
    glFormat = GL_RGBA;
    glType = GL_UNSIGNED_BYTE;

    glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,imageWidth,imageHeight,0,glFormat,glType,pixelBytes);
}

static void generateGLColorFromCGColor(CGColorRef cgColor, GLfloat components[4]) {
    if(cgColor) {
        const CGFloat *cgComponets = CGColorGetComponents(cgColor);
        components[0] = cgComponets[0];
        components[1] = cgComponets[1];
        components[2] = cgComponets[2];
        components[3] = CGColorGetNumberOfComponents(cgColor) == 4 ? cgComponets[3] : 1.0;
    } else {
        components[0] = 0.0;
        components[1] = 0.0;
        components[2] = 0.0;
        components[3] = 0.0;
    }
}

-(void)_renderLayer:(CALayer *)layer z:(float)z currentTime:(CFTimeInterval)currentTime transform:(CGAffineTransform)transform {
    NSLog(@"CARenderer: renderLayer %@ b:%@ f:%@ %f", layer, NSStringFromRect(layer.bounds), NSStringFromRect(layer.frame), z);

    NSNumber *textureId=[layer _textureId];
    GLuint    texture=[textureId unsignedIntValue];
    GLboolean loadPixelData=GL_FALSE;

    [layer displayIfNeeded];

    if(texture==0) {
        loadPixelData=GL_TRUE;
    } else {
        if(glIsTexture(texture)==GL_FALSE) {
            loadPixelData=GL_TRUE;
        } else {
            glBindTexture(GL_TEXTURE_2D, texture);
        }
    }

    if(loadPixelData){
        CGImageRef image = layer.contents;

        if(image) {
            if(!texture) {
                glGenTextures(1, &texture);
                [layer _setTextureId:[NSNumber numberWithUnsignedInteger:texture]];
            }
            glBindTexture(GL_TEXTURE_2D, texture);
            if([image isKindOfClass: NSClassFromString(@"O2BitmapContext")]) {
                CATexImage2DCGBitmapContext(image);
            } else if([image isKindOfClass: NSClassFromString(@"O2Image")]){
                CATexImage2DCGImage(image);
            }

            // Force linear interpolation due to WebGL npot texture limitation

            // GLint minFilter=interpolationFromName(layer.minificationFilter);
            // GLint magFilter=interpolationFromName(layer.magnificationFilter);
            // glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,minFilter);
            // glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,magFilter);

            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_LINEAR);

            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
        } else {
            glBindTexture(GL_TEXTURE_2D, 0);
        }
    }

    CGPoint anchorPoint=interpolatePointInLayerKey(layer,@"anchorPoint",currentTime);
    CGPoint position=interpolatePointInLayerKey(layer,@"position",currentTime);
    // fprintf(stderr, "pos %f %f\n", position.x, position.y);
    CGRect  bounds=interpolateRectInLayerKey(layer,@"bounds",currentTime);
    float   opacity=interpolateFloatInLayerKey(layer,@"opacity",currentTime);

    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    // NSLog(@"bounds %f %f", w, h);
    // NSLog(@"opacity %f", opacity);

    GLfloat textureVertices[4*2] = {
        0.0, 1.0,
        1.0, 1.0,
        0.0, 0.0,
        1.0, 0.0
    };
    GLfloat vertices[4*3] = {
        0, 0, -z/65536,
        w, 0, -z/65536,
        0, h, -z/65536,
        w, h, -z/65536,
    };

    CGAffineTransform local = CGAffineTransformMakeTranslation(position.x-(bounds.size.width*anchorPoint.x),position.y-(bounds.size.height*anchorPoint.y));
    CGAffineTransform t  = CGAffineTransformConcat(local, transform);
    // fprintf(stderr, "transform(original) %f %f %f %f %f %f\n", transform.a, transform.b, transform.tx, transform.c, transform.d, transform.ty);
    // fprintf(stderr, "transform(local) %f %f %f %f %f %f\n", local.a, local.b, local.tx, local.c, local.d, local.ty);
    // fprintf(stderr, "transform(total) %f %f %f %f %f %f\n", t.a, t.b, t.tx, t.c, t.d, t.ty);
    GLfloat transformArray[9] = {t.a, t.b, 0.0, t.c, t.d, 0.0, t.tx, t.ty, 1.0};

    glUseProgram(_program);

    glEnableVertexAttribArray(_attrPosition);
    glEnableVertexAttribArray(_attrTexCoord);

    glVertexAttribPointer(_attrPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(_attrTexCoord, 2, GL_FLOAT, GL_FALSE, 0, textureVertices);

    glUniformMatrix3fv(_unifTransform, 1, GL_FALSE, transformArray);
    glUniform1f(_unifOpacity, opacity);
    glUniform1i(_unifHasTexure, glIsTexture(texture));
    GLfloat color[4];
    generateGLColorFromCGColor(layer.backgroundColor, color);
    glUniform4fv(_unifBgColor, 1, color);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    for(CALayer *child in layer.sublayers) {
        [self _renderLayer:child z:z+1 currentTime:currentTime transform:t];
    }
#if 0
   glPushMatrix();
 //  glTranslatef(width/2,height/2,0);
   glTexCoordPointer(2, GL_FLOAT, 0, textureVertices);
   glVertexPointer(3, GL_FLOAT, 0, vertices);


   glTranslatef(position.x-(bounds.size.width*anchorPoint.x),position.y-(bounds.size.height*anchorPoint.y),0);
  // glTranslatef(position.x,position.y,0);
  // glScalef(bounds.size.width,bounds.size.height,1);

 //  glRotatef(1,0,0,1);
   glColor4f(opacity,opacity,opacity,opacity);

   glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

   for(CALayer *child in layer.sublayers)
    [self _renderLayer:child z:z+1 currentTime:currentTime];

   glPopMatrix();
#endif
}

-(void)render {
#if 1
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glEnable (GL_BLEND);
    glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);

    // fprintf(stderr, "bounds %f %f\n",_bounds.size.width, _bounds.size.height);
    CGAffineTransform projection = CGAffineTransformMake(2.0/_bounds.size.width, 0, 0, 2.0/_bounds.size.height, -1.0, -1.0);
    [self _renderLayer:_rootLayer z:0 currentTime:CACurrentMediaTime() transform:projection];

    glFlush();
#else
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();

   glClearColor(0, 0, 0, 1);
   glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

   glEnable(GL_DEPTH_TEST);
   glDepthFunc(GL_LEQUAL);

   glEnable( GL_TEXTURE_2D );
   glEnableClientState(GL_VERTEX_ARRAY);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);

   glEnable (GL_BLEND);
   glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);

   glAlphaFunc ( GL_GREATER, 0 ) ;
   glEnable ( GL_ALPHA_TEST ) ;

   [self _renderLayer:_rootLayer z:0 currentTime:CACurrentMediaTime()];

   glFlush();
#endif
}

-(void)endFrame {
}

@end
