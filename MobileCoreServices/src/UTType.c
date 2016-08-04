#import <MobileCoreServices/MobileCoreServices.h>

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
