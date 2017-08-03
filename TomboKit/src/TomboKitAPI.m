#import <TomboKit/TomboKit.h>
#import <TomboAFNetworking/TomboAFNetworking.h>

extern char* a2oApiServerUrl(void);

@implementation TomboKitAPI {
    // TODO: Split _URLSessionManager
    TomboAFURLSessionManager *_URLSessionManager;
}

+ (NSString*)serverUrl
{
    char* server = a2oApiServerUrl();
    NSString *url = [NSString stringWithUTF8String:server];
    free(server);
    return url;
}

- (NSString*)paymentsURL
{
    return [self.class.serverUrl stringByAppendingString:@"/payments"];
}

- (NSString*)productsURL
{
    return [self.class.serverUrl stringByAppendingString:@"/products"];
}

- (void)postPayments:(NSString *)productIdentifier
            quantity:(NSInteger)quantity
         requestData:(NSData *)requestData
 applicationUsername:(NSString *)applicationUsername
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failure
{
    // TODO: show detailed log
    TomboKitDebugLog(@"TomboAPI::postPayments");

    if (_URLSessionManager) {
        failure([[NSError alloc] initWithDomain:@"TomboKitErrorDomain"
                                           code:0
                                       userInfo:@{}
        ]);
    }

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _URLSessionManager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:configuration];
#ifdef DEBUG
    _URLSessionManager.securityPolicy.validatesDomainName = NO;
    _URLSessionManager.securityPolicy.allowInvalidCertificates = YES;
    TomboKitDebugLog(@"ALLOW INVALID CERTIFICATES");
#endif

    NSObject *appUsername = applicationUsername;
    if (appUsername == nil) {
        appUsername = [NSNull null];
    }

    NSDictionary *parameters = @{@"payments": @[@{
                                                    @"productIdentifier": productIdentifier,
                                                    @"quantity": [NSNumber numberWithInteger:quantity],
                                                    @"requestData": [NSNull null],
                                                    @"applicationUsername": appUsername
                                                    }]};
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[TomboAFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:self.paymentsURL parameters:parameters error:&serializerError];
    _URLSessionManager.responseSerializer = [TomboAFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        _URLSessionManager = nil;

        TomboKitDebugLog(@"TomboAPI::postPayments error: %@ response: %@", error, response);
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            failure(error);
        } else {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            success(data);
        }
    }];

    [dataTask resume];
}

- (void)getProducts:(NSArray *)productIdentifiers
            success:(void (^)(NSDictionary *))success
            failure:(void (^)(NSError *))failure
{
    TomboKitDebugLog(@"TomboAPI::getProducts productIdentifiers: %@", productIdentifiers);

    if (_URLSessionManager) {
        failure([[NSError alloc] initWithDomain:@"TomboKitErrorDomain"
                                           code:0
                                       userInfo:@{}
        ]);
    }

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _URLSessionManager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:configuration];
#ifdef DEBUG
    _URLSessionManager.securityPolicy.validatesDomainName = NO;
    _URLSessionManager.securityPolicy.allowInvalidCertificates = YES;
    TomboKitDebugLog(@"ALLOW INVALID CERTIFICATES");
#endif

    NSArray *sortedProductIdentifiers = [productIdentifiers sortedArrayUsingSelector:@selector(compare:)];

    NSDictionary *parameters = @{@"product_identifier": [sortedProductIdentifiers componentsJoinedByString: @","]};
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[TomboAFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:self.productsURL parameters:parameters error:&serializerError];

    _URLSessionManager.responseSerializer = [TomboAFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        _URLSessionManager = nil;
        TomboKitDebugLog(@"TomboAPI::getProducts error: %@ response: %@", error, response);
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            failure(error);
        } else {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            success(data);
        }
    }];

    [dataTask resume];
}

- (void)cancel
{
    [_URLSessionManager.operationQueue cancelAllOperations];
}

@end
