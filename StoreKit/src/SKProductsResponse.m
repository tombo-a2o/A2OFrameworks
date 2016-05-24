#import <StoreKit/StoreKit.h>

@implementation SKProductsResponse

- (instancetype)init {
    _products = [[NSArray alloc] init];
    return self;
}

- (instancetype)initWithProducts:(NSArray *)products {
    _products = [products copy];
    return self;
}

@end
