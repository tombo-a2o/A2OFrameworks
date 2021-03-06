// TomboAFJSONRequestOperationTests.m
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

#import "TomboAFNetworkingTests.h"
#import "TomboAFURLConnectionOperation.h"
#import "TomboAFMockURLProtocol.h"

@interface TomboAFURLConnectionOperationTests : SenTestCase
@property (readwrite, nonatomic, strong) NSURL *baseURL;
@end

@implementation TomboAFURLConnectionOperationTests

- (void)setUp {
    self.baseURL = [NSURL URLWithString:TomboAFNetworkingTestsBaseURLString];
}

#pragma mark -

- (void)testThatTomboAFURLConnectionOperationInvokesWillSendRequestForAuthenticationChallengeBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/path" relativeToURL:self.baseURL]];
    TomboAFURLConnectionOperation *operation = [[TomboAFURLConnectionOperation alloc] initWithRequest:request];

    __block BOOL willSendRequestForAuthenticationChallengeBlockInvoked = NO;
    [operation setWillSendRequestForAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
        willSendRequestForAuthenticationChallengeBlockInvoked = YES;
    }];

    [TomboAFMockURLProtocol handleNextRequestForURL:request.URL usingBlock:^(TomboAFMockURLProtocol <TomboAFMockURLProtocolProxy> * protocol) {

        void(^startOperation)(NSInvocation *invocation) = ^(NSInvocation *invocation) {
            __unsafe_unretained TomboAFMockURLProtocol *protocol = nil;
            [invocation getArgument:&protocol atIndex:0];

            NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:request.URL.host port:request.URL.port.integerValue protocol:request.URL.scheme realm:nil authenticationMethod:NSURLAuthenticationMethodDefault];
            NSURLAuthenticationChallenge *authenticationChallenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:nil previousFailureCount:0 failureResponse:nil error:nil sender:protocol];
            [protocol.client URLProtocol:protocol didReceiveAuthenticationChallenge:authenticationChallenge];
        };
        [[[protocol stub] andDo:startOperation] startLoading];
    }];

    [operation start];
    expect(willSendRequestForAuthenticationChallengeBlockInvoked).will.beTruthy();

    [operation cancel];
}

- (void)testThatTomboAFURLConnectionOperationTrustsPinnedCertificates {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/path" relativeToURL:self.baseURL]];
    TomboAFURLConnectionOperation *operation = [[TomboAFURLConnectionOperation alloc] initWithRequest:request];
    operation.SSLPinningMode = TomboAFSSLPinningModeCertificate;

    __block BOOL useCredentialInvoked = NO;

    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:request.URL.host port:request.URL.port.integerValue protocol:request.URL.scheme realm:nil authenticationMethod:NSURLAuthenticationMethodServerTrust];

    NSData *certificateData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"root_certificate" ofType:@"cer"]];
    NSParameterAssert(certificateData);

    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData);
    NSParameterAssert(certificate);

    SecCertificateRef allowedCertificates[] = {certificate};
    CFArrayRef certificates = CFArrayCreate(NULL, (const void **)allowedCertificates, 1, NULL);

    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust = NULL;
    OSStatus status = SecTrustCreateWithCertificates(certificates, policy, &trust);
    NSAssert(status == errSecSuccess, @"SecTrustCreateWithCertificates error: %ld", (long int)status);

    SecTrustResultType result;
    status = SecTrustEvaluate(trust, &result);
    NSAssert(status == errSecSuccess, @"SecTrustEvaluate error: %ld", (long int)status);

    id mockedProtectionSpace = [OCMockObject partialMockForObject:protectionSpace];

    [[[mockedProtectionSpace stub] andDo:^(NSInvocation *invocation) {
        [invocation setReturnValue:(void *)&trust];
    }] serverTrust];

    TomboAFMockURLProtocol *protocol = [[TomboAFMockURLProtocol alloc] initWithRequest:request cachedResponse:nil client:nil];
    id mockedProtocol = [OCMockObject partialMockForObject:protocol];

    void(^useCredential)(NSInvocation *invocation) = ^(NSInvocation *invocation) {
        useCredentialInvoked = YES;
    };

    [[[mockedProtocol stub] andDo:useCredential] useCredential:OCMOCK_ANY forAuthenticationChallenge:OCMOCK_ANY];

    NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:trust];
    NSURLAuthenticationChallenge *authenticationChallenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:credential previousFailureCount:0 failureResponse:nil error:nil sender:mockedProtocol];
    [protocol.client URLProtocol:mockedProtocol didReceiveAuthenticationChallenge:authenticationChallenge];

    [operation connection:nil willSendRequestForAuthenticationChallenge:authenticationChallenge];

    CFRelease(trust);
    CFRelease(policy);
    CFRelease(certificates);
    CFRelease(certificate);

    expect(useCredentialInvoked).will.beTruthy();
}

- (void)testThatTomboAFURLConnectionOperationTrustsPinnedPublicKeys {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/path" relativeToURL:self.baseURL]];
    TomboAFURLConnectionOperation *operation = [[TomboAFURLConnectionOperation alloc] initWithRequest:request];
    operation.SSLPinningMode = TomboAFSSLPinningModePublicKey;

    __block BOOL useCredentialInvoked = NO;

    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:request.URL.host port:request.URL.port.integerValue protocol:request.URL.scheme realm:nil authenticationMethod:NSURLAuthenticationMethodServerTrust];

    NSData *certificateData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"root_certificate" ofType:@"cer"]];
    NSParameterAssert(certificateData);

    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData);
    NSParameterAssert(certificate);

    SecCertificateRef allowedCertificates[] = {certificate};
    CFArrayRef certificates = CFArrayCreate(NULL, (const void **)allowedCertificates, 1, NULL);

    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust = NULL;
    OSStatus status = SecTrustCreateWithCertificates(certificates, policy, &trust);
    NSAssert(status == errSecSuccess, @"SecTrustCreateWithCertificates error: %ld", (long int)status);

    SecTrustResultType result;
    status = SecTrustEvaluate(trust, &result);
    NSAssert(status == errSecSuccess, @"SecTrustEvaluate error: %ld", (long int)status);

    id mockedProtectionSpace = [OCMockObject partialMockForObject:protectionSpace];

    [[[mockedProtectionSpace stub] andDo:^(NSInvocation *invocation) {
        [invocation setReturnValue:(void *)&trust];
    }] serverTrust];

    TomboAFMockURLProtocol *protocol = [[TomboAFMockURLProtocol alloc] initWithRequest:request cachedResponse:nil client:nil];
    id mockedProtocol = [OCMockObject partialMockForObject:protocol];

    void(^useCredential)(NSInvocation *invocation) = ^(NSInvocation *invocation) {
        useCredentialInvoked = YES;
    };

    [[[mockedProtocol stub] andDo:useCredential] useCredential:OCMOCK_ANY forAuthenticationChallenge:OCMOCK_ANY];

    NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:trust];
    NSURLAuthenticationChallenge *authenticationChallenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:credential previousFailureCount:0 failureResponse:nil error:nil sender:mockedProtocol];
    [protocol.client URLProtocol:mockedProtocol didReceiveAuthenticationChallenge:authenticationChallenge];

    [operation connection:nil willSendRequestForAuthenticationChallenge:authenticationChallenge];

    CFRelease(trust);
    CFRelease(policy);
    CFRelease(certificates);
    CFRelease(certificate);

    expect(useCredentialInvoked).will.beTruthy();
}

- (void)testThatTomboAFURLConnectionOperationTrustsPublicKeysOfDerivedCertificates {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/path" relativeToURL:self.baseURL]];
    TomboAFURLConnectionOperation *operation = [[TomboAFURLConnectionOperation alloc] initWithRequest:request];
    operation.SSLPinningMode = TomboAFSSLPinningModePublicKey;

    __block BOOL useCredentialInvoked = NO;

    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:request.URL.host port:request.URL.port.integerValue protocol:request.URL.scheme realm:nil authenticationMethod:NSURLAuthenticationMethodServerTrust];

    NSData *caCertificateData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"ca" ofType:@"cer"]];
    NSParameterAssert(caCertificateData);

    SecCertificateRef caCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCertificateData);
    NSParameterAssert(caCertificate);

    NSData *hostCertificateData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"derived" ofType:@"cert"]];
    NSParameterAssert(hostCertificateData);

    SecCertificateRef hostCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCertificateData);
    NSParameterAssert(hostCertificate);

    SecCertificateRef allowedCertificates[] = {caCertificate, hostCertificate};
    CFArrayRef certificates = CFArrayCreate(NULL, (const void **)allowedCertificates, 2, NULL);

    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust = NULL;
    OSStatus status = SecTrustCreateWithCertificates(certificates, policy, &trust);
    NSAssert(status == errSecSuccess, @"SecTrustCreateWithCertificates error: %ld", (long int)status);

    SecTrustResultType result;
    status = SecTrustEvaluate(trust, &result);
    NSAssert(status == errSecSuccess, @"SecTrustEvaluate error: %ld", (long int)status);

    id mockedProtectionSpace = [OCMockObject partialMockForObject:protectionSpace];

    [[[mockedProtectionSpace stub] andDo:^(NSInvocation *invocation) {
        [invocation setReturnValue:(void *)&trust];
    }] serverTrust];

    TomboAFMockURLProtocol *protocol = [[TomboAFMockURLProtocol alloc] initWithRequest:request cachedResponse:nil client:nil];
    id mockedProtocol = [OCMockObject partialMockForObject:protocol];

    void(^useCredential)(NSInvocation *invocation) = ^(NSInvocation *invocation) {
        useCredentialInvoked = YES;
    };

    [[[mockedProtocol stub] andDo:useCredential] useCredential:OCMOCK_ANY forAuthenticationChallenge:OCMOCK_ANY];

    NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:trust];
    NSURLAuthenticationChallenge *authenticationChallenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:credential previousFailureCount:0 failureResponse:nil error:nil sender:mockedProtocol];
    [protocol.client URLProtocol:mockedProtocol didReceiveAuthenticationChallenge:authenticationChallenge];

    [operation connection:nil willSendRequestForAuthenticationChallenge:authenticationChallenge];

    CFRelease(trust);
    CFRelease(policy);
    CFRelease(certificates);
    CFRelease(caCertificate);
    CFRelease(hostCertificate);

    expect(useCredentialInvoked).will.beTruthy();
}

- (void)testThatTomboAFURLConnectionOperationTrustsDerivedCertificates {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/path" relativeToURL:self.baseURL]];
    TomboAFURLConnectionOperation *operation = [[TomboAFURLConnectionOperation alloc] initWithRequest:request];
    operation.SSLPinningMode = TomboAFSSLPinningModeCertificate;

    __block BOOL useCredentialInvoked = NO;

    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:request.URL.host port:request.URL.port.integerValue protocol:request.URL.scheme realm:nil authenticationMethod:NSURLAuthenticationMethodServerTrust];

    NSData *caCertificateData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"ca" ofType:@"cer"]];
    NSParameterAssert(caCertificateData);

    SecCertificateRef caCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCertificateData);
    NSParameterAssert(caCertificate);

    NSData *hostCertificateData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"derived" ofType:@"cert"]];
    NSParameterAssert(hostCertificateData);

    SecCertificateRef hostCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCertificateData);
    NSParameterAssert(hostCertificate);

    SecCertificateRef allowedCertificates[] = {caCertificate, hostCertificate};
    CFArrayRef certificates = CFArrayCreate(NULL, (const void **)allowedCertificates, 2, NULL);

    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust = NULL;
    OSStatus status = SecTrustCreateWithCertificates(certificates, policy, &trust);
    NSAssert(status == errSecSuccess, @"SecTrustCreateWithCertificates error: %ld", (long int)status);

    SecTrustResultType result;
    status = SecTrustEvaluate(trust, &result);
    NSAssert(status == errSecSuccess, @"SecTrustEvaluate error: %ld", (long int)status);

    id mockedProtectionSpace = [OCMockObject partialMockForObject:protectionSpace];

    [[[mockedProtectionSpace stub] andDo:^(NSInvocation *invocation) {
        [invocation setReturnValue:(void *)&trust];
    }] serverTrust];

    TomboAFMockURLProtocol *protocol = [[TomboAFMockURLProtocol alloc] initWithRequest:request cachedResponse:nil client:nil];
    id mockedProtocol = [OCMockObject partialMockForObject:protocol];

    void(^useCredential)(NSInvocation *invocation) = ^(NSInvocation *invocation) {
        useCredentialInvoked = YES;
    };

    [[[mockedProtocol stub] andDo:useCredential] useCredential:OCMOCK_ANY forAuthenticationChallenge:OCMOCK_ANY];

    NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:trust];
    NSURLAuthenticationChallenge *authenticationChallenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:credential previousFailureCount:0 failureResponse:nil error:nil sender:mockedProtocol];
    [protocol.client URLProtocol:mockedProtocol didReceiveAuthenticationChallenge:authenticationChallenge];

    [operation connection:nil willSendRequestForAuthenticationChallenge:authenticationChallenge];

    CFRelease(trust);
    CFRelease(policy);
    CFRelease(certificates);
    CFRelease(caCertificate);
    CFRelease(hostCertificate);

    expect(useCredentialInvoked).will.beTruthy();
}

@end
