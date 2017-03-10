// TomboAFJSONSerializationTests.m
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

#import "TomboAFURLRequestSerialization.h"
#import "TomboAFURLResponseSerialization.h"

static NSData * TomboAFJSONTestData() {
    return [NSJSONSerialization dataWithJSONObject:@{@"foo": @"bar"} options:0 error:nil];
}

#pragma mark -

@interface TomboAFJSONRequestSerializationTests : TomboAFTestCase
@property (nonatomic, strong) TomboAFJSONRequestSerializer *requestSerializer;
@end

@implementation TomboAFJSONRequestSerializationTests

- (void)setUp {
    self.requestSerializer = [[TomboAFJSONRequestSerializer alloc] init];
}

#pragma mark -

- (void)testThatJSONRequestSerializationHandlesParametersDictionary {
    NSDictionary *parameters = @{@"key":@"value"};
    NSError *error = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:TomboAFNetworkingTestsBaseURLString parameters:parameters error:&error];

    XCTAssertNil(error, @"Serialization error should be nil");

    NSString *body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];

    XCTAssertTrue([@"{\"key\":\"value\"}" isEqualToString:body], @"Parameters were not encoded correctly");
}

- (void)testThatJSONRequestSerializationHandlesParametersArray {
    NSArray *parameters = @[@{@"key":@"value"}];
    NSError *error = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:TomboAFNetworkingTestsBaseURLString parameters:parameters error:&error];

    XCTAssertNil(error, @"Serialization error should be nil");

    NSString *body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];

    XCTAssertTrue([@"[{\"key\":\"value\"}]" isEqualToString:body], @"Parameters were not encoded correctly");
}

@end

#pragma mark -

@interface TomboAFJSONResponseSerializationTests : TomboAFTestCase
@property (nonatomic, strong) TomboAFJSONResponseSerializer *responseSerializer;
@end

@implementation TomboAFJSONResponseSerializationTests

- (void)setUp {
    [super setUp];
    self.responseSerializer = [TomboAFJSONResponseSerializer serializer];
}

#pragma mark -

- (void)testThatJSONResponseSerializerAcceptsApplicationJSONMimeType {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.baseURL statusCode:200 HTTPVersion:@"1.1" headerFields:@{@"Content-Type": @"application/json"}];

    NSError *error = nil;
    [self.responseSerializer validateResponse:response data:TomboAFJSONTestData() error:&error];

    XCTAssertNil(error, @"Error handling application/json");
}

- (void)testThatJSONResponseSerializerAcceptsTextJSONMimeType {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.baseURL statusCode:200 HTTPVersion:@"1.1" headerFields:@{@"Content-Type": @"text/json"}];
    NSError *error = nil;
    [self.responseSerializer validateResponse:response data:TomboAFJSONTestData()error:&error];

    XCTAssertNil(error, @"Error handling text/json");
}

- (void)testThatJSONResponseSerializerAcceptsTextJavaScriptMimeType {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.baseURL statusCode:200 HTTPVersion:@"1.1" headerFields:@{@"Content-Type": @"text/javascript"}];
    NSError *error = nil;
    [self.responseSerializer validateResponse:response data:TomboAFJSONTestData() error:&error];

    XCTAssertNil(error, @"Error handling text/javascript");
}

- (void)testThatJSONResponseSerializerDoesNotAcceptNonStandardJSONMimeType {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.baseURL statusCode:200 HTTPVersion:@"1.1" headerFields:@{@"Content-Type": @"nonstandard/json"}];
    NSError *error = nil;
    [self.responseSerializer validateResponse:response data:TomboAFJSONTestData() error:&error];

    XCTAssertNotNil(error, @"Error should have been thrown for nonstandard/json");
}

- (void)testThatJSONResponseSerializerReturnsDictionaryForValidJSONDictionary {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.baseURL statusCode:200 HTTPVersion:@"1.1" headerFields:@{@"Content-Type": @"text/json"}];
    NSError *error = nil;
    id responseObject = [self.responseSerializer responseObjectForResponse:response data:TomboAFJSONTestData() error:&error];

    XCTAssertNil(error, @"Serialization error should be nil");
    XCTAssert([responseObject isKindOfClass:[NSDictionary class]], @"Expected response to be a NSDictionary");
}

- (void)testThatJSONResponseSerializerReturnsErrorForInvalidJSON {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.baseURL statusCode:200 HTTPVersion:@"1.1" headerFields:@{@"Content-Type":@"text/json"}];
    NSError *error = nil;
    [self.responseSerializer responseObjectForResponse:response data:[@"{invalid}" dataUsingEncoding:NSUTF8StringEncoding] error:&error];

    XCTAssertNotNil(error, @"Serialization error should not be nil");
}

@end
