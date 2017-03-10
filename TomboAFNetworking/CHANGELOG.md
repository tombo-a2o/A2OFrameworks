#Change Log
All notable changes to this project will be documented in this file.
`TomboAFNetworking` adheres to [Semantic Versioning](http://semver.org/).

---

## [2.5.4](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.5.4) (2015-05-14)
Released on 2015-05-14. All issues associated with this milestone can be found using this [filter](https://github.com/TomboAFNetworking/TomboAFNetworking/issues?q=milestone%3A2.5.4+is%3Aclosed).

####Updated
* Updated the CI test script to run iOS tests on all versions of iOS that are installed on the build machine.
	* Updated by [Kevin Harwood](https://github.com/kcharwood) in [#2716](https://github.com/TomboAFNetworking/TomboAFNetworking/pull/2716).

####Fixed

* Fixed an issue where `TomboAFNSURLSessionTaskDidResumeNotification` and `TomboAFNSURLSessionTaskDidSuspendNotification` were not being properly called due to implementation differences in `NSURLSessionTask` in iOS 7 and iOS 8, which also affects the `TomboAFNetworkActivityIndicatorManager`.
	* Fixed by [Kevin Harwood](https://github.com/kcharwood) in [#2702](https://github.com/TomboAFNetworking/TomboAFNetworking/pull/2702).
* Fixed an issue where the OS X test linker would throw a warning during tests.
	* Fixed by [Christian Noon](https://github.com/cnoon) in [#2719](https://github.com/TomboAFNetworking/TomboAFNetworking/pull/2719).
* Fixed an issue where tests would randomly fail due to mocked objects not being cleaned up.
	* Fixed by [Kevin Harwood](https://github.com/kcharwood) in [#2717](https://github.com/TomboAFNetworking/TomboAFNetworking/pull/2717).


## [2.5.3](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.5.3) (2015-04-20)

* Add security policy tests for default policy

* Add network reachability tests

* Change `validatesDomainName` property to default to `YES` under all * security policies

* Fix `NSURLSession` subspec compatibility with iOS 6 / OS X 10.8

* Fix leak of data task used in `NSURLSession` swizzling

* Fix leak for observers from `addObserver:...:withBlock:`

* Fix issue with network reachability observation on domain name

## [2.5.2](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.5.2) (2015-03-26)
**NOTE** This release contains a security vulnerabilty. **All users should upgrade to a 2.5.3 or greater**. Please reference this [statement](https://gist.github.com/AlamofireSoftwareFoundation/f784f18f949b95ab733a) if you have any further questions about this release.

* Add guards for unsupported features in iOS 8 App Extensions

* Add missing delegate callbacks to 	`UIWebView` category

* Add test and implementation of strict default certificate validation

* Add #define for `NS_DESIGNATED_INITIALIZER` for unsupported versions of Xcode

* Fix `TomboAFNetworkActivityIndicatorManager` for iOS 7

* Fix `TomboAFURLRequestSerialization` property observation

* Fix `testUploadTasksProgressBecomesPartOfCurrentProgress`

* Fix warnings from Xcode 6.3 Beta

* Fix `TomboAFImageWithDataAtScale` handling of animated images

* Remove `TomboAFNetworkReachabilityAssociation` enumeration

* Update to conditional use assign semantics for GCD properties based on `OS_OBJECT_HAVE_OBJC_SUPPORT` for better Swift support

## [2.5.1](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.5.1) (2015-02-09)
**NOTE** This release contains a security vulnerabilty. **All users should upgrade to a 2.5.3 or greater**. Please reference this [statement](https://gist.github.com/AlamofireSoftwareFoundation/f784f18f949b95ab733a) if you have any further questions about this release.

 * Add `NS_DESIGNATED_INITIALIZER` macros. (Samir Guerdah)

 * Fix and clarify documentation for `stringEncoding` property. (Mattt
Thompson)

 * Fix for NSProgress bug where two child NSProgress instances are added to a
parent NSProgress. (Edward Povazan)

 * Fix incorrect file names in headers. (Steven Fisher)

 * Fix KVO issue when running testing target caused by lack of
`automaticallyNotifiesObserversForKey:` implementation. (Mattt Thompson)

 * Fix use of variable arguments for UIAlertView category.  (Kenta Tokumoto)

 * Fix `genstrings` warning for `NSLocalizedString` usage in
`UIAlertView+TomboAFNetworking`. (Adar Porat)

 * Fix `NSURLSessionManager` task observation for network activity indicator
manager. (Phil Tang)

 * Fix `UIButton` category method caching of background image (Fernanda G.
Geraissate)

 * Fix `UIButton` category method failure handling. (Maxim Zabelin)

 * Update multipart upload method requirements to ensure `request.HTTPBody`
is non-nil. (Mattt Thompson)

 * Update to use builtin `__Require` macros from AssertMacros.h. (Cédric
Luthi)

 * Update `parameters` parameter to accept `id` for custom serialization
block. (@mooosu)

## [2.5.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.5.0) (2014-11-17)

 * Add documentation for expected background session manager usage (Aaron
Brager)

 * Add missing documentation for `TomboAFJSONRequestSerializer` and
`TomboAFPropertyListSerializer` (Mattt Thompson)

 * Add tests for requesting HTTPS endpoints (Mattt Thompson)

 * Add `init` method declarations of `TomboAFURLResponseSerialization` classes for
Swift compatibility (Allen Rohner)

 * Change default User-Agent to use the version number instead of the build
number (Tim Watson)

 * Change `validatesDomainName` to readonly property (Mattt Thompson, Brian
King)

 * Fix checks when observing `TomboAFHTTPRequestSerializerObservedKeyPaths` (Jacek
Suliga)

 * Fix crash caused by attempting to set nil `NSURLResponse -URL` as key for
`userInfo` dictionary (Elvis Nuñez)

 * Fix crash for multipart streaming requests in XPC services (Mattt Thompson)

 * Fix minor aspects of response serializer documentation (Mattt Thompson)

 * Fix potential race condition for `TomboAFURLConnectionOperation -description`

 * Fix widespread crash related to key-value observing of `NSURLSessionTask
-state` (Phil Tang)

 * Fix `UIButton` category associated object keys (Kristian Bauer, Mattt
Thompson)

 * Remove `charset` parameter from Content-Type HTTP header field values for
`TomboAFJSONRequestSerializer` and `TomboAFPropertyListSerializer` (Mattt Thompson)

 * Update CocoaDocs color scheme (@Orta)

 * Update Podfile to explicitly define sources (Kyle Fuller)

 * Update to relay `downloadFileURL` to the delegate if the manager picks a
`fileURL` (Brian King)

 * Update `TomboAFSSLPinningModeNone` to not validate domain name (Brian King)

 * Update `UIButton` category to cache images in `sharedImageCache` (John
Bushnell)

 * Update `UIRefreshControl` category to set control state to current state
of request (Elvis Nuñez)

## [2.4.1](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.4.1) (2014-09-04)

 * Fix compiler warning generated on 32-bit architectures (John C. Daub)

 * Fix potential crash caused by failed validation with nil responseData
 (Mattt Thompson)

 * Fix to suppress compiler warnings for out-of-range enumerated type
 value assignment (Mattt Thompson)

## [2.4.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.4.0) (2014-09-03)

 * Add CocoaDocs color scheme (Orta)

 * Add image cache to `UIButton` category (Kristian Bauer, Mattt Thompson)

 * Add test for success block on 204 response (Mattt Thompson)

 * Add tests for encodable and re-encodable query string parameters (Mattt
Thompson)

 * Add `TomboAFHTTPRequestSerializer -valueForHTTPHeaderField:` (Kyle Fuller)

 * Add `TomboAFNetworkingOperationFailingURLResponseDataErrorKey` key to user info
of serialization error (Yannick Heinrich)

 * Add `imageResponseSerializer` property to `UIButton` category (Kristian
Bauer, Mattt Thompson)

 * Add `removesKeysWithNullValues` setting to serialization and copying (Jon
Shier)

 * Change request and response serialization tests to be factored out into
separate files (Mattt Thompson)

 * Change signature of success parameters in `UIButton` category methods to
match those in `UIImageView` (Mattt Thompson)

 * Change to remove charset parameter from
`application/x-www-form-urlencoded` content type (Mattt Thompson)

 * Change `TomboAFImageCache` to conform to `NSObject` protocol ( Marcelo Fabri)

 * Change `TomboAFMaximumNumberOfToRecreateBackgroundSessionUploadTask` to
`TomboAFMaximumNumberOfAttemptsToRecreateBackgroundSessionUploadTask` (Mattt
Thompson)

 * Fix documentation error for NSSecureCoding (Robert Ryan)

 * Fix documentation for `URLSessionDidFinishEventsForBackgroundURLSession`
delegate method (Mattt Thompson)

 * Fix expired ADN certificate in example project (Carson McDonald)

 * Fix for interoperability within Swift project (Stephan Krusche)

 * Fix for potential deadlock due to KVO subscriptions within a lock
(Alexander Skvortsov)

 * Fix iOS 7 bug where session tasks can have duplicate identifiers if
created from different threads (Mattt Thompson)

 * Fix iOS 8 bug by adding explicit synthesis for `delegate` of
`TomboAFMultipartBodyStream` (Mattt Thompson)

 * Fix issue caused by passing `nil` as body of multipart form part (Mattt
Thompson)

 * Fix issue caused by passing `nil` as destination in download task method
(Mattt Thompson)

 * Fix issue with `TomboAFHTTPRequestSerializer` returning a request and silently
handling an error from a `queryStringSerialization` block (Kyle Fuller, Mattt
Thompson)

 * Fix potential issues by ensuring `invalidateSessionCancelingTasks` only
executes on main thread (Mattt Thompson)

 * Fix potential memory leak caused by deferred opening of output stream
(James Tomson)

 * Fix properties on session managers such that default values will not trump
values set in the session configuration (Mattt Thompson)

 * Fix README to include explicit call to start reachability manager (Mattt
Thompson)

 * Fix request serialization error handling in `TomboAFHTTPSessionManager`
convenience methods (Kyle Fuller, Lars Anderson, Mattt Thompson)

 * Fix stray localization macro (Devin McKaskle)

 * Fix to ensure connection operation `-copyWithZone:` calls super
implementation (Chris Streeter)

 * Fix `UIButton` category to only cancel request for specified state
(@xuzhe, Mattt Thompson)

## [2.3.1](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.3.1) (2014-06-13)

 * Fix issue with unsynthesized `streamStatus` & `streamError` properties
on `TomboAFMultipartBodyStream` (Mattt Thompson)

## [2.3.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.3.0) (2014-06-11)

 * Add check for `TOMBO_AF_APP_EXTENSIONS` macro to conditionally compile
background  method that makes API call unavailable to App Extensions in iOS 8
/ OS X 10.10

 * Add further explanation for network reachability in documentation (Steven
Fisher)

 * Add notification for initial change from
`TomboAFNetworkReachabilityStatusUnknown` to any other state (Jason Pepas,
Sebastian S.A., Mattt Thompson)

 * Add tests for TomboAFNetworkActivityIndicatorManager (Dave Weston, Mattt
Thompson)

 * Add tests for TomboAFURLSessionManager task progress (Ullrich Schäfer)

 * Add `attemptsToRecreateUploadTasksForBackgroundSessions` property, which
attempts Apple's recommendation of retrying a failed upload task if initial
creation did not succeed (Mattt Thompson)

 * Add `completionQueue` and `completionGroup` properties to
`TomboAFHTTPRequestOperationManager` (Robert Ryan)

 * Change deprecating `TomboAFErrorDomain` in favor of
`TomboAFRequestSerializerErrorDomain` & `TomboAFResponseSerializerErrorDomain` (Mattt
Thompson)

 * Change serialization tests to be split over two different files (Mattt
Thompson)

 * Change to make NSURLSession subspec not depend on NSURLConnection subspec
(Mattt Thompson)

 * Change to make Serialization subspec not depend on NSURLConnection subspec
(Nolan Waite, Mattt Thompson)

 * Change `completionHandler` of
`application:handleEventsForBackgroundURLSession:completion:` to be run on
main thread (Padraig Kennedy)

 * Change `UIImageView` category to accept any object conforming to
`TomboAFURLResponseSerialization`, rather than just `TomboAFImageResponseSerializer`
(Romans Karpelcevs)

 * Fix calculation and behavior of `NSProgress` (Padraig Kennedy, Ullrich
Schäfer)

 * Fix deprecation warning for `backgroundSessionConfiguration:` in iOS 8 /
OS X 10.10 (Mattt Thompson)

 * Fix implementation of `copyWithZone:` in serializer subclasses (Chris
Streeter)

 * Fix issue in Xcode 6 caused by implicit synthesis of overridden `NSStream`
properties (Clay Bridges, Johan Attali)

 * Fix KVO handling for `NSURLSessionTask` on iOS 8 / OS X 10.10 (Mattt
Thompson)

 * Fix KVO leak for `NSURLSessionTask` (@Zyphrax)

 * Fix potential crash caused by attempting to use non-existent error of
failing requests due to URLs exceeding a certain length (Boris Bügling)

 * Fix to check existence of `uploadProgress` block inside a referencing
`dispatch_async` to avoid potential race condition (Kyungkoo Kang)

 * Fix `UIImageView` category race conditions (Sunny)

 * Remove unnecessary default operation response serializer setters (Mattt
Thompson)

## [2.2.4](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.2.4) (2014-05-13)

 * Add NSSecureCoding support to all TomboAFNetworking classes (Kyle Fuller, Mattt
Thompson)

 * Change behavior of request operation `NSOutputStream` property to only nil
out if `responseData` is non-nil, meaning that no custom object was set
(Mattt Thompson)

 * Fix data tasks to not attempt to track progress, and rare related crash
(Padraig Kennedy)

 * Fix issue with `-downloadTaskDidFinishDownloading:` not being called
(Andrej Mihajlov)

 * Fix KVO leak on invalidated session tasks (Mattt Thompson)

 * Fix missing import of `UIRefreshControl+TomboAFNetworking" (@BB9z)

 * Fix potential compilation errors on Mac OS X, caused by import order of
`<AssertionMacros.h>`, which signaled an incorrect deprecation warning (Mattt
Thompson)

 * Fix race condition in UIImageView+TomboAFNetworking when making several image
requests in quick succession (Alexander Crettenand)

 * Update documentation for `-downloadTaskWithRequest:` to warn about blocks
being disassociated on app termination and backgrounding (Robert Ryan)

## [2.2.3](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.2.3) (2014-04-18)

  * Fix `TomboAFErrorOrUnderlyingErrorHasCodeInDomain` function declaration for
TomboAFXMLDocumentResponseSerializer (Mattt Thompson)

  * Fix error domain check in `TomboAFErrorOrUnderlyingErrorHasCodeInDomain`
(Mattt Thompson)

  * Fix `UIImageView` category to only `nil` out request operation properties
belonging to completed request (Mattt Thompson)

  * Fix `removesKeysWithNullValues` to respect
`NSJSONReadingMutableContainers` option (Mattt Thompson)

  * Change `removesKeysWithNullValues` property to recursively remove null
values from dictionaries nested in arrays (@jldagon)

  * Change to not override `Content-Type` header field values set by
`HTTPRequestHeaders` property (Aaron Brager, Mattt Thompson)

## [2.2.2](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.2.2) (2014-04-15)

  * Add `removesKeysWithNullValues` property to `TomboAFJSONResponsSerializer` to
automatically remove `NSNull` values in dictionaries serialized from JSON
(Mattt Thompson)

  * Add unit test for checking content type (Diego Torres)

  * Add `boundary` property to `TomboAFHTTPBodyPart -copyWithZone:`

  * Change to accept `id` parameter type in HTTP manager convenience methods
(Mattt Thompson)

  * Change to deprecate `setAuthorizationHeaderFieldWithToken:`, in favor of
users specifying an `Authorization` header field value themselves (Mattt
Thompson)

  * Change to use `long long` type to prevent a difference in stream size
caps on 32-bit and 64-bit architectures (Yung-Luen Lan, Cédric Luthi)

  * Fix calculation of Content-Length in `taskDidSendBodyData` (Christos
Vasilakis)

  * Fix for comparison of image view request operations (Mattt Thompson)

  * Fix for SSL certificate validation to check status codes at runtime (Dave
Anderson)

  * Fix to add missing call to delegate in
`URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:`

  * Fix to call `taskDidComplete` if delegate is missing (Jeff Ward)

  * Fix to implement `respondsToSelector:` for `NSURLSession` delegate
methods to conditionally respond to conditionally respond to optional
selectors if and only if a custom block has been set (Mattt Thompson)

  * Fix to prevent illegal state values from being assigned for
`TomboAFURLConnectionOperation` (Kyle Fuller)

  * Fix to re-establish `TomboAFNetworkingURLSessionTaskDelegate` objects after
restoring from a background configuration (Jeff Ward)

  * Fix to reduce memory footprint by `nil`-ing out request operation
`outputStream` after closing, as well as image view request operation after
setting image (Teun van Run, Mattt Thompson)

  * Remove unnecessary call in class constructor (Bernhard Loibl)

  * Remove unnecessary check for `respondsToSelector:` for `UIScreen scale`
in User-Agent string (Samuel Goodwin)

  * Update App.net certificate and API base URL (Cédric Luthi)

  * Update examples in README (@petard, @orta, Mattt Thompson)

  * Update Travis CI icon to use SVG format (Maximilian Tagher)

## [2.2.1](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.2.1) (2014-03-14)

  * Fix `-Wsign-conversion` warning in TomboAFURLConnectionOperation (Jesse Collis)

  * Fix `-Wshorten-64-to-32` warning (Jesse Collis)

  * Remove unnecessary #imports in `UIImageView` & `UIWebView` categories
(Jesse Collis)

  * Fix call to `CFStringTransform()` by checking return value before setting
as `User-Agent` (Kevin Cassidy Jr)

  * Update `TomboAFJSONResponseSerializer` adding `@autorelease` to relieve memory
pressure (Mattt Thompson, Michal Pietras)

  * Update `TomboAFJSONRequestSerializer` to accept `id` (Daren Desjardins)

  * Fix small documentation bug (@jkoepcke)

  * Fix behavior of SSL pinning. In case of `validatesDomainName == YES`, it
now explicitly uses `SecPolicyCreateSSL`, which also validates the domain
name. Otherwise, `SecPolicyCreateBasicX509` is used.
`TomboAFSSLPinningModeCertificate` now uses `SecTrustSetAnchorCertificates`, which
allows explicit specification of all trusted certificates. For
`TomboAFSSLPinningModePublicKey`, the number of trusted public keys determines if
the server should be trusted. (Oliver Letterer, Eric Allam)

## [2.2.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.2.0) (2014-02-25)

  * Add default initializer to make `TomboAFHTTPRequestOperationManager`
consistent with `TomboAFHTTPSessionManager` (Marcelo Fabri)

  * Add documentation about `UIWebView` category and implementing
`UIWebViewDelegate` (Mattt Thompson)

  * Add missing `NSCoding` and `NSCopying` implementations for
`TomboAFJSONRequestSerializer` (Mattt Thompson)

  * Add note about use of `-startMonitoring` in
`TomboAFNetworkReachabilityManager` (Mattt Thompson)

  * Add setter for needsNewBodyStream block (Carmen Cerino)

  * Add support for specifying a response serializer on a per-instance of
`TomboAFURLSessionManagerTaskDelegate` (Blake Watters)

  * Add `TomboAFHTTPRequestSerializer
-requestWithMultipartFormRequest:writingStreamContentsToFile:completionHandler
:` as a workaround for a bug in NSURLSession that removes the Content-Length
header from streamed requests (Mattt Thompson)

  * Add `NSURLRequest` factory properties on `TomboAFHTTPRequestSerializer` (Mattt
Thompson)

  * Add `UIRefreshControl+TomboAFNetworking` (Mattt Thompson)

  * Change example project to enable certificate pinning (JP Simard)

  * Change to allow self-signed certificates (Frederic Jacobs)

  * Change to make `reachabilityManager` property readwrite (Mattt Thompson)

  * Change to sort `NSSet` members during query string parameter
serialization (Mattt Thompson)

  * Change to use case sensitive compare when sorting keys in query string
serialization (Mattt Thompson)

  * Change to use xcpretty instead of xctool for automated testing (Kyle
Fuller, Marin Usalj, Carson McDonald)

  * Change to use `@selector` values as keys for associated objects (Mattt
Thompson)

  * Change `setImageWithURL:placeholder:`, et al. to only set placeholder
image if not `nil` (Alejandro Martinez)

  * Fix auto property synthesis warnings (Oliver Letterer)

  * Fix domain name validation for SSL certificates (Oliver Letterer)

  * Fix issue with session task delegate KVO observation (Kyle Fuller)

  * Fix placement of `baseURL` method declaration (Oliver Letterer)

  * Fix podspec linting error (Ari Braginsky)

  * Fix potential concurrency issues by adding lock around setting
`isFinished` state in `TomboAFURLConnectionOperation` (Mattt Thompson)

  * Fix potential vulnerability caused by hard-coded multipart form data
boundary (Mathias Bynens, Tom Van Goethem, Mattt Thompson)

  * Fix protocol name in #pragma mark declaration (@sevntine)

  * Fix regression causing inflated images to have incorrect orientation
(Mattt Thompson)

  * Fix to `TomboAFURLSessionManager` `NSCoding` implementation, to accommodate
`NSURLSessionConfiguration` no longer conforming to `NSCoding`.

  * Fix Travis CI integration (Kyle Fuller, Marin Usalj, Carson McDonald)

  * Fix various static analyzer warnings (Philippe Casgrain, Jim Young,
Steven Fisher, Mattt Thompson)

  * Fix with download progress calculation of completion units (Kyle Fuller)

  * Fix Xcode 5.1 compiler warnings (Nick Banks)

  * Fix `TomboAFHTTPRequestOperationManager` to default
`shouldUseCredentialStorage` to `YES`, as documented (Mattt Thompson)

  * Remove Unused format property in `TomboAFJSONRequestSerializer` (Mattt
Thompson)

  * Remove unused `acceptablePathExtensions` class method in
`TomboAFJSONRequestSerializer` (Mattt Thompson)

  * Update #ifdef declarations in UIKit categories to be simpler (Mattt
Thompson)

  * Update podspec to includ social_media_url (Kyle Fuller)

  * Update types for 64 bit architecture (Bruno Tortato Furtado, Mattt
Thompson)

## [2.1.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.1.0) (2014-01-16)

  * Add CONTRIBUTING (Kyle Fuller)

  * Add domain name verification for SSL certificates (Oliver Letterer)

  * Add leaf certificate checking (Alex Leverington, Carson McDonald, Mattt
Thompson)

  * Add test case for stream failure handling (Kyle Fuller)

  * Add underlying error properties to response serializers to forward errors
to subsequent validation steps (Mattt Thompson)

  * Add `TomboAFImageCache` protocol, to allow for custom image caches to be
specified for `UIImageView` (Mattt Thompson)

  * Add `error` out parameter for request serializer, deprecating existing
request constructor methods (Adam Becevello)

  * Change request serializer protocol to take id type for parameters (Mattt
Thompson)

  * Change to add validation of download task responses (Mattt Thompson)

  * Change to force upload progress, by using original request Content-Length
(Mateusz Malczak)

  * Change to use `NSDictionary` object literals for `NSError` `userInfo`
construction (Mattt Thompson)

  * Fix #pragma declaration to be NSURLConnectionDataDelegate, rather than
NSURLConnectionDelegate (David Paschich)

  * Fix a bug when appending a file part to multipart request from a URL
(Kyle Fuller)

  * Fix analyzer warning about weak receiver being set to nil, capture strong
reference (Stewart Gleadow)

  * Fix appending file part to multipart request to use suggested file name,
rather than temporary one (Kyle Fuller)

  * Fix availability macros for network activity indicator (Mattt Thompson)

  * Fix crash in iOS 6.1 caused by KVO on `isCancelled` property of
`TomboAFURLConnectionOperation` (Sam Page)

  * Fix dead store issues in `TomboAFSecurityPolicy` (Andrew Hershberger)

  * Fix incorrect documentation for `-HTTPRequestOperationWithRequest:...`
(Kyle Fuller)

  * Fix issue in reachability callbacks, where reachability managers created
for a particular domain would initially report no reachability (Mattt
Thompson)

  * Fix logic for handling data task turning into download task (Kyle Fuller)

  * Fix property list response serializer to handle 204 response (Kyle Fuller)

  * Fix README multipart example (Johan Forssell)

  * Fix to add check for non-nil delegate in
`URLSession:didCompleteWithError:` (Kaom Te)

  * Fix to dramatically improve creation of images in
`TomboAFInflatedImageFromResponseWithDataAtScale`, including handling of CMYK, 16
/ 32 bpc images, and colorspace alpha settings (Robert Ryan)

  * Fix Travis CI integration and unit testing (Kyle Fuller, Carson McDonald)

  * Fix typo in comments (@palringo)

  * Fix UIWebView category to use supplied success callback (Mattt Thompson)

  * Fix various static analyzer warnings (Kyle Fuller, Jesse Collis, Mattt
Thompson)

  * Fix `+batchOfRequestOperations:...` completion block to execute in
`dispatch_async` (Mattt Thompson)

  * Remove synchronous `SCNetworkReachabilityGetFlags` call when initializing
managers, which had the potential to block in certain network conditions
(Yury Korolev, Mattt Thompson)

  * Remove unnecessary check for completionHandler in HTTP manager (Mattt
Thompson)

  * Remove unused conditional clauses (Luka Bratos)

  * Update documentation for `TomboAFCompoundResponseSerializer` (Mattt Thompson)

  * Update httpbin certificates (Carson McDonald)

  * Update notification constant names to be consistent with `NSURLSession`
terminology (Mattt Thompson)

## [2.0.3](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.0.3) (2013-11-18)

  * Fix a bug where `TomboAFURLConnectionOperation -pause` did not correctly reset
the state of `TomboAFURLConnectionOperation`, causing the Network Thread to enter
an infinite loop (Erik Chen)

  * Fix a bug where `TomboAFURLConnectionOperation -cancel` does not set the
appropriate error on the `NSOperation` (Erik Chen)

  * Fix to post `TomboAFNetworkingTaskDidFinishNotification` only on main queue
(Jakub Hladik)

  * Fix issue where the query string serialization block was not used (Kevin
Harwood)

  * Fix project file and repository directory items (Andrew Newdigate)

  * Fix `NSURLSession` subspec (Mattt Thompson)

  * Fix to session task delegate KVO by moving observer removal to
`-didCompleteWithError:` (Mattt Thompson)

  * Add TomboAFNetworking 1.x behavior for image construction in inflation to
ensure correct orientation (Mattt Thompson)

  * Add `NSParameterAssert` for internal task constructors in order to catch
invalid constructions early (Mattt Thompson)

  * Update replacing `NSParameterAssert` with early `nil` return if session
was unable to create a task (Mattt Thompson)

  * Update `TomboAFHTTPRequestOperationManager` and `TomboAFHTTPSessionManager` to use
relative `self class` to create class constructor instances (Bogdan
Poplauschi)

  * Update to break out of loop if output stream does not have space to write
bytes (Mattt Thompson)

  * Update documentation and README with various fixes (Max Goedjen, Mattt
Thompson)

  * Remove unnecessary willChangeValueForKey and didChangeValueForKey method
calls (Mindaugas Vaičiūnas)

  * Remove deletion of all task delegates in
`URLSessionDidFinishEventsForBackgroundURLSession:` (Jeremy Mailen)

  * Remove empty, unused `else` branch (Luka Bratos)

## [2.0.2](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.0.2) (2013-10-29)

  * Add `UIWebView
 -loadRequest:MIMEType:textEncodingName:progress:success:failure:` (Mattt
 Thompson)

  * Fix iOS 6 compatibility in `TomboAFHTTPSessionManager` &
 `UIProgressView+TomboAFNetworking` (Olivier Halligon, Mattt Thompson)

  * Fix issue writing partial data to output stream (Kyle Fuller)

  * Fix behavior for `nil` response in request operations (Marcelo Fabri)

  * Fix implementation of
 batchOfRequestOperations:progressBlock:completionBlock: for nil when passed
 empty operations parameter (Mattt Thompson)

  * Update `TomboAFHTTPSessionManager` to allow `-init` and `initWithConfig:` to
 work (Ben Scheirman)

  * Update `TomboAFRequestOperation` to default to `TomboAFHTTPResponseSerializer` (Jiri
 Techet)

  * Update `TomboAFHTTPResponseSerializer` to remove check for nonzero responseData
 length (Mattt Thompson)

  * Update `NSCoding` methods to use NSStringFromSelector(@selector()) pattern
 instead of `NSString` literals (Mattt Thompson)

  * Update multipart form stream to set Content-Length after setting request
 stream (Mattt Thompson)

  * Update documentation with outdated references to `TomboAFHTTPSerializer` (Bruno
 Koga)

  * Update documentation and README with various fixes (Jon Chambers, Mattt
 Thompson)

  * Update files to remove executable privilege (Kyle Fuller)

## 2.0.1 (2013-10-10)

 * Fix iOS 6 compatibility (Matt Baker, Mattt Thompson)

 * Fix example applications (Sam Soffes, Kyle Fuller)

 * Fix usage of `NSSearchPathForDirectoriesInDomains` in README (Leo Lou)

 * Fix names of exposed private methods `downloadProgress` and
`uploadProgress` (Hermes Pique)

 * Fix initial upload/download task progress updates (Vlas Voloshin)

 * Fix podspec to include `TomboAFNetworking.h` `#import` (@haikusw)

 * Fix request serializers to not override existing header field values with
defaults (Mattt Thompson)

 * Fix unused format string placeholder (Thorsten Lockert)

 * Fix `TomboAFHTTPRequestOperation -initWithCoder:` to call `super` (Josh Avant)

 * Fix `UIProgressView` selector name (Allen Tu)

 * Fix `UIButton` response serializer (Sam Grossberg)

 * Fix `setPinnedCertificates:` and pinned public keys (Kyle Fuller)

 * Fix timing of batched operation completion block (Denys Telezhkin)

 * Fix `GCC_WARN_ABOUT_MISSING_NEWLINE` compiler warning (Chuck Shnider)

 * Fix a format string missing argument issue in tests (Kyle Fuller)

 * Fix location of certificate chain bundle location (Kyle Fuller)

 * Fix memory leaks in TomboAFSecurityPolicyTests (Kyle Fuller)

 * Fix potential concurrency issues in `TomboAFURLSessionManager` by adding locks
around access to mutiple delegates dictionary (Mattt Thompson)

 * Fix unused variable compiler warnings by wrapping `OSStatus` and
`NSCAssert` with NS_BLOCK_ASSERTIONS macro (Mattt Thompson)

 * Fix compound serializer error handling (Mattt Thompson)

 * Fix string encoding for responseString (Juan Enrique)

 * Fix `UIImageView -setBackgroundImageWithRequest:` (Taichiro Yoshida)

 * Fix regressions nested multipart parameters (Mattt Thompson)

 * Add `responseObject` property to `TomboAFHTTPRequestOperation` (Mattt Thompson)

 * Add support for automatic network reachability monitoring for request
operation and session managers (Mattt Thompson)

 * Update documentation and README with various corrections and fixes
(@haikusw, Chris Hellmuth, Dave Caunt, Mattt Thompson)

 * Update default User-Agent such that only ASCII character set is used
(Maximillian Dornseif)

 * Update SSL pinning mode to have default pinned certificates by default
(Kevin Harwood)

 * Update `TomboAFSecurityPolicy` to use default authentication handling unless a
credential exists for the server trust (Mattt Thompson)

 * Update Prefix.pch (Steven Fisher)

 * Update minimum iOS test target to iOS 6

 * Remove unused protection space block type (Kyle Fuller)

 * Remove unnecessary Podfile.lock (Kyle Fuller)

## [2.0.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/2.0.0) (2013-09-27)

* Initial 2.0.0 Release

====================
#TomboAFNetworking 1.0 Change Log
--

## [1.3.4](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.3.4) (2014-04-15)

 * Fix `TomboAFHTTPMultipartBodyStream` to randomly generate form boundary, to
prevent attack based on a known value (Mathias Bynens, Tom Van Goethem, Mattt
Thompson)

 * Fix potential non-terminating loop in `connection:didReceiveData:` (Mattt
Thompson)

 * Fix SSL certificate validation to provide a human readable Warning when
SSL Pinning fails (Maximillian Dornseif)

 * Fix SSL certificate validation  to assert that no impossible pinning
configuration exists (Maximillian Dornseif)

 * Fix to check `CFStringTransform()` call for success before using result
(Kevin Cassidy Jr)

 * Fix to prevent unused assertion results with macros (Indragie Karunaratne)

 * Fix to call call `SecTrustEvaluate` before calling
`SecTrustGetCertificateCount` in SSL certificate validation (Josh Chung)

 * Fix to add explicit cast to `NSUInteger` in format string (Alexander
Kempgen)

 * Remove unused variable `kTomboAFStreamToStreamBufferSize` (Alexander Kempgen)

## [1.3.3](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.3.3) (2013-09-25)

 * Add stream error handling to `TomboAFMultipartBodyStream` (Nicolas Bachschmidt,
Mattt Thompson)

 * Add stream error handling to `TomboAFURLConnectionOperation
-connection:didReceiveData:` (Ian Duggan, Mattt Thompson)

 * Fix parameter query string encoding of square brackets according to RFC
3986 (Kra Larivain)

 * Fix TomboAFHTTPBodyPart determination of end of input stream data (Brian Croom)

 * Fix unit test timeouts (Carson McDonald)

 * Fix truncated `User-Agent` header field when app contained non-ASCII
characters (Diego Torres)

 * Fix outdated link in documentation (Jonas Schmid)

 * Fix `TomboAFHTTPRequestOperation` `HTTPError` property to be thread-safe
(Oliver Letterer, Mattt Thompson)

 * Fix API compatibility with iOS 5 (Blake Watters, Mattt Thompson)

 * Fix potential race condition in `TomboAFURLConnectionOperation
-cancelConnection` (@mm-jkolb, Mattt Thompson)

 * Remove implementation of `connection:needNewBodyStream:` delegate method
in `TomboAFURLConnectionOperation`, which fixes stream errors on authentication
challenges (Mattt Thompson)

 * Fix calculation of network reachability from flags (Tracy Pesin, Mattt
Thompson)

 * Update TomboAFHTTPClient documentation to clarify scope of `parameterEncoding`
property (Thomas Catterall)

 * Update `UIImageView` category to allow for nested calls to
`setImageWithURLRequest:` (Philippe Converset)

  * Change `UIImageView` category to accept invalid SSL certificates when
`_TomboAFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_` is defined (Flávio Caetano)

 * Change to replace #pragma clang with cast (Cédric Luthi)

## [1.3.2](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.3.2) (2013-08-08)

 * Add return status checks when building list of pinned public keys (Sylvain
Guillope)

 * Add return status checks when handling connection authentication challenges
(Sylvain Guillope)

 * Add tests around `TomboAFHTTPClient initWithBaseURL:` (Kyle Fuller)

 * Change to remove all `_TomboAFNETWORKING_PIN_SSL_CERTIFICATES_` conditional
compilation (Dustin Barker)

 * Change to allow fallback to generic image loading when PNG/JPEG data
provider methods fail (Darryl H. Thomas)

 * Change to only set placeholder image if not `nil` (Mattt Thompson)

 * Change to use `response.MIMEType` rather than (potentially nonexistent)
Content-Type headers to determine image data provider (Mattt Thompson)

 * Fix image request test endpoint (Carson McDonald)

 * Fix compiler warning caused by `size_t` value defaulted to `NULL` (Darryl H.
Thomas)

 * Fix mutable headers property in `TomboAFHTTPClient -copyWithZone:` (Oliver
Letterer)

 * Fix documentation and asset references in README (Romain Pouclet, Peter
Goldsmith)

 * Fix bug in examples always using `TomboAFSSLPinningModeNone` (Dustin Barker)

 * Fix execution of tests under Travis (Blake Watters)

 * Fix static analyzer warnings about CFRelease calls to NULL pointer (Mattt
Thompson)

 * Change to return early in `TomboAFGetMediaTypeAndSubtypeWithString` if string is
`nil` (Mattt Thompson)

 * Change to opimize network thread creation (Mattt Thompson)

## [1.3.1](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.3.1) (2013-06-18)

 * Add `automaticallyInflatesResponseImage` property to
`TomboAFImageRequestOperation`, which when enabled, offers significant performance
improvements for drawing images loaded through `UIImageView+TomboAFNetworking` by
inflating compressed image data in the background (Mattt Thompson, Peter
Steinberger)

 * Add `NSParameterAssert` check for `nil` `urlRequest` parameter in
`TomboAFURLConnectionOperation` initializer (Kyle Fuller)

 * Fix reachability to detect the case where a connection is required but can
be automatically established (Joshua Vickery)

 * Fix to Test target Podfile (Kyle Fuller)

## [1.3.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.3.0)  (2013-06-01)

 * Change in `TomboAFURLConnectionOperation` `NSURLConnection` authentication
delegate methods and associated block setters. If
`_TomboAFNETWORKING_PIN_SSL_CERTIFICATES_` is defined,
`-setWillSendRequestForAuthenticationChallengeBlock:` will be available, and
`-connection:willSendRequestForAuthenticationChallenge:` will be implemented.
Otherwise, `-setAuthenticationAgainstProtectionSpaceBlock:` &
`-setAuthenticationChallengeBlock:` will be available, and
`-connection:canAuthenticateAgainstProtectionSpace:` &
`-connection:didReceiveAuthenticationChallenge:` will be implemented instead
(Oliver Letterer)

 * Change in TomboAFNetworking podspec to include Security framework (Kevin Harwood,
Oliver Letterer, Sam Soffes)

 * Change in TomboAFHTTPClient to @throw exception when non-designated intializer is
used (Kyle Fuller)

 * Change in behavior of connection:didReceiveAuthenticationChallenge: to not
use URL-encoded credentials, which should already have been applied (@xjdrew)

 * Change to set TomboAFJSONRequestOperation error when unable to decode response
string (Chris Pickslay, Geoff Nix)

 * Change TomboAFURLConnectionOperation to lazily initialize outputStream property
(@fumoboy007)

 * Change instances of (CFStringRef)NSRunLoopCommonModes to
kCFRunLoopCommonModes

 * Change #warning to #pragma message for dynamic framework linking warnings
(@michael_r_may)

 * Add unit testing and continuous integration system (Blake Watters, Oliver
Letterer, Kevin Harwood, Cédric Luthi, Adam Fraser, Carson McDonald, Mattt
Thompson)

 * Fix multipart input stream implementation (Blake Watters, OliverLetterer,
Aleksey Kononov, @mattyohe, @mythodeia, @JD-)

 * Fix implementation of authentication delegate methods (Oliver Letterer,
Kevin Harwood)

 * Fix implementation of TomboAFSSLPinningModePublicKey on Mac OS X (Oliver Letterer)

 * Fix error caused by loading file:// requests with TomboAFHTTPRequestOperation
subclasses (Dave Anderson, Oliver Letterer)

 * Fix threading-related crash in TomboAFNetworkActivityIndicatorManager (Dave Keck)

 * Fix to suppress GNU expression and enum assignment warnings from Clang
(Henrik Hartz)

 * Fix leak caused by CFStringConvertEncodingToIANACharSetName in TomboAFHTTPClient
-requestWithMethod:path:parameters: (Daniel Demiss)

 * Fix missing __bridge casts in TomboAFHTTPClient (@apouche, Mattt Thompson)

 * Fix Objective-C++ compatibility (Audun Holm Ellertsen)

 * Fix to not escape tildes (@joein3d)

 * Fix warnings caused by unsynthesized properties (Jeff Hunter)

 * Fix to network reachability calls to provide correct  status on
initialization (@djmadcat, Mattt Thompson)

 * Fix to suppress warnings about implicit signedness conversion (Matt Rubin)

 * Fix TomboAFJSONRequestOperation -responseJSON failing cases (Andrew Vyazovoy,
Mattt Thompson)

 * Fix use of object subscripting to avoid incompatibility with iOS < 6 and OS
X < 10.8 (Paul Melnikow)

 * Various fixes to reverted multipart stream provider implementation (Yaron
Inger, Alex Burgel)

## [1.2.1](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.2.1) (2013-04-18)

 * Add `allowsInvalidSSLCertificate` property to `TomboAFURLConnectionOperation` and
`TomboAFHTTPClient`, replacing `_TomboAFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_` macro
(Kevin Harwood)

 * Add SSL pinning mode to example project (Kevin Harwood)

 * Add name to TomboAFNetworking network thread (Peter Steinberger)

 * Change pinned certificates to trust all derived certificates (Oliver
Letterer)

 * Fix documentation about SSL pinning (Kevin Harwood, Mattt Thompson)

 * Fix certain enumerated loops to use fast enumeration, resulting in better
performance (Oliver Letterer)

 * Fix macro to work correctly under Mac OS X 10.7 and iOS 4 SDK (Paul Melnikow)

 * Fix documentation, removing unsupported `@discussion` tags (Michele Titolo)

 * Fix `SecTrustCreateWithCertificates` expecting an array as first argument
(Oliver Letterer)

 * Fix to use `errSecSuccess` instead of `noErr` for Security frameworks
OSStatus (Oliver Letterer)

 * Fix `TomboAFImageRequestOperation` to use `[self alloc]` instead of explicit
class, which allows for subclassing (James Clarke)

 * Fix for `numberOfFinishedOperations` calculations (Rune Madsen)

 * Fix calculation of data length in `-connection:didReceiveData:`
(Jean-Francois Morin)

 * Fix to encode JSON only with UTF-8, following recommendation of
`NSJSONSerialiation` (Sebastian Utz)

## [1.2.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.2.0) (2013-03-24)

 * Add `SSLPinningMode` property to `TomboAFHTTPClient` (Oliver Letterer, Kevin
Harwood, Adam Becevello, Dustin Barker, Mattt Thompson)

 * Add single quote ("'"), comma (","), and asterix ("*") to escaped URL
encoding characters (Eric Florenzano, Marc Nijdam, Garrett Murray)

 * Add `credential` property to `TomboAFURLConnectionOperation` (Mattt Thompson)

 * Add `-setDefaultCredential:` to `TomboAFHTTPClient`

 * Add `shouldUseCredentialStorage` property to `TomboAFURLConnectionOperation`
(Mattt Thompson)

 * Add support for repeated key value pairs in `TomboAFHTTPClient` URL query string
(Nick Dawson)

 * Add `TomboAFMultipartFormData -
appendPartWithFileURL:name:fileName:mimeType:error` (Daniel Rodríguez Troitiño)

 * Add `TomboAFMultipartFormData -
appendPartWithInputStream:name:fileName:mimeType:` (@joein3d)

 * Change SSL pinning to be runtime property on `TomboAFURLConnectionOperation`
rather than defined by macro (Oliver Letterer)

 * Change `TomboAFMultipartBodyStream` to `TomboAFMultipartBodyStreamProvider`, vending
one side of a bound CFStream pair rather than subclassing `NSInputStream` (Mike
Ash)

 * Change default `Accept-Language` header in `TomboAFHTTPClient` (@therigu, Mattt
Thompson)

 * Change `TomboAFHTTPClient` operation cancellation to be based on request URL path
rather than absolute URL string (Mattt Thompson)

 * Change request operation subclass processing queues to use
`DISPATCH_QUEUE_CONCURRENT` (Mattt Thompson)

 * Change `UIImageView+TomboAFNetworking` to resolve asymmetry in cached image case
between success block provided and not provided (@Eveets, Mattt Thompson)

 * Change `UIImageView+TomboAFNetworking` to compare `NSURLRequest` instead of
`NSURL` to determine if previous request was equivalent (Cédric Luthi)

 * Change `UIImageView+TomboAFNetworking` to only set image if non-`nil` (Sean
Kovacs)

 * Change indentation settings to four spaces at the project level (Cédric
Luthi)

 * Change `TomboAFNetworkActivityIndicatorManager` to only update if requests have a
non-`nil` URL (Cédric Luthi)

 * Change `UIImageView+TomboAFNetworking` to not do `setHTTPShouldHandleCookies`
(Konstantinos Vaggelakos)

 * Fix request stream exhaustion error on authentication challenges (Alex
Burgel)

 * Fix implementation to use `NSURL` methods instead of `CFURL` functions where
applicable (Cédric Luthi)

 * Fix race condition in `UIImageView+TomboAFNetworking` (Peyman)

 * Fix `responseJSON`, `responseString`, and `responseStringEncoding` to be
threadsafe (Jon Parise, Mattt Thompson)

 * Fix `TomboAFContentTypeForPathExtension` to ensure non-`NULL` content return
value (Zach Waugh)

 * Fix documentation for `appendPartWithFileURL:name:error:`
 (Daniel Rodríguez Troitiño)

 * Fix request operation subclass processing queues to initialize with
`dispatch_once` (Sasmito Adibowo)

 * Fix posting of `TomboAFNetworkingOperationDidStartNotification` and
`TomboAFNetworkingOperationDidFinishNotification` to avoid crashes when logging in
response to notifications (Blake Watters)

 * Fix ordering of registered operation consultation in `TomboAFHTTPClient` (Joel
Parsons)

 * Fix warning: multiple methods named 'postNotificationName:object:' found
[-Wstrict-selector-match] (Oliver Jones)

 * Fix warning: multiple methods named 'objectForKey:' found
[-Wstrict-selector-match] (Oliver Jones)

 * Fix warning: weak receiver may be unpredictably set to nil
[-Wreceiver-is-weak] (Oliver Jones)

 * Fix missing #pragma clang diagnostic pop (Steven Fisher)

## [1.1.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.1.0) (2012-12-27)

 * Add optional SSL certificate pinning with `#define
_TomboAFNETWORKING_PIN_SSL_CERTIFICATES_` (Dustin Barker)

 * Add `responseStringEncoding` property to `TomboAFURLConnectionOperation` (Mattt
Thompson)

 * Add `userInfo` property to `TomboAFURLConnectionOperation` (Mattt Thompson,
Steven Fisher)

 * Change behavior to cause a failure when an operation is cancelled (Daniel
Tull)

 * Change return type of class constructors to `instancetype` (@guykogus)

 * Change notifications to always being posted on an asynchronously-dispatched
block run on the main queue (Evadne Wu, Mattt Thompson)

 * Change from NSLocalizedString to NSLocalizedStringFromTable with
TomboAFNetworking.strings table for localized strings (Cédric Luthi)

 * Change `-appendPartWithHeaders:body:` to add assertion handler for existence
of body data parameter (Jonathan Beilin)

 * Change `TomboAFHTTPRequestOperation -responseString` to follow guidelines from
RFC 2616 regarding the use of string encoding when none is specified in the
response (Jorge Bernal)

 * Change TomboAFHTTPClient parameter serialization dictionary keys with
`caseInsensitiveCompare:` to ensure
 deterministic ordering of query string parameters, which may otherwise
 cause ambiguous representations of nested parameters (James Coleman,
 Mattt Thompson)

 * Fix -Wstrict-selector-match warnings raised by Xcode 4.6DP3 (Jesse Collis,
Cédric Luthi)

 * Fix NSJSONSerialization crash with Unicode character escapes in JSON
response (Mathijs Kadijk)

 * Fix issue with early return in -startMonitoringNetworkReachability if
network reachability object could not be created (i.e. invalid hostnames)
(Basil Shkara)

 * Fix retain cycles in TomboAFImageRequestOperation.m and TomboAFHTTPClient.m caused by
strong references within blocks (Nick Forge)

 * Fix issue caused by Rails behavior of returning a single space in head :ok
responses, which is interpreted as invalid (Sebastian Ludwig)

 * Fix issue in streaming multipart upload, where final encapsulation boundary
would not be appended if it was larger than the available buffer, causing a
potential timeout (Tomohisa Takaoka, David Kasper)

 * Fix memory leak of network reachability callback block (Mattt Thompson)

 * Fix `-initWithCoder:` for `TomboAFURLConnectionOperation` and `TomboAFHTTPClient` to
cast scalar types (Mattt Thompson)

 * Fix bug in `-enqueueBatchOfHTTPRequestOperations:...` to by using
`addOperations:waitUntilFinished:` instead of adding each operation
individually. (Mattt Thompson)

 * Change `#warning` messages of checks for `CoreServices` and
`MobileCoreServices` to message according to the build target platform (Mattt
Thompson)

 * Change `TomboAFQueryStringFromParametersWithEncoding` to create keys string
representations using the description method as specified in documentation
(Cédric Luthi)

 * Fix __unused keywords for better Xcode indexing (Christian Rasmussen)

 * Fix warning: unused parameter 'x' [-Werror,-Wunused-parameter] (Oliver Jones)

 * Fix warning: property is assumed atomic by default
[-Werror,-Wimplicit-atomic-properties] (Oliver Jones)

 * Fix warning: weak receiver may be unpredictably null in ARC mode
[-Werror,-Wreceiver-is-weak] (Oliver Jones)

 * Fix warning: multiple methods named 'selector' found
[-Werror,-Wstrict-selector-match] (Oliver Jones)

 * Fix warning: 'macro' is not defined, evaluates to 0 (Oliver Jones)

 * Fix warning: atomic by default property 'X' has a user (Oliver Jones)defined
getter (property should be marked 'atomic' if this is intended) [-Werror,
-Wcustom-atomic-properties] (Oliver Jones)

 * Fix warning: 'response' was marked unused but was used
[-Werror,-Wused-but-marked-unused] (Oliver Jones)

 * Fix warning: enumeration value 'TomboAFFinalBoundaryPhase' not explicitly handled
in switch [-Werror,-Wswitch-enum] (Oliver Jones)

## [1.0.1](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.0.1) / 2012-11-01

 * Fix error in multipart upload streaming, where byte range at boundaries
was not correctly calculated (Stan Chang Khin Boon)

 * If a success block is specified to `UIImageView -setImageWithURLRequest:
placeholderImage:success:failure`:, it is now the responsibility of the
block to set the image of the image view (Mattt Thompson)

 * Add `JSONReadingOptions` property to `TomboAFJSONRequestOperation` (Jeremy
 Foo, Mattt Thompson)

 * Using __weak self / __strong self pattern to break retain cycles in
 background task and network reachability blocks (Jerry Beers, Dan Weeks)

 * Fix parameter encoding to leave period (`.`) unescaped (Diego Torres)

 * Fixing last file component in multipart form part creation (Sylver
 Bruneau)

 * Remove executable permission on TomboAFHTTPClient source files (Andrew
 Sardone)

 * Fix warning (error with -Werror) on implicit 64 to 32 conversion (Dan
 Weeks)

 * Add GitHub's .gitignore file (Nate Stedman)

 * Updates to README (@ckmcc)

## [1.0](https://github.com/TomboAFNetworking/TomboAFNetworking/releases/tag/1.0) / 2012-10-15

 * TomboAFNetworking now requires iOS 5 / Mac OSX 10.7 or higher (Mattt Thompson)

 * TomboAFNetworking now uses Automatic Reference Counting (ARC) (Mattt Thompson)

 * TomboAFNetworking raises compiler warnings for missing features when
SystemConfiguration or  CoreServices / MobileCoreServices frameworks are not
included in the project and imported in the precompiled headers (Mattt
Thompson)

 * TomboAFNetworking now raises compiler error when not compiled with ARC (Steven
Fisher)

 * Add `NSCoding` and `NSCopying` protocol conformance to
`TomboAFURLConnectionOperation` and `TomboAFHTTPClient` (Mattt Thompson)

 * Add substantial improvements HTTP multipart streaming support, having
files streamed directly from disk and read sequentially from a custom input
stream (Max Lansing, Stan Chang Khin Boon, Mattt Thompson)

 * Add `TomboAFMultipartFormData -throttleBandwidthWithPacketSize:delay:` as
workaround to issues when uploading over 3G (Mattt Thompson)

 * Add request and response to `userInfo` of errors returned from failing
`TomboAFHTTPRequestOperation` (Mattt Thompson)

 * Add `userInfo` dictionary with current status in reachability changes
(Mattt Thompson)

 * Add `Accept` header for image requests in `UIImageView` category (Bratley
Lower)

 * Add explicit declaration of `NSURLConnection` delegate methods so that
they can be overridden in subclasses (Mattt Thompson, Evan Grim)

 * Add parameter validation to match conditions specified in documentation
(Jason Brennan, Mattt Thompson)

 * Add import to `UIKit` to avoid build errors from `UIDevice` references in
`User-Agent` default header (Blake Watters)

 * Remove `TomboAFJSONUtilities` in favor of `NSJSONSerialization` (Mattt Thompson)

 * Remove `extern` declaration of `TomboAFURLEncodedStringFromStringWithEncoding`
function (`CFURLCreateStringByAddingPercentEscapes` should be used instead)
(Mattt Thompson)

 * Remove `setHTTPShouldHandleCookies:NO` from `TomboAFHTTPClient` (@phamsonha,
Mattt Thompson)

 * Remove `dispatch_retain` / `dispatch_release` with ARC in iOS 6 (Benoit
Bourdon)

 * Fix threading issue with `TomboAFNetworkActivityIndicatorManager` (Eric Patey)

 * Fix issue where `TomboAFNetworkActivityIndicatorManager` count could become
negative (@ap4y)

 * Fix properties to explicitly set options to suppress warnings (Wen-Hao
Lue, Mattt Thompson)

 * Fix compiler warning caused by mismatched types in upload / download
progress blocks (Gareth du Plooy, tomas.a)

 * Fix weak / strong variable relationships in `completionBlock` (Peter
Steinberger)

 * Fix string formatting syntax warnings caused by type mismatch (David
Keegan, Steven Fisher, George Cox)

 * Fix minor potential security vulnerability by explicitly using string
format in NSError localizedDescription value in userInfo (Steven Fisher)

 * Fix `TomboAFURLConnectionOperation -pause` by adding state checks to prevent
likely memory issues when resuming (Mattt Thompson)

 * Fix warning caused by miscast of type when
`CLANG_WARN_IMPLICIT_SIGN_CONVERSION` is set (Steven Fisher)

 * Fix incomplete implementation warning in example code (Steven Fisher)

 * Fix warning caused by using `==` comparator on floats (Steven Fisher)

 * Fix iOS 4 bug where file URLs return `NSURLResponse` rather than
`NSHTTPURLResponse` objects (Leo Lobato)

 * Fix calculation of finished operations in batch operation progress
callback (Mattt Thompson)

 * Fix documentation typos (Steven Fisher, Matthias Wessendorf,
jorge@miv.uk.com)

 * Fix `hasAcceptableStatusCode` to return true after a network failure (Tony
Million)

 * Fix warning about missing prototype for private static method (Stephan
Diederich)

 * Fix issue where `nil` content type resulted in unacceptable content type
(Mattt Thompson)

 * Fix bug related to setup and scheduling of output stream (Stephen Tramer)

 * Fix TomboAFContentTypesFromHTTPHeader to correctly handle comma-delimited
content types (Peyman, Mattt Thompson, @jsm174)

 * Fix crash caused by `_networkReachability` not being set to `NULL` after
releasing (Blake Watters)

 * Fix Podspec to correctly import required headers and use ARC (Eloy Durán,
Blake Watters)

 * Fix query string parameter escaping to leave square brackets unescaped
(Mattt Thompson)

 * Fix query string parameter encoding of `NSNull` values (Daniel Rinser)

 * Fix error caused by referencing `__IPHONE_OS_VERSION_MIN_REQUIRED` without
importing `Availability.h` (Blake Watters)

 * Update example to use App.net API, as Twitter shut off its unauthorized
access to the public timeline (Mattt Thompson)

 * Update `TomboAFURLConnectionOperation` to replace `NSAutoReleasePool` with
`@autoreleasepool` (Mattt Thompson)

 * Update `TomboAFHTTPClient` operation queue to specify
`NSOperationQueueDefaultMaxConcurrentOperationCount` rather than
previously-defined constant (Mattt Thompson)

 * Update `TomboAFHTTPClient -initWithBaseURL` to automatically append trailing
slash, so as to fix common issue where default path is not respected without
trailing slash (Steven Fisher)

 * Update default `TomboAFHTTPClient` `User-Agent` header strings (Mattt Thompson,
Steven Fisher)

 * Update icons for iOS example application (Mattt Thompson)

 * Update `numberOfCompletedOperations` variable in progress block to be
renamed to `numberOfFinishedOperations` (Mattt Thompson)


## 0.10.0 / 2012-06-26

 * Add Twitter Mac Example application (Mattt Thompson)

 * Add note in README about how to set `-fno-objc-arc` flag for multiple files
 at once (Pål Brattberg)

 * Add note in README about 64-bit architecture requirement (@rmuginov, Mattt
 Thompson)

 * Add note in `TomboAFNetworkActivityIndicatorManager` about not having to manually
 manage animation state (Mattt Thompson)

 * Add missing block parameter name for `imageProcessingBlock` (Francois
 Lambert)

 * Add NextiveJson to list of supported JSON libraries (Mattt Thompson)

 * Restore iOS 4.0 compatibility with `addAcceptableStatusCodes:` and
 `addAcceptableContentTypes:` (Zachary Waldowski)

 * Update `TomboAFHTTPClient` to use HTTP pipelining for `GET` and `HEAD` requests by
 default (Mattt Thompson)

 * Remove @private ivar declaration in headers (Peter Steinberger, Mattt
 Thompson)

 * Fix potential premature deallocation of _skippedCharacterSet (Tom Wanielista,
 Mattt Thompson)

 * Fix potential issue in `setOutputStream` by closing any existing
 `outputStream` (Mattt Thompson)

 * Fix filename in TomboAFHTTPClient header (Steven Fisher)

 * Fix documentation for UIImageView+TomboAFNetworking (Mattt Thompson)

 * Fix HTTP multipart form format, which caused issues with Tornado web server
 (Matt Chen)

 * Fix `TomboAFHTTPClient` to not append empty data into multipart form data (Jon
 Parise)

 * Fix URL encoding normalization to not conditionally escape percent-encoded
 strings (João Prado Maia, Kendall Helmstetter Gelner, @cysp, Mattt Thompson)

 * Fix `TomboAFHTTPClient` documentation reference of
 `HTTPRequestOperationWithRequest:success:failure` (Shane Vitarana)

 * Add `TomboAFURLRequestOperation -setRedirectResponseBlock:` (Kevin Harwood)

 * Fix `TomboAFURLConnectionOperation` compilation error by conditionally importing
 UIKit framework (Steven Fisher)

 * Fix issue where image processing block is not called correctly with success
 block in `TomboAFImageRequestOperation` (Sergey Gavrilyuk)

 * Fix leaked dispatch group in batch operations (@andyegorov, Mattt Thompson)

 * Fix support for non-LLVM compilers in `TomboAFNetworkActivityIndicatorManager`
 (Abraham Vegh, Bill Williams, Mattt Thompson)

 * Fix TomboAFHTTPClient to not add unnecessary data when constructing multipart form
 request with nil parameters (Taeho Kim)

## 1.0RC1 / 2012-04-25

 * Add `TomboAFHTTPRequestOperation +addAcceptableStatusCodes /
+addAcceptableContentTypes` to dynamically add acceptable status codes and
content types on the class level (Mattt Thompson)

 * Add support for compound and complex `Accept` headers that include multiple
content types and / or specify a particular character encoding (Mattt Thompson)

 * Add `TomboAFURLConnectionOperation
-setShouldExecuteAsBackgroundTaskWithExpirationHandler:` to have operations
finish once an app becomes inactive (Mattt Thompson)

 * Add support for pausing / resuming request operations (Peter Steinberger,
Mattt Thompson)

 * Improve network reachability functionality in `TomboAFHTTPClient`, including a
distinction between WWan and WiFi reachability (Kevin Harwood, Mattt Thompson)


## 0.9.2 / 2012-04-25

 * Add thread safety to `TomboAFNetworkActivityIndicator` (Peter Steinberger, Mattt
Thompson)

 * Document requirement of available JSON libraries for decoding responses in
`TomboAFJSONRequestOperation` and parameter encoding in `TomboAFHTTPClient` (Mattt
Thompson)

 * Fix `TomboAFHTTPClient` parameter encoding (Mattt Thompson)

 * Fix `TomboAFJSONEncode` and `TomboAFJSONDecode` to use `SBJsonWriter` and
`SBJsonParser` instead of `NSObject+SBJson` (Oliver Eikemeier)

 * Fix bug where `TomboAFJSONDecode` does not return errors (Alex Michaud)

 * Fix compiler warning for undeclared
`TomboAFQueryStringComponentFromKeyAndValueWithEncoding` function (Mattt Thompson)

 * Fix cache policy for URL requests (Peter Steinberger)

 * Fix race condition bug in `UIImageView+TomboAFNetworking` caused by incorrectly
nil-ing request operations (John Wu)

 * Fix reload button in Twitter example (Peter Steinberger)

 * Improve batched operation by deferring execution of batch completion block
until all component request completion blocks have finished (Patrick Hernandez,
Kevin Harwood, Mattt Thompson)

 * Improve performance of image request decoding by dispatching to background
 queue (Mattt Thompson)

 * Revert `TomboAFImageCache` to cache image objects rather than `NSPurgeableData`
(Tony Million, Peter Steinberger, Mattt Thompson)

 * Remove unnecessary KVO `willChangeValueForKey:` / `didChangeValueForKey:`
calls (Peter Steinberger)

 * Remove unnecessary @private ivar declarations in headers (Peter Steinberger,
Mattt Thompson)

 * Remove @try-@catch block wrapping network thread entry point (Charles T. Ahn)


## 0.9.1 / 2012-03-19

 * Create Twitter example application (Mattt Thompson)

 * Add support for nested array and dictionary parameters for query string and
form-encoded requests (Mathieu Hausherr, Josh Chung, Mattt Thompson)

 * Add `TomboAFURLConnectionOperation -setCacheResponseBlock:`, which allows the
behavior of the `NSURLConnectionDelegate` method
`-connection:willCacheResponse:` to be overridden without subclassing (Mattt
Thompson)

 * Add `_TomboAFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_` macros for
NSURLConnection authentication delegate methods (Mattt Thompson)

 * Add properties for custom success / failure callback queues (Peter
Steinberger)

 * Add notifications for network reachability changes to `TomboAFHTTPClient` (Mattt
Thompson)

 * Add `TomboAFHTTPClient -patchPath:` convenience method (Mattt Thompson)

 * Add support for NextiveJson (Adrian Kosmaczewski)

 * Improve network reachability checks (C. Bess)

 * Improve NSIndexSet formatting in error strings (Jon Parise)

 * Document crashing behavior in iOS 4 loading a file:// URL (Mattt Thompson)

 * Fix crash caused by `TomboAFHTTPClient -cancelAllHTTPOperationsWithMethod:` not
checking operation to be instance of `TomboAFHTTPRequestOperation` (Mattt Thompson)

 * Fix crash caused by passing `nil` URL in requests (Sam Soffes)

 * Fix errors caused by connection property not being nil'd out after an
operation finishes (Kevin Harwood, @zdzisiekpu)

 * Fix crash caused by passing `NULL` error pointer when setting `NSInvocation`
in `TomboAFJSONEncode` and `TomboAFJSONDecode` (Tyler Stromberg)

 * Fix batch operation completion block returning on background thread (Patrick
Hernandez)

 * Fix documentation for UIImageView+TomboAFNetworking (Dominic Dagradi)

 * Fix race condition caused by `TomboAFURLConnectionOperation` being cancelled on
main thread, rather than network thread (Erik Olsson)

 * Fix `TomboAFURLEncodedStringFromStringWithEncoding` to correctly handle cases
where % is used as a literal rather than as part of a percent escape code
(Mattt Thompson)

 * Fix missing comma in `+defaultAcceptableContentTypes` for
`TomboAFImageRequestOperation` (Michael Schneider)


## 0.9.0 / 2012-01-23

 * Add thread-safe behavior to `TomboAFURLConnectionOperation` (Mattt Thompson)

 * Add batching of operations for `TomboAFHTTPClient` (Mattt Thompson)

 * Add authentication challenge callback block to override default
 implementation of `connection:didReceiveAuthenticationChallenge:` in
 `TomboAFURLConnectionOperation` (Mattt Thompson)

 * Add `_TomboAFNETWORKING_PREFER_NSJSONSERIALIZATION_`, which, when defined,
 short-circuits the standard preference ordering used in `TomboAFJSONEncode` and
 `TomboAFJSONDecode` to use `NSJSONSerialization` when available, falling back on
 third-party-libraries. (Mattt Thompson, Shane Vitarana)

 * Add custom `description` for `TomboAFURLConnectionOperation` and `TomboAFHTTPClient`
 (Mattt Thompson)

 * Add `text/javascript` to default acceptable content types for
 `TomboAFJSONRequestOperation` (Jake Boxer)

 * Add `imageScale` property to change resolution of images constructed from
 cached data (Štěpán Petrů)

 * Add note about third party JSON libraries in README (David Keegan)

 * `TomboAFQueryStringFromParametersWithEncoding` formats `NSArray` values in the
 form `key[]=value1&key[]=value2` instead of `key=(value1,value2)` (Dan Thorpe)

 * `TomboAFImageRequestOperation -responseImage` on OS X uses `NSBitmapImageRep` to
 determine the correct pixel dimensions of the image (David Keegan)

 * `TomboAFURLConnectionOperation` `connection` has memory management policy `assign`
 to avoid retain cycles caused by `NSURLConnection` retaining its delegate
 (Mattt Thompson)

 * `TomboAFURLConnectionOperation` calls super implementation for `-isReady`,
 following the guidelines for `NSOperation` subclasses (Mattt Thompson)

 * `UIImageView -setImageWithURL:` and related methods call success callback
 after setting image (Cameron Boehmer)

 * Cancel request if an authentication challenge has no suitable credentials in
 `TomboAFURLConnectionOperation -connection:didReceiveAuthenticationChallenge:`
 (Jorge Bernal)

 * Remove exception from
 `multipartFormRequestWithMethod:path:parameters:constructing BodyWithBlock:`
 raised when certain HTTP methods are used. (Mattt Thompson)

 * Remove `TomboAFImageCache` from public API, moving it into private implementation
 of `UIImageView+TomboAFNetworking` (Mattt Thompson)

 * Mac example application makes better use of AppKit technologies and
 conventions (Mattt Thompson)

 * Fix issue with multipart form boundaries in `TomboAFHTTPClient
 -multipartFormRequestWithMethod:path:parameters:constructing BodyWithBlock:`
 (Ray Morgan, Mattt Thompson, Sam Soffes)

 * Fix "File Upload with Progress Callback" code snippet in README (Larry
Legend)

 * Fix to SBJSON invocations in `TomboAFJSONEncode` and `TomboAFJSONDecode` (Matthias
 Tretter, James Frye)

 * Fix documentation for `TomboAFHTTPClient requestWithMethod:path:parameters:`
 (Michael Parker)

 * Fix `Content-Disposition` headers used for multipart form construction
 (Michael Parker)

 * Add network reachability status change callback property to `TomboAFHTTPClient`.
 (Mattt Thompson, Kevin Harwood)

 * Fix exception handling in `TomboAFJSONEncode` and `TomboAFJSONDecode` (David Keegan)

 * Fix `NSData` initialization with string in `TomboAFBase64EncodedStringFromString`
 (Adam Ernst, Mattt Thompson)

 * Fix error check in `appendPartWithFileURL:name:error:` (Warren Moore,
 Baldoph, Mattt Thompson)

 * Fix compiler warnings for certain configurations (Charlie Williams)

 * Fix bug caused by passing zero-length `responseData` to response object
 initializers (Mattt Thompson, Serge Paquet)
