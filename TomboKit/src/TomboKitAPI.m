#import <TomboKit/TomboKit.h>
#import <TomboAFNetworking/TomboAFNetworking.h>

NSString* TomboKitErrorDomain = @"io.tombo.a2o.tombokiterror";

extern char* a2oApiServerUrl(void);
extern char* a2oGetUserJwt(void);

#if !defined(A2O_EMSCRIPTEN) // for test
char* a2oApiServerUrl(void)
{
    const char jwt[] = "https://api.tombo.io";
    char *ret = (char*)malloc(sizeof(jwt));
    strncpy(ret, jwt, sizeof(jwt));
    return ret;
}

char* a2oGetUserJwt(void)
{
    const char jwt[] = "dummy_jwt";
    char *ret = (char*)malloc(sizeof(jwt));
    strncpy(ret, jwt, sizeof(jwt));
    return ret;
}
#endif

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

- (NSString*)userJwt
{
    char* jwtString = a2oGetUserJwt();
    NSString *jwt = [NSString stringWithUTF8String:jwtString];
    free(jwtString);
    return jwt;
}

- (NSString*)paymentsURL
{
    return [self.class.serverUrl stringByAppendingString:@"/payments"];
}

- (NSString*)productsURL
{
    return [self.class.serverUrl stringByAppendingString:@"/products"];
}

// TODO handle multiple payments
- (void)postPayments:(NSString *)productIdentifier
            quantity:(NSInteger)quantity
         requestData:(NSData *)requestData
 applicationUsername:(NSString *)applicationUsername
           requestId:(NSString*)requestId
             success:(void (^)(NSArray *))success
             failure:(void (^)(NSError *))failure
{
    // TODO: show detailed log
    TomboKitDebugLog(@"TomboAPI::postPayments");

    if (_URLSessionManager) {
        failure([[NSError alloc] initWithDomain:TomboKitErrorDomain
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
    TomboKitDebugLog(@"%@ %d %@ %@", productIdentifier, quantity, requestData, appUsername);

    NSDictionary *parameters = @{
        @"payments": @[@{
            @"productIdentifier": productIdentifier,
            @"quantity": [NSNumber numberWithInteger:quantity],
            @"requestData": [NSNull null],
            @"applicationUsername": appUsername,
            @"requestId": requestId
        }],
        @"user_jwt": self.userJwt
    };
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[TomboAFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:self.paymentsURL parameters:parameters error:&serializerError];
    _URLSessionManager.responseSerializer = [TomboAFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        _URLSessionManager = nil;

        TomboKitDebugLog(@"TomboAPI::postPayments error: %@ response: %@", error, response);
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            NSArray *errors = [responseObject objectForKey:@"errors"];
            if(errors) {
                NSString *errorMessage = errors[0];
                error = [NSError errorWithDomain:TomboKitErrorDomain code:0 userInfo:@{
                    NSLocalizedDescriptionKey: errorMessage
                }];
            }
            failure(error);
        } else {
            NSArray *payments = [responseObject objectForKey:@"data"];
            success(payments);
        }
    }];

    [dataTask resume];
}

- (void)getProducts:(NSArray *)productIdentifiers
            success:(void (^)(NSArray *))success
            failure:(void (^)(NSError *))failure
{
    TomboKitDebugLog(@"TomboAPI::getProducts productIdentifiers: %@", productIdentifiers);

    if (_URLSessionManager) {
        failure([[NSError alloc] initWithDomain:TomboKitErrorDomain
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

    NSDictionary *parameters = @{@"product_identifiers": [sortedProductIdentifiers componentsJoinedByString: @","], @"user_jwt": self.userJwt};
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[TomboAFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:self.productsURL parameters:parameters error:&serializerError];

    _URLSessionManager.responseSerializer = [TomboAFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        _URLSessionManager = nil;
        TomboKitDebugLog(@"TomboAPI::getProducts error: %@ response: %@, responseObject:%@", error, response, responseObject);
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            failure(error);
        } else {
            NSArray *data = [responseObject objectForKey:@"data"];
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
