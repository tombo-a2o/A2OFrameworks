
typedef struct O2ImageDestination *CGImageDestinationRef;

#import <CoreGraphics/CGImage.h>
#import <CoreGraphics/CGImageSource.h>
#import <CoreGraphics/CGDataConsumer.h>
#import <CoreFoundation/CFURL.h>

COREGRAPHICS_EXPORT const CFStringRef kCGImageDestinationLossyCompressionQuality;
COREGRAPHICS_EXPORT const CFStringRef kCGImageDestinationBackgroundColor;
COREGRAPHICS_EXPORT const CFStringRef kCGImageDestinationDPI;

COREGRAPHICS_EXPORT CFTypeID CGImageDestinationGetTypeID(void);

COREGRAPHICS_EXPORT CFArrayRef CGImageDestinationCopyTypeIdentifiers(void);

COREGRAPHICS_EXPORT CGImageDestinationRef CGImageDestinationCreateWithData(CFMutableDataRef data, CFStringRef type, size_t imageCount, CFDictionaryRef options);
COREGRAPHICS_EXPORT CGImageDestinationRef CGImageDestinationCreateWithDataConsumer(CGDataConsumerRef dataConsumer, CFStringRef type, size_t imageCount, CFDictionaryRef options);
COREGRAPHICS_EXPORT CGImageDestinationRef CGImageDestinationCreateWithURL(CFURLRef url, CFStringRef type, size_t imageCount, CFDictionaryRef options);

COREGRAPHICS_EXPORT void CGImageDestinationSetProperties(CGImageDestinationRef self, CFDictionaryRef properties);

COREGRAPHICS_EXPORT void CGImageDestinationAddImage(CGImageDestinationRef self, CGImageRef image, CFDictionaryRef properties);
COREGRAPHICS_EXPORT void CGImageDestinationAddImageFromSource(CGImageDestinationRef self, CGImageSourceRef imageSource, size_t index, CFDictionaryRef properties);

COREGRAPHICS_EXPORT bool CGImageDestinationFinalize(CGImageDestinationRef self);

extern const CFStringRef kUTTypeImage;
extern const CFStringRef kUTTypeJPEG;
extern const CFStringRef kUTTypeJPEG2000;
extern const CFStringRef kUTTypeTIFF;
extern const CFStringRef kUTTypePICT;
extern const CFStringRef kUTTypeGIF;
extern const CFStringRef kUTTypePNG;
extern const CFStringRef kUTTypeQuickTimeImage;
extern const CFStringRef kUTTypeAppleICNS;
extern const CFStringRef kUTTypeBMP;
extern const CFStringRef kUTTypeICO;
