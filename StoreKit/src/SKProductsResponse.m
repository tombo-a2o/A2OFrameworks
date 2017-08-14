#import <StoreKit/StoreKit.h>

@implementation SKProductsResponse

- (instancetype)init {
    _products = [[NSArray alloc] init];
    _invalidProductIdentifiers = [[NSArray alloc] init];
    return self;
}

- (instancetype)initWithProducts:(NSArray *)products invalidProductIdentifiers:(NSArray*)invalidProductIdentifiers {
    _products = [products copy];
    _invalidProductIdentifiers = [invalidProductIdentifiers copy];
    return self;
}

@end
