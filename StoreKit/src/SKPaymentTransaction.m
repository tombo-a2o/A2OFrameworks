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

@end