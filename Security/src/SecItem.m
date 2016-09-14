#import <Security/SecItem.h>
#import <stdio.h>
#import <Foundation/Foundation.h>

OSStatus SecItemCopyMatching(CFDictionaryRef query, CFTypeRef *result)
{
    fprintf(stderr, "%s not implemented\n", __FUNCTION__);
    *result = [[NSDictionary alloc] init];
    return errSecItemNotFound;
}

OSStatus SecItemAdd(CFDictionaryRef attributes, CFTypeRef *result)
{
    return 1;
}
