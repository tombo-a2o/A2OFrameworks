#import <StoreKit/SKBase.h>
#import <Foundation/Foundation.h>

@interface SKPaymentTransactionStore : NSObject
+ (instancetype)defaultStore;
- (void)insert:(SKPaymentTransaction*)transaction;
- (void)update:(SKPaymentTransaction*)transaction;
- (SKPaymentTransaction*)incompleteTransaction;
- (NSArray<SKPaymentTransaction*>*)incompleteTransactions;
@end
