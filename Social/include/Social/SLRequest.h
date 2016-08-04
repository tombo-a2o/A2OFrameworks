#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

typedef NS_ENUM (NSInteger, SLRequestMethod )  {
    SLRequestMethodGET,
    SLRequestMethodPOST,
    SLRequestMethodDELETE,
    SLRequestMethodPUT
};

typedef void(^SLRequestHandler)(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error);

@interface SLRequest : NSObject
+ (SLRequest *)requestForServiceType:(NSString *)serviceType requestMethod:(SLRequestMethod)requestMethod URL:(NSURL *)url parameters:(NSDictionary *)parameters;
@property(retain, nonatomic) ACAccount *account;
@property(readonly, nonatomic) SLRequestMethod requestMethod;
@property(readonly, nonatomic) NSURL *URL;
@property(readonly, nonatomic) NSDictionary *parameters;
- (void)performRequestWithHandler:(SLRequestHandler)handler;
- (NSURLRequest *)preparedURLRequest;
- (void)addMultipartData:(NSData *)data withName:(NSString *)name type:(NSString *)type filename:(NSString *)filename;
@end
