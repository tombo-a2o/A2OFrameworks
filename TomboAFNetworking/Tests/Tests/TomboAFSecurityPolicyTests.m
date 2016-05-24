// TomboAFSecurityPolicyTests.m
// Copyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TomboAFTestCase.h"

#import "TomboAFSecurityPolicy.h"

@interface TomboAFSecurityPolicyTests : TomboAFTestCase
@end

static SecTrustRef TomboAFUTTrustChainForCertsInDirectory(NSString *directoryPath) {
    NSArray *certFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    NSMutableArray *certs  = [NSMutableArray arrayWithCapacity:[certFileNames count]];
    for (NSString *path in certFileNames) {
        NSData *certData = [NSData dataWithContentsOfFile:[directoryPath stringByAppendingPathComponent:path]];
        SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
        [certs addObject:(__bridge id)(cert)];
    }

    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust = NULL;
    SecTrustCreateWithCertificates((__bridge CFTypeRef)(certs), policy, &trust);
    CFRelease(policy);

    return trust;
}

static SecTrustRef TomboAFUTHTTPBinOrgServerTrust() {
    NSString *bundlePath = [[NSBundle bundleForClass:[TomboAFSecurityPolicyTests class]] resourcePath];
    NSString *serverCertDirectoryPath = [bundlePath stringByAppendingPathComponent:@"HTTPBinOrgServerTrustChain"];

    return TomboAFUTTrustChainForCertsInDirectory(serverCertDirectoryPath);
}

static SecTrustRef TomboAFUTADNNetServerTrust() {
    NSString *bundlePath = [[NSBundle bundleForClass:[TomboAFSecurityPolicyTests class]] resourcePath];
    NSString *serverCertDirectoryPath = [bundlePath stringByAppendingPathComponent:@"ADNNetServerTrustChain"];

    return TomboAFUTTrustChainForCertsInDirectory(serverCertDirectoryPath);
}

static SecCertificateRef TomboAFUTHTTPBinOrgCertificate() {
    NSString *certPath = [[NSBundle bundleForClass:[TomboAFSecurityPolicyTests class]] pathForResource:@"httpbinorg_01162016" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef TomboAFUTCOMODORSADomainValidationSecureServerCertificate() {
    NSString *certPath = [[NSBundle bundleForClass:[TomboAFSecurityPolicyTests class]] pathForResource:@"COMODO_RSA_Domain_Validation_Secure_Server_CA" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef TomboAFUTCOMODORSACertificate() {
    NSString *certPath = [[NSBundle bundleForClass:[TomboAFSecurityPolicyTests class]] pathForResource:@"COMODO_RSA_Certification_Authority" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef TomboAFUTAddTrustExternalRootCertificate() {
    NSString *certPath = [[NSBundle bundleForClass:[TomboAFSecurityPolicyTests class]] pathForResource:@"AddTrust_External_CA_Root" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef TomboAFUTSelfSignedCertificateWithoutDomain() {
    NSString *certPath = [[NSBundle bundleForClass:[TomboAFSecurityPolicyTests class]] pathForResource:@"NoDomains" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef TomboAFUTSelfSignedCertificateWithCommonNameDomain() {
    NSString *certPath = [[NSBundle bundleForClass:[TomboAFSecurityPolicyTests class]] pathForResource:@"foobar.com" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef TomboAFUTSelfSignedCertificateWithDNSNameDomain() {
    NSString *certPath = [[NSBundle bundleForClass:[TomboAFSecurityPolicyTests class]] pathForResource:@"AltName" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static NSArray * TomboAFCertificateTrustChainForServerTrust(SecTrustRef serverTrust) {
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    NSMutableArray *trustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];

    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, i);
        [trustChain addObject:(__bridge_transfer NSData *)SecCertificateCopyData(certificate)];
    }

    return [NSArray arrayWithArray:trustChain];
}

static SecTrustRef TomboAFUTTrustWithCertificate(SecCertificateRef certificate) {
    NSArray *certs  = [NSArray arrayWithObject:(__bridge id)(certificate)];

    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust = NULL;
    SecTrustCreateWithCertificates((__bridge CFTypeRef)(certs), policy, &trust);
    CFRelease(policy);

    return trust;
}

#pragma mark -

@implementation TomboAFSecurityPolicyTests

- (void)testLeafPublicKeyPinningIsEnforcedForHTTPBinOrgPinnedCertificateAgainstHTTPBinOrgServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];

    SecCertificateRef addtrustRootCertificate = TomboAFUTAddTrustExternalRootCertificate();
    SecCertificateRef comodoRsaCACertificate = TomboAFUTCOMODORSACertificate();
    SecCertificateRef comodoRsaDomainValidationCertificate = TomboAFUTCOMODORSADomainValidationSecureServerCertificate();
    SecCertificateRef httpBinCertificate = TomboAFUTHTTPBinOrgCertificate();

    [policy setPinnedCertificates:@[(__bridge_transfer NSData *)SecCertificateCopyData(addtrustRootCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaCACertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaDomainValidationCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate)]];

    CFRelease(addtrustRootCertificate);
    CFRelease(comodoRsaCACertificate);
    CFRelease(comodoRsaDomainValidationCertificate);
    CFRelease(httpBinCertificate);

    [policy setValidatesCertificateChain:NO];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:nil], @"HTTPBin.org Public Key Pinning Mode Failed");
    CFRelease(trust);
}

- (void)testPublicKeyChainPinningIsEnforcedForHTTPBinOrgPinnedCertificateAgainstHTTPBinOrgServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];

    SecTrustRef clientTrust = TomboAFUTHTTPBinOrgServerTrust();
    NSArray * certificates = TomboAFCertificateTrustChainForServerTrust(clientTrust);
    CFRelease(clientTrust);
    [policy setPinnedCertificates:certificates];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"], @"HTTPBin.org Public Key Pinning Mode Failed");
    CFRelease(trust);
}

- (void)testLeafCertificatePinningIsEnforcedForHTTPBinOrgPinnedCertificateAgainstHTTPBinOrgServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];

    SecCertificateRef addtrustRootCertificate = TomboAFUTAddTrustExternalRootCertificate();
    SecCertificateRef comodoRsaCACertificate = TomboAFUTCOMODORSACertificate();
    SecCertificateRef comodoRsaDomainValidationCertificate = TomboAFUTCOMODORSADomainValidationSecureServerCertificate();
    SecCertificateRef httpBinCertificate = TomboAFUTHTTPBinOrgCertificate();

    [policy setPinnedCertificates:@[(__bridge_transfer NSData *)SecCertificateCopyData(addtrustRootCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaCACertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaDomainValidationCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate)]];

    CFRelease(addtrustRootCertificate);
    CFRelease(comodoRsaCACertificate);
    CFRelease(comodoRsaDomainValidationCertificate);
    CFRelease(httpBinCertificate);

    [policy setValidatesCertificateChain:NO];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:nil], @"HTTPBin.org Public Key Pinning Mode Failed");
    CFRelease(trust);
}

- (void)testCertificateChainPinningIsEnforcedForHTTPBinOrgPinnedCertificateAgainstHTTPBinOrgServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    SecTrustRef clientTrust = TomboAFUTHTTPBinOrgServerTrust();
    NSArray * certificates = TomboAFCertificateTrustChainForServerTrust(clientTrust);
    CFRelease(clientTrust);
    [policy setPinnedCertificates:certificates];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"], @"HTTPBin.org Public Key Pinning Mode Failed");
    CFRelease(trust);
}

- (void)testNoPinningIsEnforcedForHTTPBinOrgPinnedCertificateAgainstHTTPBinOrgServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeNone];

    SecCertificateRef certificate = TomboAFUTHTTPBinOrgCertificate();
    [policy setPinnedCertificates:@[(__bridge_transfer NSData *)SecCertificateCopyData(certificate)]];
    CFRelease(certificate);
    [policy setAllowInvalidCertificates:YES];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"], @"HTTPBin.org Pinning should not have been enforced");
    CFRelease(trust);
}

- (void)testPublicKeyPinningFailsForHTTPBinOrgIfNoCertificateIsPinned {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];
    [policy setPinnedCertificates:@[]];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"] == NO, @"HTTPBin.org Public Key Pinning Should have failed with no pinned certificate");
    CFRelease(trust);
}

- (void)testCertificatePinningIsEnforcedForHTTPBinOrgPinnedCertificateWithDomainNameValidationAgainstHTTPBinOrgServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];

    SecCertificateRef addtrustRootCertificate = TomboAFUTAddTrustExternalRootCertificate();
    SecCertificateRef comodoRsaCACertificate = TomboAFUTCOMODORSACertificate();
    SecCertificateRef comodoRsaDomainValidationCertificate = TomboAFUTCOMODORSADomainValidationSecureServerCertificate();
    SecCertificateRef httpBinCertificate = TomboAFUTHTTPBinOrgCertificate();

    [policy setPinnedCertificates:@[(__bridge_transfer NSData *)SecCertificateCopyData(addtrustRootCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaCACertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaDomainValidationCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate)]];

    CFRelease(addtrustRootCertificate);
    CFRelease(comodoRsaCACertificate);
    CFRelease(comodoRsaDomainValidationCertificate);
    CFRelease(httpBinCertificate);

    policy.validatesDomainName = YES;

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"], @"HTTPBin.org Public Key Pinning Mode Failed");
    CFRelease(trust);
}

- (void)testCertificatePinningIsEnforcedForHTTPBinOrgPinnedCertificateWithCaseInsensitiveDomainNameValidationAgainstHTTPBinOrgServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];

    SecCertificateRef addtrustRootCertificate = TomboAFUTAddTrustExternalRootCertificate();
    SecCertificateRef comodoRsaCACertificate = TomboAFUTCOMODORSACertificate();
    SecCertificateRef comodoRsaDomainValidationCertificate = TomboAFUTCOMODORSADomainValidationSecureServerCertificate();
    SecCertificateRef httpBinCertificate = TomboAFUTHTTPBinOrgCertificate();

    [policy setPinnedCertificates:@[(__bridge_transfer NSData *)SecCertificateCopyData(addtrustRootCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaCACertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaDomainValidationCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate)]];

    CFRelease(addtrustRootCertificate);
    CFRelease(comodoRsaCACertificate);
    CFRelease(comodoRsaDomainValidationCertificate);
    CFRelease(httpBinCertificate);

    policy.validatesDomainName = YES;

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpBin.org"], @"HTTPBin.org Public Key Pinning Mode Failed");
    CFRelease(trust);
}

- (void)testCertificatePinningIsEnforcedForHTTPBinOrgPinnedPublicKeyWithDomainNameValidationAgainstHTTPBinOrgServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];

    SecCertificateRef addtrustRootCertificate = TomboAFUTAddTrustExternalRootCertificate();
    SecCertificateRef comodoRsaCACertificate = TomboAFUTCOMODORSACertificate();
    SecCertificateRef comodoRsaDomainValidationCertificate = TomboAFUTCOMODORSADomainValidationSecureServerCertificate();
    SecCertificateRef httpBinCertificate = TomboAFUTHTTPBinOrgCertificate();

    [policy setPinnedCertificates:@[(__bridge_transfer NSData *)SecCertificateCopyData(addtrustRootCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaCACertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(comodoRsaDomainValidationCertificate),
                                    (__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate)]];

    CFRelease(addtrustRootCertificate);
    CFRelease(comodoRsaCACertificate);
    CFRelease(comodoRsaDomainValidationCertificate);
    CFRelease(httpBinCertificate);

    policy.validatesDomainName = YES;

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"], @"HTTPBin.org Public Key Pinning Mode Failed");
    CFRelease(trust);
}

- (void)testCertificatePinningFailsForHTTPBinOrgIfNoCertificateIsPinned {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    [policy setPinnedCertificates:@[]];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"] == NO, @"HTTPBin.org Certificate Pinning Should have failed with no pinned certificate");
    CFRelease(trust);
}

- (void)testCertificatePinningFailsForHTTPBinOrgIfDomainNameDoesntMatch {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];
    SecCertificateRef certificate = TomboAFUTHTTPBinOrgCertificate();
    [policy setPinnedCertificates:@[(__bridge_transfer NSData *)SecCertificateCopyData(certificate)]];
    CFRelease(certificate);
    policy.validatesDomainName = YES;

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"www.httpbin.org"] == NO, @"HTTPBin.org Certificate Pinning Should have failed with no pinned certificate");
    CFRelease(trust);
}

- (void)testNoPinningIsEnforcedForHTTPBinOrgIfNoCertificateIsPinned {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeNone];
    [policy setPinnedCertificates:@[]];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"], @"HTTPBin.org Pinning should not have been enforced");
    CFRelease(trust);
}

- (void)testPublicKeyPinningForHTTPBinOrgFailsWhenPinnedAgainstADNServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];
    SecCertificateRef certificate = TomboAFUTHTTPBinOrgCertificate();
    [policy setPinnedCertificates:@[(__bridge_transfer NSData *)SecCertificateCopyData(certificate)]];
    [policy setValidatesCertificateChain:NO];

    SecTrustRef trust = TomboAFUTADNNetServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"] == NO, @"HTTPBin.org Public Key Pinning Should have failed against ADN");
    CFRelease(trust);
}

- (void)testCertificatePinningForHTTPBinOrgFailsWhenPinnedAgainstADNServerTrust {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    SecCertificateRef certificate = TomboAFUTHTTPBinOrgCertificate();
    [policy setPinnedCertificates:@[(__bridge_transfer NSData *)SecCertificateCopyData(certificate)]];
    [policy setValidatesCertificateChain:NO];

    SecTrustRef trust = TomboAFUTADNNetServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"] == NO, @"HTTPBin.org Certificate Pinning Should have failed against ADN");
    CFRelease(trust);
}

- (void)testDefaultPolicyContainsHTTPBinOrgCertificate {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy defaultPolicy];
    SecCertificateRef cert = TomboAFUTHTTPBinOrgCertificate();
    NSData *certData = (__bridge NSData *)(SecCertificateCopyData(cert));
    CFRelease(cert);
    NSInteger index = [policy.pinnedCertificates indexOfObjectPassingTest:^BOOL(NSData *data, NSUInteger idx, BOOL *stop) {
        return [data isEqualToData:certData];
    }];

    XCTAssert(index!=NSNotFound, @"HTTPBin.org certificate not found in the default certificates");
}

- (void)testCertificatePinningIsEnforcedWhenPinningSelfSignedCertificateWithoutDomain {
    SecCertificateRef certificate = TomboAFUTSelfSignedCertificateWithoutDomain();
    SecTrustRef trust = TomboAFUTTrustWithCertificate(certificate);

    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    policy.pinnedCertificates = @[ (__bridge_transfer id)SecCertificateCopyData(certificate) ];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"foo.bar"], @"Certificate should be trusted");

    CFRelease(trust);
    CFRelease(certificate);
}

- (void)testCertificatePinningWhenPinningSelfSignedCertificateWithoutDomain {
    SecCertificateRef certificate = TomboAFUTSelfSignedCertificateWithoutDomain();
    SecTrustRef trust = TomboAFUTTrustWithCertificate(certificate);

    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    policy.pinnedCertificates = @[ (__bridge_transfer id)SecCertificateCopyData(certificate) ];
    policy.allowInvalidCertificates = YES;
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"foo.bar"] == NO, @"Certificate should not be trusted");

    CFRelease(trust);
    CFRelease(certificate);
}

- (void)testCertificatePinningIsEnforcedWhenPinningSelfSignedCertificateWithCommonNameDomain {
    SecCertificateRef certificate = TomboAFUTSelfSignedCertificateWithCommonNameDomain();
    SecTrustRef trust = TomboAFUTTrustWithCertificate(certificate);

    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    policy.pinnedCertificates = @[ (__bridge_transfer id)SecCertificateCopyData(certificate) ];
    policy.allowInvalidCertificates = YES;
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Certificate should be trusted");

    CFRelease(trust);
    CFRelease(certificate);
}

- (void)testCertificatePinningWhenPinningSelfSignedCertificateWithCommonNameDomain {
    SecCertificateRef certificate = TomboAFUTSelfSignedCertificateWithCommonNameDomain();
    SecTrustRef trust = TomboAFUTTrustWithCertificate(certificate);

    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    policy.pinnedCertificates = @[ (__bridge_transfer id)SecCertificateCopyData(certificate) ];
    policy.allowInvalidCertificates = YES;
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"foo.bar"] == NO, @"Certificate should not be trusted");

    CFRelease(trust);
    CFRelease(certificate);
}

- (void)testCertificatePinningIsEnforcedWhenPinningSelfSignedCertificateWithDNSNameDomain {
    SecCertificateRef certificate = TomboAFUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = TomboAFUTTrustWithCertificate(certificate);

    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    policy.pinnedCertificates = @[ (__bridge_transfer id)SecCertificateCopyData(certificate) ];
    policy.allowInvalidCertificates = YES;
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Certificate should be trusted");

    CFRelease(trust);
    CFRelease(certificate);
}

- (void)testCertificatePinningWhenPinningSelfSignedCertificateWithDNSNameDomain {
    SecCertificateRef certificate = TomboAFUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = TomboAFUTTrustWithCertificate(certificate);

    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    policy.pinnedCertificates = @[ (__bridge_transfer id)SecCertificateCopyData(certificate) ];
    policy.allowInvalidCertificates = YES;
    XCTAssert([policy evaluateServerTrust:trust forDomain:@"foo.bar"] == NO, @"Certificate should not be trusted");

    CFRelease(trust);
    CFRelease(certificate);
}

- (void)testDefaultPolicySetToCertificateChain {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    SecTrustRef trust = TomboAFUTADNNetServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:nil], @"Pinning with Default Certficiate Chain Failed");
    CFRelease(trust);
}

- (void)testDefaultPolicySetToLeafCertificate {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];
    [policy setValidatesCertificateChain:NO];
    SecTrustRef trust = TomboAFUTADNNetServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:nil], @"Pinning with Default Leaf Certficiate Failed");
    CFRelease(trust);
}

- (void)testDefaultPolicySetToPublicKeyChain {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];
    SecTrustRef trust = TomboAFUTADNNetServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:nil], @"Pinning with Default Public Key Chain Failed");
    CFRelease(trust);
}

- (void)testDefaultPolicySetToLeafPublicKey {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];
    [policy setValidatesCertificateChain:NO];
    SecTrustRef trust = TomboAFUTADNNetServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:nil], @"Pinning with Default Leaf Public Key Failed");
    CFRelease(trust);
}

- (void)testDefaultPolicySetToCertificateChainFailsWithMissingChain {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeCertificate];

    // By default the cer files are picked up from the bundle, this forces them to be cleared to emulate having none available
    [policy setPinnedCertificates:@[]];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:nil] == NO, @"Pinning with Certificate Chain Mode and Missing Chain should have failed");
    CFRelease(trust);
}

- (void)testDefaultPolicySetToPublicKeyChainFailsWithMissingChain {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];

    // By default the cer files are picked up from the bundle, this forces them to be cleared to emulate having none available
    [policy setPinnedCertificates:@[]];

    SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
    XCTAssert([policy evaluateServerTrust:trust forDomain:nil] == NO, @"Pinning with Public Key Chain Mode and Missing Chain should have failed");
    CFRelease(trust);
}

- (void)testDefaultPolicyIsSetToTomboAFSSLPinningModeNone {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy defaultPolicy];

    XCTAssert(policy.SSLPinningMode==TomboAFSSLPinningModeNone, @"Default policy is not set to TomboAFSSLPinningModeNone.");
}

- (void)testDefaultPolicyMatchesTrustedCertificateWithMatchingHostnameAndRejectsOthers {
    {
        //check non-trusted certificate, incorrect domain
        TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy defaultPolicy];
        SecTrustRef trust = TomboAFUTTrustWithCertificate(TomboAFUTSelfSignedCertificateWithCommonNameDomain());
        XCTAssert([policy evaluateServerTrust:trust forDomain:@"different.foobar.com"] == NO, @"Invalid certificate with mismatching domain should fail");
        CFRelease(trust);
    }
    {
        //check non-trusted certificate, correct domain
        TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy defaultPolicy];
        SecTrustRef trust = TomboAFUTTrustWithCertificate(TomboAFUTSelfSignedCertificateWithCommonNameDomain());
        XCTAssert([policy evaluateServerTrust:trust forDomain:@"foobar.com"] == NO, @"Invalid certificate with matching domain should fail");
        CFRelease(trust);
    }
    {
        //check trusted certificate, wrong domain
        TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy defaultPolicy];
        SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
        XCTAssert([policy evaluateServerTrust:trust forDomain:@"nothttpbin.org"] == NO, @"Valid certificate with mismatching domain should fail");
        CFRelease(trust);
    }
    {
        //check trusted certificate, correct domain
        TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy defaultPolicy];
        SecTrustRef trust = TomboAFUTHTTPBinOrgServerTrust();
        XCTAssert([policy evaluateServerTrust:trust forDomain:@"httpbin.org"] == YES, @"Valid certificate with matching domain should pass");
        CFRelease(trust);
    }
}

- (void)testDefaultPolicyIsSetToNotAllowInvalidSSLCertificates {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy defaultPolicy];

    XCTAssert(policy.allowInvalidCertificates == NO, @"Default policy should not allow invalid ssl certificates");
}

- (void)testPolicyWithPinningModeIsSetToNotAllowInvalidSSLCertificates {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeNone];

    XCTAssert(policy.allowInvalidCertificates == NO, @"policyWithPinningMode: should not allow invalid ssl certificates by default.");
}

- (void)testPolicyWithPinningModeIsSetToValidatesDomainName {
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModeNone];

    XCTAssert(policy.validatesDomainName == YES, @"policyWithPinningMode: should validate domain names by default.");
}

- (void)testThatSSLPinningPolicyClassMethodContainsDefaultCertificates{
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy policyWithPinningMode:TomboAFSSLPinningModePublicKey];
    [policy setValidatesCertificateChain:NO];
    XCTAssertNotNil(policy.pinnedCertificates, @"Default certificate array should not be empty for SSL pinning mode policy");
}

- (void)testThatDefaultPinningPolicyClassMethodContainsNoDefaultCertificates{
    TomboAFSecurityPolicy *policy = [TomboAFSecurityPolicy defaultPolicy];
    XCTAssertNil(policy.pinnedCertificates, @"Default certificate array should be empty for default policy.");
}

@end
