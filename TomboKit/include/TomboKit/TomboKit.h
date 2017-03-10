#ifdef DEBUG
#define TomboKitDebugLog(fmt,...) NSLog((@"%s %d "fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define TomboKitDebugLog(...)
#endif

#import <TomboKit/TomboKitAPI.h>
