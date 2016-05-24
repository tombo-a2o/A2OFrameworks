#import <Foundation/Foundation.h>

typedef NSInteger SKPaymentTransactionState;

@interface SKPaymentTransaction : NSObject

// Getting Information About the Transaction
@property(nonatomic, readonly) NSError *error;
@property(nonatomic, readonly) SKPayment *payment;
@property(nonatomic, readonly) SKPaymentTransactionState transactionState;
@property(nonatomic, readonly) NSString *transactionIdentifier;
@property(nonatomic, readonly) NSDate *transactionDate;

// Getting Information about the Transaction's Downloadable Content
@property(nonatomic, readonly) NSArray *downloads;

// Restored Transactions
@property(nonatomic, readonly) SKPaymentTransaction *originalTransaction;

// FIXME: move to private
// TODO: reconsider signature
- (instancetype)initWithTransactionIdentifier:(NSString *)transactionIdentifier payment:(SKPayment *)payment transactionState:(SKPaymentTransactionState)transactionState transactionDate:(NSDate *)transactionDate error:(NSError *)error;

@end

// Constants
enum {
    SKPaymentTransactionStatePurchasing,
    SKPaymentTransactionStatePurchased,
    SKPaymentTransactionStateFailed,
    SKPaymentTransactionStateRestored,
    SKPaymentTransactionStateDeferred,
};
