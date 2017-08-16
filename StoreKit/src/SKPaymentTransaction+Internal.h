#import <StoreKit/SKPayment.h>

@interface SKPaymentTransaction()
- (instancetype)initWithPayment:(SKPayment *)payment;

@property(nonatomic, readwrite) NSError *error;
@property(nonatomic, readwrite) SKPaymentTransactionState transactionState;
@property(nonatomic, readwrite) NSString *transactionIdentifier;
@property(nonatomic, readwrite) NSDate *transactionDate;
@property(nonatomic, readwrite) NSData *transactionReceipt;

@property(nonatomic, readwrite) NSString *requestId;
@end
