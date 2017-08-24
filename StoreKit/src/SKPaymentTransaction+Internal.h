#import <StoreKit/SKPaymentTransaction.h>

@interface SKPaymentTransaction() <NSCoding>
- (instancetype)initWithPayment:(SKPayment *)payment;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@property(nonatomic, readwrite) NSError *error;
@property(nonatomic, readwrite) SKPayment *payment;
@property(nonatomic, readwrite) SKPaymentTransactionState transactionState;
@property(nonatomic, readwrite) NSString *transactionIdentifier;
@property(nonatomic, readwrite) NSDate *transactionDate;
@property(nonatomic, readwrite) NSData *transactionReceipt;

@property(nonatomic, readwrite) NSString *requestId;
@property(nonatomic, readwrite) SKPaymentTransaction *originalTransaction;
@property(nonatomic, readwrite) BOOL requested;
@end
