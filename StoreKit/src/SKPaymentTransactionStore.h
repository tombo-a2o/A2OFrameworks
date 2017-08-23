#import <StoreKit/SKBase.h>
#import <Foundation/Foundation.h>

@class SKPaymentTransaction;

@interface SKPaymentTransactionStore : NSObject
+ (instancetype)defaultStore;
- (void)insert:(SKPaymentTransaction*)transaction;
- (void)update:(SKPaymentTransaction*)transaction;
- (void)remove:(SKPaymentTransaction*)transaction;
- (SKPaymentTransaction*)transactionWithRequestId:(NSString*)requestId;
- (SKPaymentTransaction*)incompleteTransaction;
- (NSArray<SKPaymentTransaction*>*)incompleteTransactions;
- (NSArray<SKPaymentTransaction*>*)allTransactions;
@end
