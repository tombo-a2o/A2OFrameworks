#import <Security/SecSharedCredential.h>
#import <Foundation/Foundation.h>



void SecAddSharedWebCredential(CFStringRef fqdn, CFStringRef account, CFStringRef password, void (^completionHandler)(CFErrorRef error))
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    completionHandler(NULL);
}

void SecRequestSharedWebCredential(CFStringRef fqdn, CFStringRef account, void (^completionHandler)(CFArrayRef credentials, CFErrorRef error))
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    completionHandler(NULL, NULL);
}

CFStringRef SecCreateSharedWebCredentialPassword(void)
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return NULL;
}
