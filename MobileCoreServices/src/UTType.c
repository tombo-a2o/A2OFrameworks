#import <MobileCoreServices/MobileCoreServices.h>

const CFStringRef kUTTagClassFilenameExtension = CFSTR("filenameExtension");
const CFStringRef kUTTagClassMIMEType = CFSTR("mimeType");
const CFStringRef kUTTagClassNSPboardType = CFSTR("");
const CFStringRef kUTTagClassOSType = CFSTR("");

const CFStringRef kUTTypeImage = CFSTR("image");
const CFStringRef kUTTypeJPEG = CFSTR("image/jpeg");
const CFStringRef kUTTypeJPEG2000 = CFSTR("image/jpeng2000");
const CFStringRef kUTTypeTIFF = CFSTR("image/tiff");
const CFStringRef kUTTypePICT = CFSTR("image/pict");
const CFStringRef kUTTypeGIF = CFSTR("image/gif");
const CFStringRef kUTTypePNG = CFSTR("image/png");
const CFStringRef kUTTypeQuickTimeImage = CFSTR("image/qif");
const CFStringRef kUTTypeAppleICNS = CFSTR("image/icns");
const CFStringRef kUTTypeBMP = CFSTR("image/bmp");
const CFStringRef kUTTypeICO = CFSTR("image/ico");

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
