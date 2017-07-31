#import <StoreKit/StoreKit.h>
#import <TomboKit/TomboKit.h>

NSString * const SKReceiptPropertyIsExpired = @"expired";
NSString * const SKReceiptPropertyIsRevoked = @"revoked";
NSString * const SKReceiptPropertyIsVolumePurchase = @"vpp";

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
    TomboKitAPI *_tomboKitAPI;
    NSSet *_productIdentifiers;
    SKProductsResponse *_productsResponse;
}

@dynamic delegate;

// Initializes the request with the set of product identifiers.
- (instancetype)initWithProductIdentifiers:(NSSet/*<NSString *>*/ *)productIdentifiers
{
    _productIdentifiers = [productIdentifiers mutableCopy];
    _tomboKitAPI = [[TomboKitAPI alloc] init];
    return [super init];
}


// Sends the request to the Apple App Store.
- (void)start
{
    SKDebugLog(@"productIdentifiers: %@", _productIdentifiers);

    _productsResponse = nil;

    NSArray *productIdentifiers = [_productIdentifiers allObjects];
    productIdentifiers = [productIdentifiers sortedArrayUsingSelector:@selector(compare:)];

    [_tomboKitAPI getProducts:productIdentifiers success:^(NSDictionary *data) {
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
        if([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
            [self.delegate requestDidFinish:self];
        }
    } failure:^(NSError *error) {
        NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
        if([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
            [self.delegate request:self didFailWithError:error];
        }
    }];
}

// Cancels a previously started request.
- (void)cancel
{
    [_tomboKitAPI cancel];
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
