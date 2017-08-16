#import <StoreKit/SKBase.h>
#import <Foundation/Foundation.h>

@interface SKPaymentTransactionStore : NSObject
+ (instancetype)defaultStore;
- (void)push:(SKPaymentTransaction*)transaction;
- (void)update:(SKPaymentTransaction*)transaction;
- (SKPaymentTransaction*)popIncomplete;
@end
