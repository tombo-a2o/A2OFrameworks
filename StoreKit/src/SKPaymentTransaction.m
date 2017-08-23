#import <StoreKit/StoreKit.h>
#import "SKPaymentTransaction+Internal.h"

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

    return self;
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
