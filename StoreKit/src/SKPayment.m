#import <StoreKit/SKPayment.h>

@implementation SKPayment

- (instancetype)initWithProductIdentifier:(NSString *)productIdentifier
{
    if(!productIdentifier) return nil;

    self = [self init];
    if(self) {
        _productIdentifier = [productIdentifier copy];
        _quantity = 1;
    }
    return self;
}

// Returns a new payment for the specified product.
+ (instancetype)paymentWithProduct:(SKProduct *)product
{
    return [[self alloc] initWithProductIdentifier:product.productIdentifier];
}

// Returns a new payment with the specified product identifier.
+ (id)paymentWithProductIdentifier:(NSString *)identifier
{
    return [[self alloc] initWithProductIdentifier:identifier];
}

- (id)copyWithZone:(NSZone *)zone
{
    SKPayment *payment = [[SKPayment allocWithZone:zone] init];
    payment->_productIdentifier = [_productIdentifier copyWithZone:zone];
    payment->_quantity = _quantity;
    payment->_requestData = [_requestData copy];
    payment->_applicationUsername = [_applicationUsername copy];
    return payment;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    SKMutablePayment *payment = [[SKMutablePayment allocWithZone:zone] init];
    payment.productIdentifier = [_productIdentifier mutableCopyWithZone:zone];
    payment.quantity = _quantity;
    payment.requestData = [_requestData copy];
    payment.applicationUsername = [_applicationUsername copy];
    return payment;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@ 0x%p> {productIdentifier:%@, quantity:%d}", NSStringFromClass([self class]), self, _productIdentifier, _quantity];
}

@end

@implementation SKMutablePayment

@dynamic productIdentifier;
@dynamic quantity;
@dynamic requestData;
@dynamic applicationUsername;

- (void)setProductIdentifier:(NSString*)productIdentifier
{
    _productIdentifier = productIdentifier;
}

- (void)setQuantity:(NSInteger)quantity
{
    _quantity = quantity;
}

- (void)setRequestData:(NSData*)requestData
{
    _requestData = requestData;
}

- (void)setApplicationUsername:(NSString*)applicationUsername
{
    _applicationUsername = applicationUsername;
}
@end
