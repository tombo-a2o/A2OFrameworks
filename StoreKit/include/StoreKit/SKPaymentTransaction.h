#import <Foundation/Foundation.h>

typedef NSInteger SKPaymentTransactionState;

@class SKPayment;

@interface SKPaymentTransaction : NSObject

// Getting Information About the Transaction
@property(nonatomic, readonly) NSError *error;
@property(nonatomic, readonly) SKPayment *payment;
@property(nonatomic, readonly) SKPaymentTransactionState transactionState;
@property(nonatomic, readonly) NSString *transactionIdentifier;
@property(nonatomic, readonly) NSDate *transactionDate;
@property(nonatomic, readonly) NSData *transactionReceipt;

// Getting Information about the Transaction's Downloadable Content
@property(nonatomic, readonly) NSArray *downloads;

// Restored Transactions
@property(nonatomic, readonly) SKPaymentTransaction *originalTransaction;
@end

// Constants
enum {
    SKPaymentTransactionStatePurchasing,
    SKPaymentTransactionStatePurchased,
    SKPaymentTransactionStateFailed,
    SKPaymentTransactionStateRestored,
    SKPaymentTransactionStateDeferred,
};
