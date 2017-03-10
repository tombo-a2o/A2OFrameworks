#import <StoreKit/StoreKit.h>
#import "SKAFNetworking.h"

NSString * const SKReceiptPropertyIsExpired = @"expired";
NSString * const SKReceiptPropertyIsRevoked = @"revoked";
NSString * const SKReceiptPropertyIsVolumePurchase = @"vpp";
NSString * const SKTomboProductsURL = @"https://api.tom.bo/products";

@implementation SKRequest

- (void)start
{
    // SKRequest is an abstract class.
    [self doesNotRecognizeSelector:_cmd];
}

- (void)cancel
{
    // SKRequest is an abstract class.
    [self doesNotRecognizeSelector:_cmd];
}

@end

@implementation SKProductsRequest {
    NSSet *_productIdentifiers;
    SKProductsResponse *_productsResponse;
    SKAFURLSessionManager *_URLSessionManager;
}

@dynamic delegate;

// Initializes the request with the set of product identifiers.
- (instancetype)initWithProductIdentifiers:(NSSet/*<NSString *>*/ *)productIdentifiers
{
    _productIdentifiers = [productIdentifiers mutableCopy];
    return [super init];
}


// Sends the request to the Apple App Store.
- (void)start
{
    SKDebugLog(@"productIdentifiers: %@", _productIdentifiers);

    _productsResponse = nil;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _URLSessionManager = [[SKAFURLSessionManager alloc] initWithSessionConfiguration:configuration];
#ifdef DEBUG
    _URLSessionManager.securityPolicy.validatesDomainName = NO;
    _URLSessionManager.securityPolicy.allowInvalidCertificates = YES;
    SKDebugLog(@"ALLOW INVALID CERTIFICATES");
#endif

    NSArray *productIdentifiers = [_productIdentifiers allObjects];
    productIdentifiers = [productIdentifiers sortedArrayUsingSelector:@selector(compare:)];

    NSDictionary *parameters = @{@"product_identifier": [productIdentifiers componentsJoinedByString: @","]};
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[SKAFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:SKTomboProductsURL parameters:parameters error:&serializerError];

    _URLSessionManager.responseSerializer = [SKAFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        _URLSessionManager = nil;
        SKDebugLog(@"error: %@ response: %@", error, response);
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            [self.delegate request:self didFailWithError:error];
        } else {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSArray *productsArray = [data objectForKey:@"products"];
            NSMutableArray *products = [[NSMutableArray alloc] init];
            for (NSDictionary *productDict in productsArray) {
                NSString *productIdentifier = [productDict objectForKey:@"productIdentifier"];
                NSString *localizedTitle = [productDict objectForKey:@"localizedTitle"];
                NSString *localizedDescription = [productDict objectForKey:@"localizedDescription"];
                NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:[productDict objectForKey:@"price"]];
                NSLocale *priceLocale = [[NSLocale alloc] initWithLocaleIdentifier:[productDict objectForKey:@"priceLocale"]];

                SKProduct *product = [[SKProduct alloc] initWithProductIdentifier:productIdentifier localizedTitle:localizedTitle localizedDescription:localizedDescription price:price priceLocale:priceLocale];
                [products addObject:product];
            }
            _productsResponse = [[SKProductsResponse alloc] initWithProducts:products];

            SKDebugLog(@"products: %@", _productsResponse);

            // NOTE: I don't know the sequence of calling these notification methods
            [self.delegate productsRequest:self didReceiveResponse:_productsResponse];
            [self.delegate requestDidFinish:self];
        }
    }];

    [dataTask resume];
}

// Cancels a previously started request.
- (void)cancel
{
    [_URLSessionManager.operationQueue cancelAllOperations];
}

@end

@implementation SKReceiptRefreshRequest

@dynamic delegate;

// Initialized a receipt refresh request with optional properties.
- (instancetype)initWithReceiptProperties:(NSDictionary/*<NSString *, id>*/ *)properties
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

// Sends the request to the Apple App Store.
- (void)start
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Cancels a previously started request.
- (void)cancel
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

@end
