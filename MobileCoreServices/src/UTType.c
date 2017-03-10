#import <MobileCoreServices/MobileCoreServices.h>

const CFStringRef kUTTagClassFilenameExtension = CFSTR("public.filename-extension");
const CFStringRef kUTTagClassMIMEType = CFSTR("public.mime-type");
const CFStringRef kUTTagClassNSPboardType = CFSTR("");
const CFStringRef kUTTagClassOSType = CFSTR("");

const CFStringRef kUTTypeImage = CFSTR("public.image");
const CFStringRef kUTTypeJPEG = CFSTR("public.jpeg");
const CFStringRef kUTTypeJPEG2000 = CFSTR("public.jpeg-2000");
const CFStringRef kUTTypeTIFF = CFSTR("public.tiff");
const CFStringRef kUTTypePICT = CFSTR("com.apple.pict");
const CFStringRef kUTTypeGIF = CFSTR("com.compuserve.gif");
const CFStringRef kUTTypePNG = CFSTR("public.png");
const CFStringRef kUTTypeQuickTimeImage = CFSTR("com.apple.quicktime-image");
const CFStringRef kUTTypeAppleICNS = CFSTR("com.apple.icns");
const CFStringRef kUTTypeBMP = CFSTR("com.microsoft.bmp");
const CFStringRef kUTTypeICO = CFSTR("com.microsoft.ico");

CFStringRef UTTypeCreatePreferredIdentifierForTag ( CFStringRef inTagClass, CFStringRef inTag, CFStringRef inConformingToUTI )
{
    fprintf(stderr, "%s not implemented\n", __FUNCTION__);
    return NULL;
}

CFArrayRef UTTypeCreateAllIdentifiersForTag ( CFStringRef inTagClass, CFStringRef inTag, CFStringRef inConformingToUTI )
{
    fprintf(stderr, "%s not implemented\n", __FUNCTION__);
    return NULL;
}

CFStringRef UTTypeCopyPreferredTagWithClass ( CFStringRef inUTI, CFStringRef inTagClass )
{
    fprintf(stderr, "%s not implemented\n", __FUNCTION__);
    return NULL;
}
