#import <StoreKit/SKBase.h>
#import <Foundation/Foundation.h>

@interface SKSerializedTransactionQueue : NSObject
+ (instancetype)defaultQueue;
- (void)push:(SKPaymentTransaction*)transaction;
- (void)update:(SKPaymentTransaction*)transaction;
- (SKPaymentTransaction*)popIncomplete;
@end
