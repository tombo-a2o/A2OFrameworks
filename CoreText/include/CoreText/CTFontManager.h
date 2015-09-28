#import <CoreFoundation/CoreFoundation.h>

enum {
    kCTFontManagerScopeNone = 0,
    kCTFontManagerScopeProcess = 1,
    kCTFontManagerScopeUser = 2,
    kCTFontManagerScopeSession = 3
};
typedef uint32_t CTFontManagerScope;

bool CTFontManagerRegisterFontsForURL(CFURLRef fontURL, CTFontManagerScope scope, CFErrorRef *error);
