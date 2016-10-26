#import <Security/SecPolicy.h>
#import <stdio.h>

SecPolicyRef SecPolicyCreateBasicX509(void)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return NULL;
}

SecPolicyRef SecPolicyCreateSSL(Boolean server, CFStringRef hostname)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return NULL;
}
