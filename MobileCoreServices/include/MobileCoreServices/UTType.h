#import <CoreFoundation/CoreFoundation.h>

extern const CFStringRef kUTTagClassFilenameExtension;
extern const CFStringRef kUTTagClassMIMEType;
extern const CFStringRef kUTTagClassNSPboardType;
extern const CFStringRef kUTTagClassOSType;

CFStringRef UTTypeCreatePreferredIdentifierForTag ( CFStringRef inTagClass, CFStringRef inTag, CFStringRef inConformingToUTI );
CFArrayRef UTTypeCreateAllIdentifiersForTag ( CFStringRef inTagClass, CFStringRef inTag, CFStringRef inConformingToUTI );
CFStringRef UTTypeCopyPreferredTagWithClass ( CFStringRef inUTI, CFStringRef inTagClass );
