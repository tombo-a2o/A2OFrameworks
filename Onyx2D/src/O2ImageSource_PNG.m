/* Copyright (c) 2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

/*  PNG decode is based on the public domain implementation by Sean Barrett  http://www.nothings.org/stb_image.c  V 1.00 */

#import <Onyx2D/O2ImageSource_PNG.h>
#import <Foundation/NSString.h>
#import <Foundation/NSData.h>
#import <Onyx2D/O2DataProvider.h>
#import <Onyx2D/O2ColorSpace.h>
#import <Onyx2D/O2Image.h>

#import <assert.h>

#define STB_IMAGE_IMPLEMENTATION
#define STBI_ONLY_PNG
#import "stb_image.h"

// clang-format on

@implementation O2ImageSource_PNG

+(BOOL)isPresentInDataProvider:(O2DataProvider *)provider {
   enum { signatureLength=8 };
   unsigned char signature[signatureLength] = { 137,80,78,71,13,10,26,10 };
   unsigned char check[signatureLength];
   NSInteger     i,size=[provider getBytes:check range:NSMakeRange(0,signatureLength)];

   if(size!=signatureLength)
    return NO;

   for(i=0;i<signatureLength;i++)
    if(signature[i]!=check[i])
     return NO;

   return YES;
}

-initWithDataProvider:(O2DataProvider *)provider options:(NSDictionary *)options {
   [super initWithDataProvider:provider options:options];
   _png=(NSData *)O2DataProviderCopyData(provider);
   return self;
}

-(void)dealloc {
    [_png release];
    [super dealloc];
}

- (CFStringRef)type
{
    return (CFStringRef)@"public.png";
}

-(unsigned)count {
   return 1;
}

-(O2Image *)createImageAtIndex:(unsigned)index options:(NSDictionary *)options {
   int            width,height;
   int            comp;
   unsigned char *pixels=stbi_load_from_memory([_png bytes],[_png length],&width,&height,&comp,STBI_rgb_alpha);
   int            bitsPerPixel=32;
   int            bytesPerRow=(bitsPerPixel/(sizeof(char)*8))*width;
   NSData        *bitmap;

   if(pixels==NULL)
    return nil;

// clamp premultiplied data, this should probably be moved into the O2Image init
   int i;
   for(i=0;i<bytesPerRow*height;i+=4){
       unsigned char a=pixels[i+3];
       if (a != 0xff) {
           unsigned char r=pixels[i+0];
           unsigned char g=pixels[i+1];
           unsigned char b=pixels[i+2];

           pixels[i+0]=MIN(r,a);
           pixels[i+1]=MIN(g,a);
           pixels[i+2]=MIN(b,a);
       }
   }

   bitmap=[[NSData alloc] initWithBytesNoCopy:pixels length:bytesPerRow*height];

    O2DataProvider *provider=O2DataProviderCreateWithCFData((CFDataRef)bitmap);
   O2ColorSpaceRef colorSpace=O2ColorSpaceCreateDeviceRGB();
   O2Image *image=[[O2Image alloc] initWithWidth:width height:height bitsPerComponent:8 bitsPerPixel:bitsPerPixel bytesPerRow:bytesPerRow
      colorSpace:colorSpace bitmapInfo:kO2ImageAlphaPremultipliedLast|kO2BitmapByteOrder32Big decoder:NULL provider:provider decode:NULL interpolate:NO renderingIntent:kO2RenderingIntentDefault];

   [colorSpace release];
   [provider release];
   [bitmap release];

   return image;
}

-(CFDictionaryRef)copyPropertiesAtIndex:(unsigned)index options:(CFDictionaryRef)options {
    if(index > 0) {
        return nil;
    }
    int width,height;
    int comp;
    stbi_info_from_memory([_png bytes],[_png length],&width,&height,&comp);
    
    return (CFDictionaryRef)[[NSDictionary alloc] initWithObjectsAndKeys:
        [NSNumber numberWithInteger:width], kCGImagePropertyPixelWidth,
        [NSNumber numberWithInteger:height], kCGImagePropertyPixelHeight,
        [NSNumber numberWithBool:comp == 4], kCGImagePropertyHasAlpha,
        nil];
}

@end
