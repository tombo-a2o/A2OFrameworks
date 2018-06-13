/*
 *  CARenderer.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <QuartzCore/CARenderer.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <Onyx2D/O2Surface.h>
#import <CoreGraphics/CGBitmapContext.h>
#import <CoreGraphics/CGColor.h>
#import <CoreGraphics/CGColorSpace.h>
#import "CAUtil.h"
#import "CAMediaTimingFunction+Private.h"

@implementation CARenderer {
    GLuint _program;
    GLint _attrPosition;
    GLint _attrTexCoord;
    GLint _attrDistance;
    GLint _unifTexture;
    GLint _unifTransform;
    GLint _unifOpacity;
    GLint _unifCornerRadius;
    GLint _unifBorderWidth;
    GLint _unifBorderColor;
    GLint _unifBackgroundColor;
    GLuint _ibo;

    GLint _stencilBits;
}

+(CARenderer *)renderer {
   return [[[self alloc] init] autorelease];
}

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
    "float inside(vec2 v) {\n"
    "    vec2 s = step(vec2(0.0, 0.0), v) - step(vec2(1.0, 1.0), v);\n"
    "    return s.x * s.y;\n"
    "}\n"
    "void main() {\n"
    "    vec4 texColor = inside(texcoordVarying) * texture2D(texture, texcoordVarying);\n"
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


-(instancetype)init {
   _program = loadAndLinkShader(vertexShaderSource, fragmentShaderSource);
   assert(_program);
   _attrPosition = glGetAttribLocation(_program, "position");
   _attrTexCoord = glGetAttribLocation(_program, "texcoord");
   _attrDistance = glGetAttribLocation(_program, "distance");
   _unifTexture = glGetUniformLocation(_program, "texture");
   _unifTransform = glGetUniformLocation(_program, "transform");
   _unifOpacity = glGetUniformLocation(_program, "opacity");
   _unifCornerRadius = glGetUniformLocation(_program, "cornerRadius");
   _unifBorderWidth = glGetUniformLocation(_program, "borderWidth");
   _unifBorderColor = glGetUniformLocation(_program, "borderColor");
   _unifBackgroundColor = glGetUniformLocation(_program, "backgroundColor");
   glGenBuffers(1, &_ibo);
   glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);
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
   glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(index), index, GL_STATIC_DRAW);
   glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

   assert(_attrPosition >= 0);
   assert(_attrTexCoord >= 0);
   assert(_attrDistance >= 0);
   assert(_unifTexture >= 0);
   assert(_unifTransform >= 0);
   assert(_unifOpacity >= 0);
   assert(_unifCornerRadius >= 0);
   assert(_unifBorderWidth >= 0);
   assert(_unifBorderColor >= 0);
   assert(_unifBackgroundColor >= 0);

   glGetIntegerv(GL_STENCIL_BITS, &_stencilBits);

   return self;
}

- (void)dealloc {
    if(_program) {
        glDeleteProgram(_program);
    }
    if(_ibo) {
        glDeleteBuffers(1, &_ibo);
    }
    [super dealloc];
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
    GL_ASSERT();
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
    GL_ASSERT();
    CFRelease(data);
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
    GL_ASSERT();
}


static void calculateTexCoord(GLfloat *x, GLfloat *y, int length, CGFloat dw, CGFloat dh, CGFloat sw, CGFloat sh, NSString *contentsGravity, BOOL flipTexture, GLfloat *s, GLfloat *t) {
    float ax, ay, bx, by;
    if(contentsGravity == kCAGravityCenter) {
        ax = 1.0 / sw;
        ay = 1.0 / sh;
        bx = (1.0 - dw * ax) * 0.5;
        by = (1.0 - dh * ay) * 0.5;
    } else if(contentsGravity == kCAGravityTop) {
        ax = 1.0 / sw;
        ay = 1.0 / sh;
        bx = (1.0 - dw * ax) * 0.5;
        by = 0.0;
    } else if(contentsGravity == kCAGravityBottom) {
        ax = 1.0 / sw;
        ay = 1.0 / sh;
        bx = (1.0 - dw * ax) * 0.5;
        by = (1.0 - dh * ay) * 0.5;
    } else if(contentsGravity == kCAGravityLeft) {
        ax = 1.0 / sw;
        ay = 1.0 / sh;
        bx = 0.0;
        by = (1.0 - dh * ay) * 0.5;
    } else if(contentsGravity == kCAGravityRight) {
        ax = 1.0 / sw;
        ay = 1.0 / sh;
        bx = 1.0 - dw * ax;
        by = (1.0 - dh * ay) * 0.5;
    } else if(contentsGravity == kCAGravityTopLeft) {
        ax = 1.0 / sw;
        ay = 1.0 / sh;
        bx = 0;
        by = 0;
    } else if(contentsGravity == kCAGravityTopRight) {
        ax = 1.0 / sw;
        ay = 1.0 / sh;
        bx = 1.0 - dw * ax;
        by = 0;
    } else if(contentsGravity == kCAGravityBottomLeft) {
        ax = 1.0 / sw;
        ay = 1.0 / sh;
        bx = 0;
        by = 1.0 - dh * ay;
    } else if(contentsGravity == kCAGravityBottomRight) {
        ax = 1.0 / sw;
        ay = 1.0 / sh;
        bx = 1.0 - dw * ax;
        by = 1.0 - dh * ay;
    } else if(contentsGravity == kCAGravityResize) {
        ax = 1.0 / dw;
        ay = 1.0 / dh;
        bx = 0;
        by = 0;
    } else if(contentsGravity == kCAGravityResizeAspect) {
        float r = MAX(sw/dw, sh/dh);
        ax = 1.0 / sw * r;
        ay = 1.0 / sh * r;
        bx = (1.0 - dw * ax) * 0.5;
        by = (1.0 - dh * ay) * 0.5;
    } else if(contentsGravity == kCAGravityResizeAspectFill) {
        float r = MIN(sw/dw, sh/dh);
        ax = 1.0 / sw * r;
        ay = 1.0 / sh * r;
        bx = (1.0 - dw * ax) * 0.5;
        by = (1.0 - dh * ay) * 0.5;
    } else {
        NSLog(@"unexpected contentsGravity %@", contentsGravity);
        assert(0);
    }

    for(int i = 0; i < length; i++) {
        float ss = x[i] * ax + bx;
        float tt = y[i] * ay + by;
        s[i] = ss;
        t[i] = flipTexture ? (1-tt) : tt;
    }
}

static void prepareTexture(CALayer *layer) {
    GLuint texture = [layer _textureId];
    if(texture) {
        // Texture is available. Just bind and use.
        glBindTexture(GL_TEXTURE_2D, texture);
        return;
    }

    // Load pixel data to texture
    id image = layer.contents;

    glGenTextures(1, &texture);
    [layer _setTextureId:texture];

    CALayer *modelLayer = (CALayer*)layer.modelLayer;
    if(image == modelLayer.contents) {
        [modelLayer _setTextureId:texture];
    }

    glBindTexture(GL_TEXTURE_2D, texture);
    GL_ASSERT();

    if(image) {
        if([image isKindOfClass: NSClassFromString(@"O2BitmapContext")]) {
            CATexImage2DCGBitmapContext((CGContextRef)image);
        } else if([image isKindOfClass: NSClassFromString(@"O2Image")]){
            CATexImage2DCGImage((CGImageRef)image);
        } else {
            NSLog(@"Unsupported image format layer=%@, image=%@", layer, image);
            assert(0);
        }
    } else {
        generateTransparentTexture();
    }

#if defined(DEBUG)
    {
        GLboolean isTexture = glIsTexture(texture);
        if(!isTexture) {
            NSLog(@"texture %d is not texture %@", texture, layer);
            assert(0);
        }
    }
#endif

    #warning TODO use POT texture
    // Force linear interpolation due to WebGL npot texture limitation

    // GLint minFilter=interpolationFromName(layer.minificationFilter);
    // GLint magFilter=interpolationFromName(layer.magnificationFilter);
    // glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,minFilter);
    // glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,magFilter);

    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    GL_ASSERT();
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    GL_ASSERT();

    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
    GL_ASSERT();
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
    GL_ASSERT();
}

-(void)_renderLayer:(CALayer *)layer z:(int)z mask:(int)mask transform:(CATransform3D)transform {
    //NSLog(@"CARenderer: renderLayer %d %@ b:%@ f:%@ %d", z, layer, NSStringFromRect(layer.bounds), NSStringFromRect(layer.frame), [layer _textureId]);
    if(layer.isHidden) return;

    prepareTexture(layer);

    GLuint vertexObject = layer._vertexObject;
    if(!vertexObject) {
        glGenBuffers(1, &vertexObject);
        GL_ASSERT();
        [layer _setVertexObject:vertexObject];
    }
    glBindBuffer(GL_ARRAY_BUFFER, vertexObject);
    GL_ASSERT();

    if([layer _needsUpdateVertexObject]) {
        [layer _clearNeedsUpdateVertexObject];

        CGSize  layerSize = layer.bounds.size;
        CGSize  contentsSize = [layer _contentsSize];

        CGFloat w = layerSize.width;
        CGFloat h = layerSize.height;
        CGFloat mid = MIN(w, h) / 2;

        GLfloat x[] = {0, mid, w-mid, w};
        GLfloat y[] = {0, mid, h-mid, h};
        GLfloat s[4], t[4];
        calculateTexCoord(x, y, 4, w, h, contentsSize.width, contentsSize.height, layer.contentsGravity, [layer _flipTexture], s, t);
        GLfloat d[] = {0, mid, mid, 0};
        GLfloat vertices[4*4*6];
        int idx = 0;
        for(int j = 0; j < 4; j++) {
            for(int i = 0; i < 4; i++) {
                vertices[idx++] = x[i];  // coordinate
                vertices[idx++] = y[j];
                vertices[idx++] = s[i];  // texture coord
                vertices[idx++] = t[j];
                vertices[idx++] = d[i];  // distance to edge
                vertices[idx++] = d[j];
            }
        }
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
        GL_ASSERT();
    }

    glEnableVertexAttribArray(_attrPosition);
    GL_ASSERT();
    glEnableVertexAttribArray(_attrTexCoord);
    GL_ASSERT();
    glEnableVertexAttribArray(_attrDistance);
    GL_ASSERT();
    glVertexAttribPointer(_attrPosition, 2, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), 0);
    GL_ASSERT();
    glVertexAttribPointer(_attrTexCoord, 2, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), (GLfloat*)NULL + 2);
    GL_ASSERT();
    glVertexAttribPointer(_attrDistance, 2, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), (GLfloat*)NULL + 4);
    GL_ASSERT();

    CGRect  bounds = layer.bounds;
    CGPoint anchorPoint = layer.anchorPoint;
    CGFloat anchorPointZ = layer.anchorPointZ;
    CGPoint position = layer.position;
    CATransform3D t1 = CATransform3DMakeTranslation(-anchorPoint.x * bounds.size.width, -anchorPoint.y * bounds.size.height, -anchorPointZ);
    CATransform3D t2 = CATransform3DConcat(t1, layer.transform);
    CATransform3D t3 = CATransform3DConcat(t2, CATransform3DMakeTranslation(position.x, position.y, 0));
    CATransform3D t4  = CATransform3DConcat(t3, transform);

    glUniformMatrix4fv(_unifTransform, 1, GL_FALSE, &t4);
    GL_ASSERT();
    glUniform1i(_unifTexture, 0);
    GL_ASSERT();
    glUniform1f(_unifOpacity, layer.opacity);
    GL_ASSERT();
    glUniform1f(_unifCornerRadius, layer.cornerRadius);
    GL_ASSERT();
    glUniform1f(_unifBorderWidth, layer.borderWidth);
    GL_ASSERT();
    GLfloat borderColor[4];
    getColorComponents(layer.borderColor, borderColor);
    glUniform4fv(_unifBorderColor, 1, borderColor);
    GL_ASSERT();
    GLfloat backgroundColor[4];
    getColorComponents(layer.backgroundColor, backgroundColor);
    glUniform4fv(_unifBackgroundColor, 1, backgroundColor);
    GL_ASSERT();

    if(layer.isDoubleSided) {
        glDisable(GL_CULL_FACE);
        GL_ASSERT();
    } else {
        glEnable(GL_CULL_FACE);
        GL_ASSERT();
        glCullFace(GL_BACK);
        GL_ASSERT();
    }

    int mask1000 = 1 << mask;
    int mask0111 = mask1000 - 1;
    int mask1111 = mask1000 | mask0111;
    glStencilMask(mask1000);
    GL_ASSERT();
    glStencilFunc(GL_EQUAL, mask1111, mask0111);
    GL_ASSERT();

    if(layer.masksToBounds) {
        mask++;
        if(mask > _stencilBits) {
            NSLog(@"Too many mask layers");
        }
        glStencilOp(GL_KEEP, GL_REPLACE, GL_REPLACE);
        GL_ASSERT();
    } else {
        glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
        GL_ASSERT();
    }

    glDrawElements(GL_TRIANGLES, 48, GL_UNSIGNED_SHORT, 0);
    GL_ASSERT();
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    GL_ASSERT();

    CATransform3D ts3 = CATransform3DConcat(t2, CATransform3DMakeTranslation(-bounds.origin.x, -bounds.origin.y, 0));
    CATransform3D ts4 = CATransform3DConcat(ts3, layer.sublayerTransform);
    CATransform3D ts5 = CATransform3DConcat(ts4, CATransform3DMakeTranslation(position.x, position.y, 0));
    CATransform3D ts  = CATransform3DConcat(ts5, transform);

    for(CALayer *child in [layer _zOrderedSublayers]) {
        [self _renderLayer:child z:z+1 mask:mask transform:ts];
    }

    if(layer.masksToBounds) {
        glClear(GL_STENCIL_BUFFER_BIT);
        GL_ASSERT();
    }
}

-(void)render:(CALayer*)rootLayer {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    GL_ASSERT();
    glStencilMask(~0);
    GL_ASSERT();
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    GL_ASSERT();

    glEnable(GL_BLEND);
    GL_ASSERT();
    glEnable(GL_STENCIL_TEST);
    GL_ASSERT();
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    GL_ASSERT();
    glDisable(GL_DEPTH_TEST);
    GL_ASSERT();

    glUseProgram(_program);
    GL_ASSERT();
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);
    GL_ASSERT();

    // fprintf(stderr, "bounds %f %f\n",_bounds.size.width, _bounds.size.height);
    CATransform3D projection = CATransform3DIdentity;
    CGRect bounds = rootLayer.bounds;
    projection.m11 = 2.0/bounds.size.width;
    projection.m22 = -2.0/bounds.size.height;
    projection.m41 = -1.0;
    projection.m42 = 1.0;

    [rootLayer _generatePresentationLayer];
    [rootLayer _updateAnimations:CACurrentMediaTime()];
    [self _renderLayer:rootLayer.presentationLayer z:0 mask:0 transform:projection];

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    GL_ASSERT();
    glUseProgram(0);
    GL_ASSERT();

    glFlush();
    GL_ASSERT();
}

@end
