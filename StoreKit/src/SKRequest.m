/*
 *  SKRequest.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <StoreKit/StoreKit.h>
#if defined(A2O_EMSCRIPTEN)
#import <tombo_platform.h>
#else
static inline NSString *getTomboAPIServerUrlString(void) {
    return @"https://api.tombo.io";
}
static inline NSString *getUserJwtString(void) {
    return @"dummy_jwt";
}
#endif
#import <TomboAFNetworking/TomboAFNetworking.h>

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

@interface SKProduct (API)
- (instancetype)initWithResponseJSON:(NSDictionary*)json;
+ (NSArray<SKProduct*>*)productsWithResponseJSON:(NSArray*)json;
@end

@implementation SKProduct (API)
+ (NSLocale*)currencyLocale:(NSLocale*)locale currency:(NSString*)currency country:(NSString*)country
{
    NSString *language = [locale objectForKey:NSLocaleLanguageCode];
    SKDebugLog(@"%@ %@ %@ %@", locale.localeIdentifier, country, language, currency);
    NSString *identifier = [NSLocale localeIdentifierFromComponents:@{
                                                                  NSLocaleCountryCode: country,
                                                                  NSLocaleLanguageCode: language,
                                                                  NSLocaleCurrencyCode: currency
                                                                  }];
    return [NSLocale localeWithLocaleIdentifier:identifier];
}

- (instancetype)initWithResponseJSON:(NSDictionary*)json
{
    NSDictionary* attributes = [json objectForKey:@"attributes"];

    NSString *productIdentifier = [attributes objectForKey:@"product_identifier"];
    NSString *localizedTitle = [attributes objectForKey:@"title"];
    NSString *localizedDescription = [attributes objectForKey:@"description"];
    NSNumber *priceObject = [attributes objectForKey:@"price"];
    NSDecimalNumber *hundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *price = [[NSDecimalNumber decimalNumberWithDecimal:[priceObject decimalValue]] decimalNumberByDividingBy:hundred];
    NSLocale *priceLocale = [self.class currencyLocale:[NSLocale currentLocale] currency:[attributes objectForKey:@"currency"] country:[attributes objectForKey:@"country"]];

    return [self initWithProductIdentifier:productIdentifier localizedTitle:localizedTitle localizedDescription:localizedDescription price:price priceLocale:priceLocale];
}
+ (NSArray<SKProduct*>*)productsWithResponseJSON:(NSArray<NSDictionary*>*)json
{
    NSMutableArray *products = [[NSMutableArray alloc] init];
    for (NSDictionary *productDict in json) {
        SKProduct *product = [[SKProduct alloc] initWithResponseJSON:productDict];
        [products addObject:product];
    }
    return products;
}
@end

@implementation SKProductsRequest {
    NSSet *_productIdentifiers;
    TomboAFURLSessionManager *_URLSessionManager;
    BOOL _respondsToRequestDidFinish;
    BOOL _respondsToDidFailWithError;
}

@dynamic delegate;

- (void)setDelegate:(id< SKProductsRequestDelegate >)delegate
{
    [super setDelegate:delegate];
    _respondsToRequestDidFinish = [delegate respondsToSelector:@selector(requestDidFinish:)];
    _respondsToDidFailWithError = [delegate respondsToSelector:@selector(request:didFailWithError:)];
}

// Initializes the request with the set of product identifiers.
- (instancetype)initWithProductIdentifiers:(NSSet<NSString *> *)productIdentifiers
{
    _productIdentifiers = [productIdentifiers mutableCopy];
    return [super init];
}

- (NSDictionary*)requestJSON
{
    NSArray *productIdentifiers = [_productIdentifiers allObjects];
    NSArray *sortedProductIdentifiers = [productIdentifiers sortedArrayUsingSelector:@selector(compare:)];

    return @{@"product_identifiers": [sortedProductIdentifiers componentsJoinedByString: @","], @"user_jwt": getUserJwtString()};
}

// Sends the request to the Apple App Store.
- (void)start
{
    SKDebugLog(@"%s productIdentifiers: %@", __FUNCTION__, _productIdentifiers);

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _URLSessionManager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:configuration];
#ifdef DEBUG
    _URLSessionManager.securityPolicy.validatesDomainName = NO;
    _URLSessionManager.securityPolicy.allowInvalidCertificates = YES;
    SKDebugLog(@"ALLOW INVALID CERTIFICATES");
#endif

    NSString *urlString = [getTomboAPIServerUrlString() stringByAppendingString:@"/products"];
    NSDictionary *parameters = [self requestJSON];
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[TomboAFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:parameters error:&serializerError];

    _URLSessionManager.responseSerializer = [TomboAFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        _URLSessionManager = nil;
        SKDebugLog(@"TomboAPI::getProducts error: %@ response: %@, responseObject:%@", error, response, responseObject);
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            if(_respondsToDidFailWithError) {
                [self.delegate request:self didFailWithError:error];
            }
        } else {
            NSArray *data = [responseObject objectForKey:@"data"];

            NSArray<SKProduct*> *products = [SKProduct productsWithResponseJSON:data];
            NSLog(@"%@", products);
            NSMutableSet *invalidProductIdentifiers = [_productIdentifiers mutableCopy];
            for(SKProduct *product in products) {
                [invalidProductIdentifiers removeObject:product.productIdentifier];
            }
            SKProductsResponse *productsResponse = [[SKProductsResponse alloc] initWithProducts:products invalidProductIdentifiers:[invalidProductIdentifiers allObjects]];




            SKDebugLog(@"products: %@", productsResponse);

            // NOTE: I don't know the sequence of calling these notification methods
            [self.delegate productsRequest:self didReceiveResponse:productsResponse];
            if(_respondsToRequestDidFinish) {
                [self.delegate requestDidFinish:self];
            }
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
- (instancetype)initWithReceiptProperties:(NSDictionary<NSString *, id> *)properties
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
