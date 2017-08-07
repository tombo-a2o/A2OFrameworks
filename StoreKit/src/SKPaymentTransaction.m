#import <StoreKit/StoreKit.h>

@implementation SKPaymentTransaction

- (instancetype)initWithTransactionIdentifier:(NSString *)transactionIdentifier payment:(SKPayment *)payment transactionState:(SKPaymentTransactionState)transactionState transactionDate:(NSDate *)transactionDate error:(NSError *)error
{
    _transactionIdentifier = transactionIdentifier;
    _payment = payment;
    _transactionState = transactionState;
    _transactionDate = transactionDate;
    _error = error;

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
    return [NSString stringWithFormat:@"<%@ 0x%p> {%@, %@, %@, %@, %@}", NSStringFromClass([self class]), self, _transactionIdentifier, _payment, stateString, _transactionDate, _error];
}

@end
