#ifndef _SECURITY_SECSHAREDCRED_H_
#define _SECURITY_SECSHAREDCRED_H_

#include <Security/SecBase.h>
#include <CoreFoundation/CFString.h>
#include <CoreFoundation/CFError.h>

extern const CFStringRef kSecSharedPassword;

void SecAddSharedWebCredential(CFStringRef fqdn, CFStringRef account, CFStringRef password, void (^completionHandler)(CFErrorRef error));
void SecRequestSharedWebCredential(CFStringRef fqdn, CFStringRef account, void (^completionHandler)(CFArrayRef credentials, CFErrorRef error));
CFStringRef SecCreateSharedWebCredentialPassword(void);

#endif
