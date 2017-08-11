#import <StoreKit/SKPayment.h>
#import "SKPayment+Internal.h"

@implementation SKPayment

- (instancetype)init
{
    _quantity = 1;
    return [super init];
}

- (instancetype)initWithProductIdentifier:(NSString *)productIdentifier
{
    _productIdentifier = [productIdentifier copy];
    return [self init];
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
    return payment;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    SKMutablePayment *payment = [[SKMutablePayment allocWithZone:zone] init];
    payment.productIdentifier = [_productIdentifier mutableCopyWithZone:zone];
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

@end
