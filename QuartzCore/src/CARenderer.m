#import <QuartzCore/CARenderer.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
//#import <CoreVideo/CoreVideo.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <Onyx2D/O2Surface.h>
#import <CoreGraphics/CGBitmapContext.h>
#import <CoreGraphics/CGColor.h>
#import <CoreGraphics/CGColorSpace.h>
#import "CAUtil.h"
#import "CAMediaTimingFunction+Private.h"

@interface CAAnimation(Rendering)
-(CFTimeInterval)computedDuration;
@end

@implementation CAAnimation(Rendering)
-(CFTimeInterval)computedDuration
{
    CFTimeInterval duration = self.duration;
    float repeatCount = self.repeatCount;
    CFTimeInterval repeatDuration = self.repeatDuration;
    BOOL autoreverses = self.autoreverses;
    
    if(repeatCount != 0.0) {
        duration *= repeatCount;
    }
    if(repeatDuration != 0.0) {
        duration = repeatDuration;
    }
    if(autoreverses) {
        duration *= 2;
    }
    return duration;
}
@end

@implementation CARenderer {
    GLuint _program;
    GLint _attrPosition;
    GLint _attrTexCoord;
    GLint _attrDistance;
    GLint _unifTransform;
    GLint _unifOpacity;
    GLint _unifCornerRadius;
    GLint _unifBorderWidth;
    GLint _unifBorderColor;
    GLint _unifBackgroundColor;
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
    "attribute vec2 distance;\n"
    "uniform mat3 transform;\n"
    "varying vec2 texcoordVarying;\n"
    "varying vec2 distanceVarying;\n"
    "void main() { \n"
    "   gl_Position = vec4((transform * vec3(position.xy, 1.0)).xy, position.z, 1.0);\n"
    "   texcoordVarying = texcoord;\n"
    "   distanceVarying = distance;\n"
    "}\n";
static const char *fragmentShaderSource =
    "precision mediump float;\n"
    "varying vec2 texcoordVarying;\n"
    "varying vec2 distanceVarying;\n"
    "uniform sampler2D texture;\n"
    "uniform float opacity;\n"
    "uniform float cornerRadius;\n"
//    "uniform float borderWidth;\n"
//    "uniform vec4 borderColor;\n"
    "uniform vec4 backgroundColor;\n"
    "void main() {\n"
    "    vec4 texColor = texture2D(texture, texcoordVarying);\n"
    "    float alpha = texColor.a + backgroundColor.a * (1.0-texColor.a);\n"
    "    vec3 color = alpha > 0.0 ? (texColor.rgb + backgroundColor.rgb * backgroundColor.a * (1.0-texColor.a)) / alpha : vec3(0.0);\n"
    "    float distance = length(distanceVarying) - cornerRadius;\n"
    "    float cornerMask = distance > 0.0 ? 0.0 : 1.0; //clamp(-distance, 0.0, 1.0);\n"
//    "    float borderMask = clamp(borderWidth/2.0-abs(distance), 0.0, 1.0);\n"
//"    gl_FragColor = vec4(texColor.rgb, texColor.a * cornerMask * opacity) * (1.0-borderMask) + borderColor * borderMask;\n"
    "    gl_FragColor = vec4(color.rgb, alpha * cornerMask * opacity);\n"
    "}\n";


-initWithEAGLContext:(void *)eaglContext options:(NSDictionary *)options {
   _eaglContext=eaglContext;
   _bounds=CGRectZero;
   _rootLayer=nil;

   _program = loadAndLinkShader(vertexShaderSource, fragmentShaderSource);
   assert(_program);
   _attrPosition = glGetAttribLocation(_program, "position");
   _attrTexCoord = glGetAttribLocation(_program, "texcoord");
   _attrDistance = glGetAttribLocation(_program, "distance");
   _unifTransform = glGetUniformLocation(_program, "transform");
   _unifOpacity = glGetUniformLocation(_program, "opacity");
   _unifCornerRadius = glGetUniformLocation(_program, "cornerRadius");
   // _unifBorderWidth = glGetUniformLocation(_program, "borderWidth");
   // _unifBorderColor = glGetUniformLocation(_program, "borderColor");
   _unifBackgroundColor = glGetUniformLocation(_program, "backgroundColor");
   assert(_attrPosition >= 0);
   assert(_attrTexCoord >= 0);
   assert(_attrDistance >= 0);
   assert(_unifTransform >= 0);
   assert(_unifOpacity >= 0);
   assert(_unifCornerRadius >= 0);
   // assert(_unifBorderWidth >= 0);
   // assert(_unifBorderColor >= 0);
   assert(_unifBackgroundColor >= 0);

   return self;
}

- (void)dealloc {
    if(_program) {
        glDeleteProgram(_program);
    }
    [_rootLayer release];
    [super dealloc];
}

+(CARenderer *)rendererWithEAGLContext:(void *)eaglContext options:(NSDictionary *)options {
   return [[[self alloc] initWithEAGLContext:eaglContext options:options] autorelease];
}

static float mediaTimingScale(CAAnimation *animation,CFTimeInterval currentTime){
    CFTimeInterval begin=[animation beginTime];
    CFTimeInterval duration=[animation duration];
    CFTimeInterval delta=currentTime-begin;
    BOOL autoreverses = [animation autoreverses];
    
    double zeroToOne=delta/duration;
    int count = (int)zeroToOne;
    zeroToOne -= count;
    if(autoreverses && (count % 2) == 1) {
        zeroToOne = 1 - zeroToOne;
    }
    CAMediaTimingFunction *function=[animation timingFunction];

    if(function==nil)
        function=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

    return [function _solveYFor:zeroToOne];
}

static CGImageRef interpolateImageInLayerKey(CALayer *layer,NSString *key,CFTimeInterval currentTime){
    CAAnimation *animation=[layer animationForKey:key];

    if(animation==nil){
        return [layer valueForKey:key];
    }

    if([animation isKindOfClass:[CAKeyframeAnimation class]]){
        CAKeyframeAnimation *basic=(CAKeyframeAnimation *)animation;
        NSMutableArray* images = basic.values;

        int fromValue=0;
        int toValue=[images count];

		float fromFloat=0;
		float toFloat=(float)toValue;

		float        resultFloat;
		double timingScale=mediaTimingScale(animation,currentTime);

		resultFloat=fromFloat+(toFloat-fromFloat)*timingScale;
        int resultInt = resultFloat;

		return [images objectAtIndex: resultInt];
    }

    return nil;
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

static void getColorComponents(CGColorRef cgColor, CGFloat components[4]) {
    if(cgColor) {
        CGColorSpaceRef colorSpace = CGColorGetColorSpace(cgColor);
        CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);
        const CGFloat *cgComponets = CGColorGetComponents(cgColor);
        if(model == kCGColorSpaceModelMonochrome) {
            components[0] = cgComponets[0];
            components[1] = cgComponets[0];
            components[2] = cgComponets[0];
            components[3] = cgComponets[1];
        } else if(model == kCGColorSpaceModelRGB) {
            components[0] = cgComponets[0];
            components[1] = cgComponets[1];
            components[2] = cgComponets[2];
            components[3] = cgComponets[3];
        } else {
            NSLog(@"unimplemented color space");
            assert(0);
        }
    } else {
        components[0] = 0;
        components[1] = 0;
        components[2] = 0;
        components[3] = 0;
    }

}

static void generateTransparentTexture() {
    uint8_t componentsByte[4];
    memset(componentsByte, 0, sizeof(componentsByte));
    glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,1,1,0,GL_RGBA,GL_UNSIGNED_BYTE, componentsByte);
}

-(void)_renderLayer:(CALayer *)layer z:(float)z currentTime:(CFTimeInterval)currentTime transform:(CGAffineTransform)transform {
    NSLog(@"CARenderer: renderLayer %@ b:%@ f:%@ %f", layer, NSStringFromRect(layer.bounds), NSStringFromRect(layer.frame), z);
    if(layer.isHidden) return;

    [layer displayIfNeeded];

    GLuint texture = [layer _textureId];
    GLboolean loadPixelData = GL_FALSE;

    if(texture==0 || glIsTexture(texture)==GL_FALSE) {
        loadPixelData=GL_TRUE;
    } else {
        glBindTexture(GL_TEXTURE_2D, texture);
    }

    //NSLog(@"texture %d", texture);
    CGImageRef image = interpolateImageInLayerKey(layer,@"contents",currentTime);

    if(loadPixelData || [layer _imageRef] != image){
        [layer _setImageRef: image];

        if(!texture) {
            glGenTextures(1, &texture);
            [layer _setTextureId:texture];
        }
        glBindTexture(GL_TEXTURE_2D, texture);

        if(image) {
            if([image isKindOfClass: NSClassFromString(@"O2BitmapContext")]) {
                CATexImage2DCGBitmapContext(image);
            } else if([image isKindOfClass: NSClassFromString(@"O2Image")]){
                CATexImage2DCGImage(image);
            }
#warning TODO use POT texture
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
            generateTransparentTexture();

            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_LINEAR);

            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
        }
    }

    CALayer *l = layer.presentationLayer;
    
    CGPoint anchorPoint = l.anchorPoint;
    CGPoint position = l.position;
    CGRect  bounds = l.bounds;
    float   cornerRadius = l.cornerRadius;
    float   borderWidth = l.borderWidth;
    CGAffineTransform layerTransform = CATransform3DGetAffineTransform(l.transform);

    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;

    GLfloat x[] = {0, cornerRadius, w-cornerRadius, w};
    GLfloat y[] = {0, cornerRadius, h-cornerRadius, h};
    GLfloat r[] = {cornerRadius, 0, 0, cornerRadius};
    GLfloat vertices[4*4*8];
    for(int j = 0; j < 4; j++) {
        for(int i = 0; i < 4; i++) {
            int idx = j*4+i;
            vertices[idx*8  ] = x[i];   // coordinate
            vertices[idx*8+1] = y[j];
            vertices[idx*8+2] = x[i]/w; // texture coord
            vertices[idx*8+3] = y[j]/h;
            vertices[idx*8+4] = x[i]/w; // texture coord(flip)
            vertices[idx*8+5] = 1.0-y[j]/h;
            vertices[idx*8+6] = r[i];  // corner radius
            vertices[idx*8+7] = r[j];
        }
    }

    CGAffineTransform t1 = CGAffineTransformMakeTranslation(-(bounds.size.width*anchorPoint.x),-(bounds.size.height*anchorPoint.y));
    CGAffineTransform t2 = CGAffineTransformConcat(t1, layerTransform);
    CGAffineTransform t3 = CGAffineTransformConcat(t2, CGAffineTransformMakeTranslation(position.x, position.y));
    CGAffineTransform t  = CGAffineTransformConcat(t3, transform);
    // fprintf(stderr, "transform(original) %f %f %f %f %f %f\n", transform.a, transform.b, transform.tx, transform.c, transform.d, transform.ty);
    // fprintf(stderr, "transform(local) %f %f %f %f %f %f\n", local.a, local.b, local.tx, local.c, local.d, local.ty);
    // fprintf(stderr, "transform(total) %f %f %f %f %f %f\n", t.a, t.b, t.tx, t.c, t.d, t.ty);
    GLfloat transformArray[9] = {t.a, t.b, 0.0, t.c, t.d, 0.0, t.tx, t.ty, 1.0};

    glEnableVertexAttribArray(_attrPosition);
    glEnableVertexAttribArray(_attrTexCoord);
    glEnableVertexAttribArray(_attrDistance);

    GLuint vertexObject;
    glGenBuffers(1, &vertexObject);
    glBindBuffer(GL_ARRAY_BUFFER, vertexObject);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glVertexAttribPointer(_attrPosition, 2, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), 0);
    glVertexAttribPointer(_attrTexCoord, 2, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), (GLfloat*)NULL + ([layer _flipTexture] ? 4 : 2));
    glVertexAttribPointer(_attrDistance, 2, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), (GLfloat*)NULL + 6);
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    glUniformMatrix3fv(_unifTransform, 1, GL_FALSE, transformArray);
    glUniform1f(_unifOpacity, l.opacity);
    glUniform1f(_unifCornerRadius, cornerRadius);
    // glUniform1f(_unifBorderWidth, borderWidth);
    GLfloat borderColor[4];
    getColorComponents(l.borderColor, borderColor);
    // glUniform4fv(_unifBorderColor, 1, borderColor);
    GLfloat backgroundColor[4];
    getColorComponents(l.backgroundColor, backgroundColor);
    glUniform4fv(_unifBackgroundColor, 1, backgroundColor);

    const GLushort index[] = {
        0, 4, 1, 5, 2, 6, 3, 7, 7, 11, 6, 10, 5, 9, 4, 8, 8, 12, 9, 13, 10, 14, 11, 15
    };
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(index)/sizeof(GLushort), GL_UNSIGNED_SHORT, index);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    assert(layer.presentationLayer);
    for(CALayer *child in [layer.presentationLayer _zOrderedSublayers]) {
        [self _renderLayer:child.modelLayer z:z+1 currentTime:currentTime transform:t];
    }
}

-(void)render {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

    glUseProgram(_program);

    // fprintf(stderr, "bounds %f %f\n",_bounds.size.width, _bounds.size.height);
    CGAffineTransform projection = CGAffineTransformMake(2.0/_bounds.size.width, 0, 0, -2.0/_bounds.size.height, -1.0, 1.0);
    CFTimeInterval currentTime = CACurrentMediaTime();
    [_rootLayer _generatePresentationLayer];
    [_rootLayer _updateAnimations:currentTime];
    [self _renderLayer:_rootLayer z:0 currentTime:currentTime transform:projection];

    glUseProgram(0);

    glFlush();
}

-(void)endFrame {
}

@end
