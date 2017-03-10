#import <Foundation/Foundation.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentTransaction.h>

@class SKPaymentQueue;

@protocol SKPaymentTransactionObserver <NSObject>

// Handing Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray/*<SKPaymentTransaction *>*/ *)transactions;
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray/*<SKPaymentTransaction *>*/ *)transactions;

// Handling Restored Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue;

// Handling Download Actions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray/*<SKDownload *>*/ *)downloads;

@end

@interface SKPaymentQueue : NSObject

// Determining Whether the User Can Make Payments
+ (BOOL)canMakePayments;

// Getting the Queue
+ (instancetype)defaultQueue;

// Adding and Removing the Observer
- (void)addTransactionObserver:(id<SKPaymentTransactionObserver>)observer;
- (void)removeTransactionObserver:(id<SKPaymentTransactionObserver>)observer;

// Managing Transactions
@property(nonatomic, readonly) NSArray *transactions;
- (void)addPayment:(SKPayment *)payment;
- (void)finishTransaction:(SKPaymentTransaction *)transaction;

// Restoring Purchases
- (void)restoreCompletedTransactions;
- (void)restoreCompletedTransactionsWithApplicationUsername:(NSString *)username;

// Downloading Content
- (void)startDownloads:(NSArray/*<SKDownload *>*/*)downloads;
- (void)cancelDownloads:(NSArray/*<SKDownload *>*/*)downloads;
- (void)pauseDownloads:(NSArray/*<SKDownload *>*/*)downloads;
- (void)resumeDownloads:(NSArray/*<SKDownload *>*/ *)downloads;

// FIXME: move to private (for testing)
- (void)connectToPaymentAPI:(SKPayment *)payment;

@end

extern NSString * const SKTomboPaymentsURL;