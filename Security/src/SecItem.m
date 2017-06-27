#import <Security/SecItem.h>
#import <stdio.h>
#import <Foundation/Foundation.h>

OSStatus SecItemCopyMatching(CFDictionaryRef _query, CFTypeRef *_result)
{
    NSDictionary *query = _query;

    NSLog(@"%s: %@", __FUNCTION__, query);

    // currently supports only kSecClass=kSecClassGenericPassword and kSecReturnAttributes=true
    NSObject *secClass = [query objectForKey:kSecClass];
    assert(secClass == kSecClassGenericPassword);
    NSNumber *returnData = [query objectForKey:kSecReturnData];
    NSNumber *returnAttributes = [query objectForKey:kSecReturnAttributes];
    NSNumber *returnRef = [query objectForKey:kSecReturnRef];
    NSNumber *returnPersistentRef = [query objectForKey:kSecReturnPersistentRef];
    // assert(![returnData boolValue]);
    // assert([returnAttributes boolValue]);
    // assert(![returnRef boolValue]);
    // assert(![returnPersistentRef boolValue]);

    NSString *service = [query objectForKey:kSecAttrService];
    NSString *account = [query objectForKey:kSecAttrAccount];
    NSLog(@"%s query: %@", __FUNCTION__, query);


    NSDictionary *result = [[NSDictionary alloc] init];
    *_result = result;
    return errSecItemNotFound;
}

OSStatus SecItemAdd(CFDictionaryRef _attributes, CFTypeRef *result)
{
    NSDictionary *attributes = _attributes;

    // currently supports only kSecClass=kSecClassGenericPassword
    NSObject *secClass = [attributes objectForKey:kSecClass];
    assert(secClass == kSecClassGenericPassword);

    NSString *service = [attributes objectForKey:kSecAttrService];
    NSString *account = [attributes objectForKey:kSecAttrAccount];
    NSLog(@"%s attributes: %@", __FUNCTION__, attributes);
    return 0;
}
