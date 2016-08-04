#import <Social/Social.h>

@implementation SLRequest
+ (SLRequest *)requestForServiceType:(NSString *)serviceType requestMethod:(SLRequestMethod)requestMethod URL:(NSURL *)url parameters:(NSDictionary *)parameters
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return nil;
}

- (void)performRequestWithHandler:(SLRequestHandler)handler
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

- (NSURLRequest *)preparedURLRequest
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return nil;
}

- (void)addMultipartData:(NSData *)data withName:(NSString *)name type:(NSString *)type filename:(NSString *)filename
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

@end
