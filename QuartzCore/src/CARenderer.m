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
    GLuint _vertexObject;

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
    "attribute vec2 position;\n"
    "attribute vec2 texcoord;\n"
    "attribute vec2 distance;\n"
    "uniform mat4 transform;\n"
    "varying vec2 texcoordVarying;\n"
    "varying vec2 distanceVarying;\n"
    "void main() { \n"
    "   vec4 pos = transform * vec4(position, 0.0, 1.0);\n"
    "   gl_Position = vec4(pos.xy, 0.0, pos.w);\n"
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
    "uniform float borderWidth;\n"
    "uniform vec4 borderColor;\n"
    "uniform vec4 backgroundColor;\n"
    "void main() {\n"
    "    vec4 texColor = texture2D(texture, texcoordVarying);\n"
    "    float alpha = texColor.a + backgroundColor.a * (1.0-texColor.a);\n"
    "    vec3 color = alpha > 0.0 ? (texColor.rgb + backgroundColor.rgb * backgroundColor.a * (1.0-texColor.a)) / alpha : vec3(0.0);\n"
    "    float d1 = cornerRadius - length(vec2(min(distanceVarying.x - cornerRadius, 0.0), min(distanceVarying.y - cornerRadius, 0.0)));\n"
    "    float d2 = min(max(distanceVarying.x - cornerRadius, 0.0), max(distanceVarying.y - cornerRadius, 0.0));\n"
    "    float distance = d1 + d2;\n"
    // "    float cornerMask = clamp(distance - borderWidth, 0.0, 1.0);\n"
    // "    float borderMask = clamp(distance, 0.0, 1.0) - cornerMask;\n"
    "    if(distance < 0.0) discard;\n"
    "    float cornerMask = distance >= borderWidth ? 1.0 : 0.0;\n"
    "    float borderMask = distance < borderWidth ? 1.0 : 0.0;\n"
    "    gl_FragColor = mix(vec4(color.rgb, alpha * cornerMask * opacity), borderColor, borderMask);\n"
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
   _unifBorderWidth = glGetUniformLocation(_program, "borderWidth");
   _unifBorderColor = glGetUniformLocation(_program, "borderColor");
   _unifBackgroundColor = glGetUniformLocation(_program, "backgroundColor");
   glGenBuffers(1, &_vertexObject);
   assert(_attrPosition >= 0);
   assert(_attrTexCoord >= 0);
   assert(_attrDistance >= 0);
   assert(_unifTransform >= 0);
   assert(_unifOpacity >= 0);
   assert(_unifCornerRadius >= 0);
   assert(_unifBorderWidth >= 0);
   assert(_unifBorderColor >= 0);
   assert(_unifBackgroundColor >= 0);
   assert(_vertexObject);

   return self;
}

- (void)dealloc {
    if(_program) {
        glDeleteProgram(_program);
    }
    if(_vertexObject) {
        glDeleteBuffers(1, &_vertexObject);
    }
    [_rootLayer release];
    [super dealloc];
}

+(CARenderer *)rendererWithEAGLContext:(void *)eaglContext options:(NSDictionary *)options {
   return [[[self alloc] initWithEAGLContext:eaglContext options:options] autorelease];
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

static void dumpTransform3D(CATransform3D t3) {
    printf("%f %f %f %f\n", t3.m11, t3.m12, t3.m13, t3.m14);
    printf("%f %f %f %f\n", t3.m21, t3.m22, t3.m23, t3.m24);
    printf("%f %f %f %f\n", t3.m31, t3.m32, t3.m33, t3.m34);
    printf("%f %f %f %f\n", t3.m41, t3.m42, t3.m43, t3.m44);
    puts("");
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

-(void)_renderLayer:(CALayer *)layer z:(float)z transform:(CATransform3D)transform {
    //NSLog(@"CARenderer: renderLayer %@ b:%@ f:%@ %f", layer, NSStringFromRect(layer.bounds), NSStringFromRect(layer.frame), z);
    if(layer.isHidden) return;

    GLuint texture = [layer _textureId];
    if(texture != 0 && glIsTexture(texture)==GL_TRUE) {
        // Texture is available. Just bind and use.
        glBindTexture(GL_TEXTURE_2D, texture);
    } else {
        // Load pixel data to texture
        id image = layer.contents;
        
        if(!texture) {
            glGenTextures(1, &texture);
            [layer _setTextureId:texture];
            
            CALayer *modelLayer = (CALayer*)layer.modelLayer;
            if(image == modelLayer.contents) {
                [layer.modelLayer _setTextureId:texture];
            }
        }
        glBindTexture(GL_TEXTURE_2D, texture);

        if(image) {
            if([image isKindOfClass: NSClassFromString(@"O2BitmapContext")]) {
                CATexImage2DCGBitmapContext((CGContextRef)image);
            } else if([image isKindOfClass: NSClassFromString(@"O2Image")]){
                CATexImage2DCGImage((CGImageRef)image);
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

    CALayer *l = layer;
    
    if(l.isDoubleSided) {
        glDisable(GL_CULL_FACE);
    } else {
       glEnable(GL_CULL_FACE);
       glCullFace(GL_BACK);
    }
    
    CGPoint anchorPoint = l.anchorPoint;
    CGPoint position = l.position;
    CGRect  bounds = l.bounds;
    float   cornerRadius = l.cornerRadius;
    float   borderWidth = l.borderWidth;
    CATransform3D layerTransform = l.transform;
    CGFloat anchorPointZ = l.anchorPointZ;

    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    CGFloat mid = MIN(w, h) / 2;

    GLfloat x[] = {0, mid, w-mid, w};
    GLfloat y[] = {0, mid, h-mid, h};
    GLfloat d[] = {0, mid, mid, 0};
    GLfloat vertices[4*4*6];
    BOOL flipTexture = [layer _flipTexture];
    int idx = 0;
    for(int j = 0; j < 4; j++) {
        for(int i = 0; i < 4; i++) {
            vertices[idx++] = x[i];   // coordinate
            vertices[idx++] = y[j];
            vertices[idx++] = x[i]/w; // texture coord
            vertices[idx++] = flipTexture ? 1.0-y[j]/h : y[j]/h;
            vertices[idx++] = d[i];  // distance to edge
            vertices[idx++] = d[j];
        }
    }

    CATransform3D t1 = CATransform3DMakeTranslation(-anchorPoint.x * w, -anchorPoint.y * h, -anchorPointZ);
    CATransform3D t2 = CATransform3DConcat(t1, layerTransform);
    CATransform3D t3 = CATransform3DConcat(t2, CATransform3DMakeTranslation(position.x, position.y, 0));
    CATransform3D t  = CATransform3DConcat(t3, transform);
    glEnableVertexAttribArray(_attrPosition);
    glEnableVertexAttribArray(_attrTexCoord);
    glEnableVertexAttribArray(_attrDistance);

    glBindBuffer(GL_ARRAY_BUFFER, _vertexObject);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glVertexAttribPointer(_attrPosition, 2, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), 0);
    glVertexAttribPointer(_attrTexCoord, 2, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), (GLfloat*)NULL + 2);
    glVertexAttribPointer(_attrDistance, 2, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), (GLfloat*)NULL + 4);
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    glUniformMatrix4fv(_unifTransform, 1, GL_FALSE, &t);
    glUniform1f(_unifOpacity, l.opacity);
    glUniform1f(_unifCornerRadius, cornerRadius);
    glUniform1f(_unifBorderWidth, borderWidth);
    GLfloat borderColor[4];
    getColorComponents(l.borderColor, borderColor);
    glUniform4fv(_unifBorderColor, 1, borderColor);
    GLfloat backgroundColor[4];
    getColorComponents(l.backgroundColor, backgroundColor);
    glUniform4fv(_unifBackgroundColor, 1, backgroundColor);

    const GLushort index[] = {
        0, 4, 1,
        1, 4, 5,
        1, 5, 2,
        2, 5, 6,
        2, 6, 3,
        3, 6, 7,
        4, 8, 5,
        5, 8, 9,
        6, 10, 7,
        7, 10, 11,
        8, 12, 9,
        9, 12, 13,
        9, 13, 10,
        10, 13, 14,
        10, 14, 11,
        11, 14, 15,
    };
    glDrawElements(GL_TRIANGLES, sizeof(index)/sizeof(GLushort), GL_UNSIGNED_SHORT, index);

    CATransform3D sublayerTransform = l.sublayerTransform;
    
    CATransform3D ts3 = CATransform3DConcat(t2, CATransform3DMakeTranslation(-l.bounds.origin.x, -l.bounds.origin.y, 0));
    CATransform3D ts4 = CATransform3DConcat(ts3, sublayerTransform);
    CATransform3D ts5 = CATransform3DConcat(ts4, CATransform3DMakeTranslation(position.x, position.y, 0));
    CATransform3D ts  = CATransform3DConcat(ts5, transform);

    for(CALayer *child in [layer _zOrderedSublayers]) {
        [self _renderLayer:child z:z+1 transform:ts];
    }
}

static void displayTree(CALayer *layer) {
    [layer displayIfNeeded];
    for(CALayer *child in layer.sublayers) {
        displayTree(child);
    }
}

-(void)render {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

    glUseProgram(_program);

    // fprintf(stderr, "bounds %f %f\n",_bounds.size.width, _bounds.size.height);
    CATransform3D projection = CATransform3DIdentity;
    projection.m11 = 2.0/_bounds.size.width;
    projection.m22 = -2.0/_bounds.size.height;
    projection.m41 = -1.0;
    projection.m42 = 1.0;
    
    displayTree(_rootLayer);
    [_rootLayer _generatePresentationLayer];
    [_rootLayer _updateAnimations:CACurrentMediaTime()];
    [self _renderLayer:_rootLayer.presentationLayer z:0 transform:projection];

    glUseProgram(0);
    
    glFlush();
}

-(void)endFrame {
}

@end
