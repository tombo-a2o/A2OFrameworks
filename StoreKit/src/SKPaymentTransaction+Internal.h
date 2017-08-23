#import <StoreKit/SKPaymentTransaction.h>

@interface SKPaymentTransaction()
- (instancetype)initWithPayment:(SKPayment *)payment;

@property(nonatomic, readwrite) NSError *error;
@property(nonatomic, readwrite) SKPayment *payment;
@property(nonatomic, readwrite) SKPaymentTransactionState transactionState;
@property(nonatomic, readwrite) NSString *transactionIdentifier;
@property(nonatomic, readwrite) NSDate *transactionDate;
@property(nonatomic, readwrite) NSData *transactionReceipt;

@property(nonatomic, readwrite) NSString *requestId;
@property(nonatomic, readwrite) SKPaymentTransaction *originalTransaction;
@end
