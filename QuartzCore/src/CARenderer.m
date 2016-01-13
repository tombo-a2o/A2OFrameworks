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

static void startAnimationsInLayer(CALayer *layer,CFTimeInterval currentTime){
    NSArray *keys=[layer animationKeys];

    for(NSString *key in keys){
        CAAnimation *check=[layer animationForKey:key];

        if([check beginTime]==0.0)
            [check setBeginTime:currentTime];

        CFTimeInterval duration = [check duration];
        float repeatCount = [check repeatCount];
        CFTimeInterval repeatDuration = [check repeatDuration];
        BOOL autoreverses = [check autoreverses];
        if(repeatCount != 0.0) {
            duration *= repeatCount;
        }
        if(repeatDuration != 0.0) {
            duration = repeatDuration;
        }
        if(autoreverses) {
            duration *= 2;
        }

        if(currentTime > [check beginTime] + duration){
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

static CATransform3D interpolateTransform3DInLayerKey(CALayer *layer,NSString *key,CFTimeInterval currentTime){
	CAAnimation *animation=[layer animationForKey:key];

	if(animation==nil){
		return [[layer valueForKey:key] CATransform3DValue];
	}

	if([animation isKindOfClass:[CABasicAnimation class]]){
		CABasicAnimation *basic=(CABasicAnimation *)animation;

		id fromValue=[basic fromValue];
		id toValue=[basic toValue];

		if(toValue==nil)
			toValue=[layer valueForKey:key];

		CATransform3D t1=[fromValue CATransform3DValue];
		CATransform3D t2=[toValue CATransform3DValue];

		double timingScale=mediaTimingScale(animation,currentTime);

		CATransform3D resultTransform;
        
        CGFloat det1, det2;
        
        det1 = t1.m11*t1.m22 - t1.m12*t1.m21;
        det2 = t2.m11*t2.m22 - t2.m12*t2.m21;
        
        if(det1 == 0.0 || det2 == 0.0) {
            // linear
            resultTransform.m11 = t1.m11+(t2.m11-t1.m11)*timingScale;
            resultTransform.m21 = t1.m21+(t2.m21-t1.m21)*timingScale;
            resultTransform.m12 = t1.m12+(t2.m12-t1.m12)*timingScale;
            resultTransform.m22 = t1.m22+(t2.m22-t1.m22)*timingScale;
        } else {
            // |a b|  = |cos -sin| |1  skew| |sx  0 |
            // |c d|    |sin  cos| |0  1   | |0   sy|
            // http://math.stackexchange.com/questions/78137/decomposition-of-a-nonsquare-affine-matrix
            
            CGFloat rot, rot1, rot2;
            CGFloat skew, skew1, skew2;
            CGFloat sx, sx1, sx2;
            CGFloat sy, sy1, sy2;
            
            sx1 = sqrt(t1.m11*t1.m11 + t1.m21*t1.m21);
            sx2 = sqrt(t2.m11*t2.m11 + t2.m21*t2.m21);
            
            sy1 = det1 / sx1;
            sy2 = det2 / sx2;
            
            rot1 = atan2(t1.m21, t1.m11);
            rot2 = atan2(t2.m21, t2.m11);
            
            skew1 = (t1.m11*t1.m12+t1.m21*t1.m22) / det1;
            skew2 = (t2.m11*t2.m12+t2.m21*t2.m22) / det2;
            
            sx = sx1 + (sx2-sx1)*timingScale;
            sy = sy1 + (sy2-sy1)*timingScale;
            CGFloat d = rot2 - rot1;
            if(d > M_PI) d -= M_PI*2;
            if(d < -M_PI) d += M_PI*2;
            rot = rot1 + d*timingScale;
            skew = skew1 + (skew2-skew1)*timingScale;
            
            resultTransform.m11 = sx * cos(rot);
            resultTransform.m12 = sy * (skew*cos(rot) - sin(rot));
            resultTransform.m21 = sx * sin(rot);
            resultTransform.m22 = sy * (skew*cos(rot) + cos(rot));
        }
        resultTransform.m41 = t1.m41+(t2.m41-t1.m41)*timingScale;
        resultTransform.m42 = t1.m42+(t2.m42-t1.m42)*timingScale;

		return resultTransform;
	}

	return CATransform3DIdentity;
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
    //NSLog(@"CARenderer: renderLayer %@ b:%@ f:%@ %f", layer, NSStringFromRect(layer.bounds), NSStringFromRect(layer.frame), z);
    
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
#warning TODO interpolate?
            generateTransparentTexture();

            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_LINEAR);

            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
        }
    }

    CGPoint anchorPoint=interpolatePointInLayerKey(layer,@"anchorPoint",currentTime);
    CGPoint position=interpolatePointInLayerKey(layer,@"position",currentTime);
    // fprintf(stderr, "pos %f %f\n", position.x, position.y);
    CGRect  bounds=interpolateRectInLayerKey(layer,@"bounds",currentTime);
    float   opacity=interpolateFloatInLayerKey(layer,@"opacity",currentTime);
    float   cornerRadius = interpolateFloatInLayerKey(layer,@"cornerRadius",currentTime);
    float   borderWidth = interpolateFloatInLayerKey(layer,@"borderWidth",currentTime);
    CGAffineTransform layerTransform = CATransform3DGetAffineTransform(interpolateTransform3DInLayerKey(layer,@"transform",currentTime));

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
    glUniform1f(_unifOpacity, opacity);
    glUniform1f(_unifCornerRadius, cornerRadius);
    // glUniform1f(_unifBorderWidth, borderWidth);
    GLfloat borderColor[4];
    getColorComponents(layer.borderColor, borderColor);
    // glUniform4fv(_unifBorderColor, 1, borderColor);
    GLfloat backgroundColor[4];
    getColorComponents(layer.backgroundColor, backgroundColor);
    glUniform4fv(_unifBackgroundColor, 1, backgroundColor);

    const GLushort index[] = {
        0, 4, 1, 5, 2, 6, 3, 7, 7, 11, 6, 10, 5, 9, 4, 8, 8, 12, 9, 13, 10, 14, 11, 15
    };
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(index)/sizeof(GLushort), GL_UNSIGNED_SHORT, index);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    NSArray *sublayers = [layer.sublayers sortedArrayUsingComparator:^(CALayer *l1, CALayer *l2) {
        CGFloat z1 = interpolateFloatInLayerKey(l1, @"zPosition",currentTime);
        CGFloat z2 = interpolateFloatInLayerKey(l2, @"zPosition",currentTime);
        if(z1 > z2) {
            return NSOrderedDescending;
        } else if(z1 < z2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];

    for(CALayer *child in sublayers) {
        [self _renderLayer:child z:z+1 currentTime:currentTime transform:t];
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
    [self beginFrameAtTime:currentTime timeStamp:NULL];
    [self _renderLayer:_rootLayer z:0 currentTime:currentTime transform:projection];

    glUseProgram(0);

    glFlush();
}

-(void)endFrame {
}

@end
