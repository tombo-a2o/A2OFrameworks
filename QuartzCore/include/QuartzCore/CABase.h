#import <CoreFoundation/CoreFoundation.h>

#if defined(__cplusplus)
#define CA_EXPORT extern "C"
#else
#define CA_EXPORT extern
#endif

CA_EXPORT CFTimeInterval CACurrentMediaTime(void);
