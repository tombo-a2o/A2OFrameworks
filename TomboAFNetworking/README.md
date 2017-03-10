<p align="center" >
  <img src="https://raw.github.com/TomboAFNetworking/TomboAFNetworking/assets/afnetworking-logo.png" alt="TomboAFNetworking" title="TomboAFNetworking">
</p>

[![Build Status](https://travis-ci.org/TomboAFNetworking/TomboAFNetworking.svg)](https://travis-ci.org/TomboAFNetworking/TomboAFNetworking)

TomboAFNetworking is a delightful networking library for iOS and Mac OS X. It's built on top of the [Foundation URL Loading System](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html), extending the powerful high-level networking abstractions built into Cocoa. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use.

Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to TomboAFNetworking every day. TomboAFNetworking powers some of the most popular and critically-acclaimed apps on the iPhone, iPad, and Mac.

Choose TomboAFNetworking for your next project, or migrate over your existing projects—you'll be happy you did!

## How To Get Started

- [Download TomboAFNetworking](https://github.com/TomboAFNetworking/TomboAFNetworking/archive/master.zip) and try out the included Mac and iPhone example apps
- Read the ["Getting Started" guide](https://github.com/TomboAFNetworking/TomboAFNetworking/wiki/Getting-Started-with-TomboAFNetworking), [FAQ](https://github.com/TomboAFNetworking/TomboAFNetworking/wiki/TomboAFNetworking-FAQ), or [other articles on the Wiki](https://github.com/TomboAFNetworking/TomboAFNetworking/wiki)
- Check out the [documentation](http://cocoadocs.org/docsets/TomboAFNetworking/) for a comprehensive look at all of the APIs available in TomboAFNetworking
- Read the [TomboAFNetworking 2.0 Migration Guide](https://github.com/TomboAFNetworking/TomboAFNetworking/wiki/TomboAFNetworking-2.0-Migration-Guide) for an overview of the architectural changes from 1.0.

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/afnetworking). (Tag 'afnetworking')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/afnetworking).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like TomboAFNetworking in your projects. See the ["Getting Started" guide for more information](https://github.com/TomboAFNetworking/TomboAFNetworking/wiki/Getting-Started-with-TomboAFNetworking).

#### Podfile

```ruby
platform :ios, '7.0'
pod "TomboAFNetworking", "~> 2.0"
```

## Requirements

| TomboAFNetworking Version | Minimum iOS Target  | Minimum OS X Target  |                                   Notes                                   |
|:--------------------:|:---------------------------:|:----------------------------:|:-------------------------------------------------------------------------:|
|          2.x         |            iOS 6            |           OS X 10.8          | Xcode 5 is required. `NSURLSession` subspec requires iOS 7 or OS X 10.9. |
|          [1.x](https://github.com/TomboAFNetworking/TomboAFNetworking/tree/1.x)         |            iOS 5            |         Mac OS X 10.7        |                                                                           |
|        [0.10.x](https://github.com/TomboAFNetworking/TomboAFNetworking/tree/0.10.x)        |            iOS 4            |         Mac OS X 10.6        |                                                                           |

(OS X projects must support [64-bit with modern Cocoa runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtVersionsPlatforms.html)).

> Programming in Swift? Try [Alamofire](https://github.com/Alamofire/Alamofire) for a more conventional set of APIs.

## Architecture

### NSURLConnection

- `TomboAFURLConnectionOperation`
- `TomboAFHTTPRequestOperation`
- `TomboAFHTTPRequestOperationManager`

### NSURLSession _(iOS 7 / Mac OS X 10.9)_

- `TomboAFURLSessionManager`
- `TomboAFHTTPSessionManager`

### Serialization

* `<TomboAFURLRequestSerialization>`
  - `TomboAFHTTPRequestSerializer`
  - `TomboAFJSONRequestSerializer`
  - `TomboAFPropertyListRequestSerializer`
* `<TomboAFURLResponseSerialization>`
  - `TomboAFHTTPResponseSerializer`
  - `TomboAFJSONResponseSerializer`
  - `TomboAFXMLParserResponseSerializer`
  - `TomboAFXMLDocumentResponseSerializer` _(Mac OS X)_
  - `TomboAFPropertyListResponseSerializer`
  - `TomboAFImageResponseSerializer`
  - `TomboAFCompoundResponseSerializer`

### Additional Functionality

- `TomboAFSecurityPolicy`
- `TomboAFNetworkReachabilityManager`

## Usage

### HTTP Request Operation Manager

`TomboAFHTTPRequestOperationManager` encapsulates the common patterns of communicating with a web application over HTTP, including request creation, response serialization, network reachability monitoring, and security, as well as request operation management.

#### `GET` Request

```objective-c
TomboAFHTTPRequestOperationManager *manager = [TomboAFHTTPRequestOperationManager manager];
[manager GET:@"http://example.com/resources.json" parameters:nil success:^(TomboAFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
} failure:^(TomboAFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
}];
```

#### `POST` URL-Form-Encoded Request

```objective-c
TomboAFHTTPRequestOperationManager *manager = [TomboAFHTTPRequestOperationManager manager];
NSDictionary *parameters = @{@"foo": @"bar"};
[manager POST:@"http://example.com/resources.json" parameters:parameters success:^(TomboAFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
} failure:^(TomboAFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
}];
```

#### `POST` Multi-Part Request

```objective-c
TomboAFHTTPRequestOperationManager *manager = [TomboAFHTTPRequestOperationManager manager];
NSDictionary *parameters = @{@"foo": @"bar"};
NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
[manager POST:@"http://example.com/resources.json" parameters:parameters constructingBodyWithBlock:^(id<TomboAFMultipartFormData> formData) {
    [formData appendPartWithFileURL:filePath name:@"image" error:nil];
} success:^(TomboAFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Success: %@", responseObject);
} failure:^(TomboAFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
}];
```

---

### TomboAFURLSessionManager

`TomboAFURLSessionManager` creates and manages an `NSURLSession` object based on a specified `NSURLSessionConfiguration` object, which conforms to `<NSURLSessionTaskDelegate>`, `<NSURLSessionDataDelegate>`, `<NSURLSessionDownloadDelegate>`, and `<NSURLSessionDelegate>`.

#### Creating a Download Task

```objective-c
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
TomboAFURLSessionManager *manager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:configuration];

NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
NSURLRequest *request = [NSURLRequest requestWithURL:URL];

NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
    NSLog(@"File downloaded to: %@", filePath);
}];
[downloadTask resume];
```

#### Creating an Upload Task

```objective-c
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
TomboAFURLSessionManager *manager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:configuration];

NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
NSURLRequest *request = [NSURLRequest requestWithURL:URL];

NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"Success: %@ %@", response, responseObject);
    }
}];
[uploadTask resume];
```

#### Creating an Upload Task for a Multi-Part Request, with Progress

```objective-c
NSMutableURLRequest *request = [[TomboAFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<TomboAFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];

TomboAFURLSessionManager *manager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
NSProgress *progress = nil;

NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"%@ %@", response, responseObject);
    }
}];

[uploadTask resume];
```

#### Creating a Data Task

```objective-c
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
TomboAFURLSessionManager *manager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:configuration];

NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
NSURLRequest *request = [NSURLRequest requestWithURL:URL];

NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"%@ %@", response, responseObject);
    }
}];
[dataTask resume];
```

---

### Request Serialization

Request serializers create requests from URL strings, encoding parameters as either a query string or HTTP body.

```objective-c
NSString *URLString = @"http://example.com";
NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
```

#### Query String Parameter Encoding

```objective-c
[[TomboAFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
```

    GET http://example.com?foo=bar&baz[]=1&baz[]=2&baz[]=3

#### URL Form Parameter Encoding

```objective-c
[[TomboAFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters];
```

    POST http://example.com/
    Content-Type: application/x-www-form-urlencoded

    foo=bar&baz[]=1&baz[]=2&baz[]=3

#### JSON Parameter Encoding

```objective-c
[[TomboAFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters];
```

    POST http://example.com/
    Content-Type: application/json

    {"foo": "bar", "baz": [1,2,3]}

---

### Network Reachability Manager

`TomboAFNetworkReachabilityManager` monitors the reachability of domains, and addresses for both WWAN and WiFi network interfaces.

**Network reachability is a diagnostic tool that can be used to understand why a request might have failed. It should not be used to determine whether or not to make a request.**

#### Shared Network Reachability

```objective-c
[[TomboAFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(TomboAFNetworkReachabilityStatus status) {
    NSLog(@"Reachability: %@", TomboAFStringFromNetworkReachabilityStatus(status));
}];
```

#### HTTP Manager Reachability

```objective-c
NSURL *baseURL = [NSURL URLWithString:@"http://example.com/"];
TomboAFHTTPRequestOperationManager *manager = [[TomboAFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];

NSOperationQueue *operationQueue = manager.operationQueue;
[manager.reachabilityManager setReachabilityStatusChangeBlock:^(TomboAFNetworkReachabilityStatus status) {
    switch (status) {
        case TomboAFNetworkReachabilityStatusReachableViaWWAN:
        case TomboAFNetworkReachabilityStatusReachableViaWiFi:
            [operationQueue setSuspended:NO];
            break;
        case TomboAFNetworkReachabilityStatusNotReachable:
        default:
            [operationQueue setSuspended:YES];
            break;
    }
}];

[manager.reachabilityManager startMonitoring];
```

---

### Security Policy

`TomboAFSecurityPolicy` evaluates server trust against pinned X.509 certificates and public keys over secure connections.

Adding pinned SSL certificates to your app helps prevent man-in-the-middle attacks and other vulnerabilities. Applications dealing with sensitive customer data or financial information are strongly encouraged to route all communication over an HTTPS connection with SSL pinning configured and enabled.

#### Allowing Invalid SSL Certificates

```objective-c
TomboAFHTTPRequestOperationManager *manager = [TomboAFHTTPRequestOperationManager manager];
manager.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
```

---

### TomboAFHTTPRequestOperation

`TomboAFHTTPRequestOperation` is a subclass of `TomboAFURLConnectionOperation` for requests using the HTTP or HTTPS protocols. It encapsulates the concept of acceptable status codes and content types, which determine the success or failure of a request.

Although `TomboAFHTTPRequestOperationManager` is usually the best way to go about making requests, `TomboAFHTTPRequestOperation` can be used by itself.

#### `GET` with `TomboAFHTTPRequestOperation`

```objective-c
NSURL *URL = [NSURL URLWithString:@"http://example.com/resources/123.json"];
NSURLRequest *request = [NSURLRequest requestWithURL:URL];
TomboAFHTTPRequestOperation *op = [[TomboAFHTTPRequestOperation alloc] initWithRequest:request];
op.responseSerializer = [TomboAFJSONResponseSerializer serializer];
[op setCompletionBlockWithSuccess:^(TomboAFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
} failure:^(TomboAFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
}];
[[NSOperationQueue mainQueue] addOperation:op];
```

#### Batch of Operations

```objective-c
NSMutableArray *mutableOperations = [NSMutableArray array];
for (NSURL *fileURL in filesToUpload) {
    NSURLRequest *request = [[TomboAFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<TomboAFMultipartFormData> formData) {
        [formData appendPartWithFileURL:fileURL name:@"images[]" error:nil];
    }];

    TomboAFHTTPRequestOperation *operation = [[TomboAFHTTPRequestOperation alloc] initWithRequest:request];

    [mutableOperations addObject:operation];
}

NSArray *operations = [TomboAFURLConnectionOperation batchOfRequestOperations:@[...] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
    NSLog(@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
} completionBlock:^(NSArray *operations) {
    NSLog(@"All operations in batch complete");
}];
[[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
```

## Unit Tests

TomboAFNetworking includes a suite of unit tests within the Tests subdirectory. In order to run the unit tests, you must install the testing dependencies via [CocoaPods](http://cocoapods.org/):

    $ cd Tests
    $ pod install

Once testing dependencies are installed, you can execute the test suite via the 'iOS Tests' and 'OS X Tests' schemes within Xcode.

### Running Tests from the Command Line

Tests can also be run from the command line or within a continuous integration environment. The [`xcpretty`](https://github.com/mneorr/xcpretty) utility needs to be installed before running the tests from the command line:

    $ gem install xcpretty

Once `xcpretty` is installed, you can execute the suite via `rake test`.

## Credits

TomboAFNetworking is owned and maintained by the [Alamofire Software Foundation](http://alamofire.org).

TomboAFNetworking was originally created by [Scott Raymond](https://github.com/sco/) and [Mattt Thompson](https://github.com/mattt/) in the development of [Gowalla for iPhone](http://en.wikipedia.org/wiki/Gowalla).

TomboAFNetworking's logo was designed by [Alan Defibaugh](http://www.alandefibaugh.com/).

And most of all, thanks to TomboAFNetworking's [growing list of contributors](https://github.com/TomboAFNetworking/TomboAFNetworking/contributors).

### Security Disclosure

If you believe you have identified a security vulnerability with TomboAFNetworking, you should report it as soon as possible via email to security@alamofire.org. Please do not post it to a public issue tracker.

## License

TomboAFNetworking is released under the MIT license. See LICENSE for details.
