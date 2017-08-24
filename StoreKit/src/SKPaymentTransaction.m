#import <StoreKit/StoreKit.h>
#import "SKPaymentTransaction+Internal.h"
#import "SKPayment+Internal.h"

@implementation SKPaymentTransaction

- (instancetype)initWithPayment:(SKPayment *)payment
{
    if(!payment) return nil;

    _transactionIdentifier = nil;
    _payment = [payment copy];
    _transactionState = SKPaymentTransactionStatePurchasing;
    _transactionDate = nil;
    _error = nil;
    _requestId = [NSUUID UUID].UUIDString.lowercaseString;
    _requested = NO;

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    _transactionIdentifier = [decoder decodeObjectForKey:@"transactionIdentifier"];
    _payment = [decoder decodeObjectForKey:@"payment"];
    _transactionState = [decoder decodeIntForKey:@"transactionState"];
    _transactionDate = [decoder decodeObjectForKey:@"transactionDate"];
    _error = [decoder decodeObjectForKey:@"error"];
    _requestId = [decoder decodeObjectForKey:@"requestId"];
    _requested = [decoder decodeBoolForKey:@"requested"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_transactionIdentifier forKey:@"transactionIdentifier"];
    [encoder encodeObject:_payment forKey:@"payment"];
    [encoder encodeInt:_transactionState forKey:@"transactionState"];
    [encoder encodeObject:_transactionDate forKey:@"transactionDate"];
    [encoder encodeObject:_error forKey:@"error"];
    [encoder encodeObject:_requestId forKey:@"requestId"];
    [encoder encodeBool:_requested forKey:@"requested"];
}

- (NSString*)description
{
    NSString *stateString = nil;
    switch(_transactionState) {
    case SKPaymentTransactionStatePurchasing:
        stateString = @"SKPaymentTransactionStatePurchasing";
        break;
    case SKPaymentTransactionStatePurchased:
        stateString = @"SKPaymentTransactionStatePurchased";
        break;
    case SKPaymentTransactionStateFailed:
        stateString = @"SKPaymentTransactionStateFailed";
        break;
    case SKPaymentTransactionStateRestored:
        stateString = @"SKPaymentTransactionStateRestored";
        break;
    case SKPaymentTransactionStateDeferred:
        stateString = @"SKPaymentTransactionStateDeferred";
        break;
    }
    return [NSString stringWithFormat:@"<%@ 0x%p> {%@, %@, %@, %@, %@, %@}", NSStringFromClass([self class]), self, _transactionIdentifier, _payment, stateString, _transactionDate, _requestId, _error];
}

- (BOOL)isEqual:(id)object
{
    SKPaymentTransaction *transaction = (SKPaymentTransaction*)object;
    return [_requestId isEqual:transaction.requestId];
}

- (NSUInteger)hash {
    return [_requestId hash];
}

@end
