#import <Security/SecTrust.h>

SecCertificateRef SecCertificateCreateWithData ( CFAllocatorRef allocator, CFDataRef data )
{
    printf("%s is not implemented\n", __FUNCTION__);
    return NULL;
}

SecKeyRef SecTrustCopyPublicKey(SecTrustRef trust)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return NULL;
}

OSStatus SecTrustCreateWithCertificates(CFTypeRef certificates, CFTypeRef policies, SecTrustRef *trust)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return -1;
}

OSStatus SecTrustEvaluate(SecTrustRef trust, SecTrustResultType *result)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return -1;
}

SecCertificateRef SecTrustGetCertificateAtIndex(SecTrustRef trust, CFIndex ix)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return NULL;
}

CFIndex SecTrustGetCertificateCount(SecTrustRef trust)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return -1;
}

OSStatus SecTrustSetAnchorCertificates(SecTrustRef trust, CFArrayRef anchorCertificates)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return -1;
}

OSStatus SecTrustSetPolicies(SecTrustRef trust, CFTypeRef policies)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return -1;
}
