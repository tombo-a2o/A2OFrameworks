#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>
#import <TomboKit/TomboKit.h>
#import <objc/runtime.h>
#import "SKPayment+Internal.h"

static SKPaymentQueue* _defaultQueue;

@implementation SKPaymentQueue {
    NSMutableArray *_transactionObservers;
    TomboKitAPI *_tomboKitAPI;
}

- (instancetype)init {
    _transactionObservers = [[NSMutableArray alloc] init];
    _tomboKitAPI = [[TomboKitAPI alloc] init];
    return [super init];
}

// Returns whether the user is allowed to make payments.
+ (BOOL)canMakePayments
{
    // TODO: implement parental controls etc.
    return YES;
}

// Returns the singleton payment queue instance.
+ (instancetype)defaultQueue
{
    if (!_defaultQueue) {
        _defaultQueue = [[SKPaymentQueue alloc] init];
    }
    return _defaultQueue;
}

// Adds an observer to the payment queue.
- (void)addTransactionObserver:(id<SKPaymentTransactionObserver>)observer
{
    [_transactionObservers addObject:observer];
}

// Removes an observer from the payment queue.
- (void)removeTransactionObserver:(id<SKPaymentTransactionObserver>)observer
{
    [_transactionObservers removeObject:observer];
}

- (void)connectToPaymentAPI:(SKPayment *)payment
{
    SKDebugLog(@"payment: %@", payment);

    if(!payment.requestId) {
        payment.requestId = [NSUUID UUID].UUIDString;
    }

    [_tomboKitAPI postPayments:payment.productIdentifier quantity:payment.quantity requestData:nil applicationUsername:payment.applicationUsername requestId:payment.requestId success:^(NSArray *transactionsArray){
        SKDebugLog(@"%s %@", __FUNCTION__, transactionsArray);
        NSMutableArray *transactions = [[NSMutableArray alloc] init];
        for (NSDictionary *transactionDict in transactionsArray) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *posixLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:posixLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];

            NSDictionary* attributes = [transactionDict objectForKey:@"attributes"];

            NSString *transactionIdentifier = [transactionDict objectForKey:@"id"];
            NSDate *transactionDate = [dateFormatter dateFromString:[attributes objectForKey:@"created_at"]];

            SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithTransactionIdentifier:transactionIdentifier payment:payment transactionState:SKPaymentTransactionStatePurchased transactionDate:transactionDate error:nil];
            [transactions addObject:transaction];
        }
        SKDebugLog(@"transactions: %@", transactions);
        for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
            [observer paymentQueue:self updatedTransactions:transactions];
        }
    } failure:^(NSError *error){
        NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);

        if([error.domain isEqualToString:TomboKitErrorDomain]) {
            // API error
            NSMutableArray *transactions = [[NSMutableArray alloc] init];
            SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithTransactionIdentifier:nil payment:payment transactionState:SKPaymentTransactionStateFailed transactionDate:nil error:error];
            [transactions addObject:transaction];
            for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
                [observer paymentQueue:self updatedTransactions:transactions];
            }
        } else {
            // network error -> retry

        }
    }];
}

static const char* paymentKey = "paymentKey";

// Adds a payment request to the queue.
- (void)addPayment:(SKPayment *)payment
{
    // TODO: Support a "real" queue. Now we don't use a queue. An added payment is immediately executed.
    NSNumberFormatter *quantityFormatter = [[NSNumberFormatter alloc] init];
    [quantityFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];

    NSString *confirmationMessage = [NSString stringWithFormat:@"Do you want to buy %@ %@ for %@", [quantityFormatter stringFromNumber:[NSNumber numberWithLong:payment.quantity]], @"TODO: get title", @"TODO: get price"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Your In-App Purchase"
                                                    message:confirmationMessage
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Buy", nil];
    objc_setAssociatedObject(alert, paymentKey, payment, OBJC_ASSOCIATION_RETAIN);
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        // do nothing
    } else {
        SKPayment* payment = objc_getAssociatedObject(alertView, paymentKey);
        [self connectToPaymentAPI:payment];
    }
}

// Completes a pending transaction.
- (void)finishTransaction:(SKPaymentTransaction *)transaction
{
    // TODO: Support a "real" queue. Now we don't use a queue. An added payment is immediately executed.

    // currently do nothing
}

// Asks the payment queue to restore previously completed purchases.
- (void)restoreCompletedTransactions
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Asks the payment queue to restore previously completed purchases, providing an opaque identifier for the user’s account.
- (void)restoreCompletedTransactionsWithApplicationUsername:(NSString *)username
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Adds a set of downloads to the download list.
- (void)startDownloads:(NSArray *)downloads
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Removes a set of downloads from the download list.
- (void)cancelDownloads:(NSArray *)downloads
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Pauses a set of downloads.
- (void)pauseDownloads:(NSArray *)downloads
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Resumes a set of downloads.
- (void)resumeDownloads:(NSArray *)downloads
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

@end
