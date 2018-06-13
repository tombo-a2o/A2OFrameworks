/*
 *  SecTrust.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
