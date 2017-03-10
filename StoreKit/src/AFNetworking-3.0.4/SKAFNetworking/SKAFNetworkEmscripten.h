// FIX_FOR_EMSCRIPTEN:

#ifndef _SKAFNETWORK_EMSCRIPTEN_
#define _SKAFNETWORK_EMSCRIPTEN_

// Define nullable keywords
#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#endif

#ifndef nullable
#define nullable
#endif

#ifndef _Nullable
#define _Nullable
#endif

#ifndef NS_ASSUME_NONNULL_END
#define NS_ASSUME_NONNULL_END
#endif

#ifndef __weak
#define __weak
#endif

// Define NS_SWIFT_NOTHROW
#ifndef NS_SWIFT_NOTHROW
#define NS_SWIFT_NOTHROW
#endif

CFStringRef UTTypeCreatePreferredIdentifierForTag(CFStringRef inTagClass, CFStringRef inTag, CFStringRef inConformingToUTI);
CFStringRef UTTypeCopyPreferredTagWithClass(CFStringRef inUTI, CFStringRef inTagClass);
uint32_t arc4random(void);

#endif
