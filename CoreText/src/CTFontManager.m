#import <CoreText/CTFontManager.h>
#import <Foundation/Foundation.h>

#import <Onyx2D/O2Font.h>

bool CTFontManagerRegisterFontsForURL(CFURLRef fontURL, CTFontManagerScope scope, CFErrorRef *error)
{
    NSURL *url = (NSURL*)fontURL;
    if(![url isFileURL]) {
        NSLog(@"Cannot register fonts: file url only");
        return NO;
    }

    NSString *path = [url path];
    NSString *name = [[path lastPathComponent] stringByDeletingPathExtension];
    [O2Font registerFont:path withName:name];
    return NO;
}
