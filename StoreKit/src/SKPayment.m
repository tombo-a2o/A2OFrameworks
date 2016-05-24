#import <StoreKit/SKPayment.h>

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

@end

@implementation SKMutablePayment

@synthesize productIdentifier;
@synthesize quantity;
@synthesize requestData;

@end