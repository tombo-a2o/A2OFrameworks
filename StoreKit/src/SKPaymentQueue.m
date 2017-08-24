#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "SKPaymentTransaction+Internal.h"
#import "SKPaymentTransactionStore.h"
#import <TomboAFNetworking/TomboAFNetworking.h>

#if defined(A2O_EMSCRIPTEN)
    #import <tombo_platform.h>
#else
    static inline NSString *getTomboAPIServerUrlString(void) {
        return @"https://api.tombo.io";
    }
    static inline NSString *getUserJwtString(void) {
        return @"dummy_jwt";
    }
#endif

static SKPaymentQueue* _defaultQueue;

NSString * const SKErrorDomain = @"io.tombo.storekit.error";
NSString * const SKServerErrorDomain = @"io.tombo.storekit.servererror";

@interface SKPaymentTransaction (API)
- (NSDictionary*)requestJSON;
- (BOOL)updateWithResponseJSON:(NSDictionary*)json;
@end

@implementation SKPaymentTransaction (API)

- (NSDictionary*)requestJSON
{
    SKPayment *payment = self.payment;
    return @{
        @"payment": @{
            @"productIdentifier": payment.productIdentifier,
            @"quantity": [NSNumber numberWithInteger:payment.quantity],
            @"requestData": payment.requestData ?: [NSNull null],
            @"applicationUsername": payment.applicationUsername ?: [NSNull null],
            @"requestId": self.requestId
        },
        @"user_jwt": getUserJwtString()
    };
}

static NSDate* parseDate(NSString* dateString)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *posixLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:posixLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];

    return [dateFormatter dateFromString:dateString];
}

- (instancetype)initWithResponseJSON:(NSDictionary*)json
{
    self = [super init];

    NSDictionary* attributes = [json objectForKey:@"attributes"];

    SKMutablePayment *payment = [[SKPayment paymentWithProductIdentifier:[attributes objectForKey:@"product_identifier"]] mutableCopy];
    payment.quantity = [[attributes objectForKey:@"quantity"] integerValue];

    self.payment = [payment copy];
    self.transactionIdentifier = [json objectForKey:@"id"];
    self.transactionState = [[attributes objectForKey:@"status"] integerValue];
    self.transactionDate = parseDate([attributes objectForKey:@"created_at"]);
    self.requestId = [attributes objectForKey:@"request_id"];

    return self;
}

- (BOOL)updateWithResponseJSON:(NSDictionary*)json
{
    NSDictionary* attributes = [json objectForKey:@"attributes"];

    NSInteger status = [[attributes objectForKey:@"status"] integerValue];
    NSString *requestId = [attributes objectForKey:@"request_id"];

    /*
        client \ server| DEFAULT | CHARGE_FAILED | CHARGE_COMPLETE | COMPLETE
        Purchasing     | ignore  | -> Failed     | -> Purchsed     | error
        Purchased      | error   | error         | ignore          | ignore
        Failed         | error   | ignore        | error           | error
        Restored       | ?       | ?             | ?               | ?
        Deferred       | ?       | ?             | ?               | ?
    */

    SKDebugLog(@"%d %@ %@", status, requestId, self);

    if(![self.requestId.lowercaseString isEqualToString:requestId.lowercaseString]) {
        // TODO log error
        return NO;
    }

    if(self.transactionState != SKPaymentTransactionStatePurchasing) {
        // TODO log error
        return NO;
    }

    switch(status) {
    case 0: // nothing changed
        return NO;
    case 1: // failed
        self.transactionState = SKPaymentTransactionStateFailed;
        return YES;
    case 2: // sucesss
        self.transactionState = SKPaymentTransactionStatePurchased;
        self.transactionIdentifier = [json objectForKey:@"id"];
        self.transactionDate = parseDate([attributes objectForKey:@"created_at"]);
        return YES;
    default:
        // TODO log error
        return NO;
    }
}

@end

@implementation SKPaymentQueue {
    NSMutableArray *_transactionObservers;
    SKPaymentTransactionStore *_transactionStore;
}

- (instancetype)init {
    self = [super init];

    _transactionObservers = [[NSMutableArray alloc] init];
    _transactionStore = [SKPaymentTransactionStore defaultStore];

    [self turnRemainingTransactionsFailed];
    return self;
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
    static BOOL firstObserver = YES;

    [_transactionObservers addObject:observer];

    if(firstObserver) {
        firstObserver = NO;
        NSArray* transactions = [_transactionStore allTransactions];
        if(transactions.count > 0) {
            [self notifyUpdatedTransactions:transactions];
        }
    }
}

// Removes an observer from the payment queue.
- (void)removeTransactionObserver:(id<SKPaymentTransactionObserver>)observer
{
    [_transactionObservers removeObject:observer];
}

- (void)notifyUpdatedTransaction:(SKPaymentTransaction*)transaction
{
    [self notifyUpdatedTransactions:[NSArray arrayWithObject:transaction]];
}

- (void)notifyUpdatedTransactions:(NSArray<SKPaymentTransaction*>*)transactions
{
    SKDebugLog(@"updatedTransactions: %@", transactions);

    for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
        [observer paymentQueue:self updatedTransactions:transactions];
    }
}

- (void)notifyRemovedTransaction:(SKPaymentTransaction*)transaction
{
    NSArray *removedTransactions = [NSArray arrayWithObject:transaction];

    SKDebugLog(@"updatedTransactions: %@", removedTransactions);

    for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
        if([observer respondsToSelector:@selector(paymentQueue:removedTransactions:)]) {
            [observer paymentQueue:self removedTransactions:removedTransactions];
        }
    }
}

- (void)notifyRestoreCompletion
{
    for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
        if([observer respondsToSelector:@selector(paymentQueueRestoreCompletedTransactionsFinished:)]) {
            [observer paymentQueueRestoreCompletedTransactionsFinished:self];
        }
    }
}

- (void)notifyRestoreFailed:(NSError*)error
{
    SKDebugLog(@"error: %@", error);

    for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
        if([observer respondsToSelector:@selector(paymentQueue:restoreCompletedTransactionsFailedWithError:)]) {
            [observer paymentQueue:self restoreCompletedTransactionsFailedWithError:error];
        }
    }
}

- (void)postPaymentTransaction:(SKPaymentTransaction *)transaction completionHandler:(void (^)(BOOL))completionHandler
{
    // TODO: show detailed log
    SKDebugLog(@"transaction: %@", transaction);

    transaction.requested = YES;

    [self connectToPaymentAPI:[transaction requestJSON] path:@"/payments" method:@"POST" completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        SKDebugLog(@"TomboAPI::postPayments error: %@ response: %@, responseObject:%@", error, response, responseObject);
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            if(responseObject) {
                NSArray *errors = [responseObject objectForKey:@"errors"];
                if(errors) {
                    NSDictionary *errorDic = errors[0];
                    NSString *errorDetail = [errorDic objectForKey:@"detail"];
                    if(errorDetail) {
                        error = [NSError errorWithDomain:SKServerErrorDomain code:0 userInfo:@{
                            NSLocalizedDescriptionKey: errorDetail
                        }];
                    }
                }

                transaction.transactionState = SKPaymentTransactionStateFailed;
                transaction.error = error;
                [_transactionStore update:transaction];
                [self notifyUpdatedTransaction:transaction];
                if(completionHandler) completionHandler(NO);
            } else {
                // Network error
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self postPaymentTransaction:transaction completionHandler:completionHandler];
                });
            }
        } else {
            NSDictionary *transactionDict = [responseObject objectForKey:@"data"];
            BOOL updated = [transaction updateWithResponseJSON:transactionDict];
            if(updated) {
                [_transactionStore update:transaction];
                [self notifyUpdatedTransaction:transaction];
            }
            if(completionHandler) completionHandler(YES);
        }
    }];
}

- (void)connectToPaymentAPI:(NSDictionary *)parameters path:(NSString*)path method:(NSString*)method completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    SKDebugLog(@"params %@ path %@ method %@", parameters, path, method);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    TomboAFURLSessionManager *_URLSessionManager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:configuration];
#ifdef DEBUG
    _URLSessionManager.securityPolicy.validatesDomainName = NO;
    _URLSessionManager.securityPolicy.allowInvalidCertificates = YES;
    SKDebugLog(@"ALLOW INVALID CERTIFICATES");
#endif

    NSString *urlString = [getTomboAPIServerUrlString() stringByAppendingString:path];
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[TomboAFJSONRequestSerializer serializer] requestWithMethod:method URLString:urlString parameters:parameters error:&serializerError];
    _URLSessionManager.responseSerializer = [TomboAFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:completionHandler];

    [dataTask resume];
}

static const char* transactionKey = "transactionKey";

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

    SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithPayment:payment];
    [_transactionStore insert:transaction];
    [self notifyUpdatedTransaction:transaction];

    objc_setAssociatedObject(alert, transactionKey, transaction, OBJC_ASSOCIATION_RETAIN);
    [alert show];
}

- (void)addTransactionForTest:(SKPaymentTransaction *)transaction
{
    [_transactionStore insert:transaction];
    [self notifyUpdatedTransaction:transaction];
    [self postPaymentTransaction:transaction completionHandler:nil];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    SKPaymentTransaction* transaction = objc_getAssociatedObject(alertView, transactionKey);
    if(buttonIndex == 0) {
        // Cancel
        transaction.transactionState = SKPaymentTransactionStateFailed;
        transaction.error = [NSError errorWithDomain:SKErrorDomain code:0 userInfo:nil];
        [self notifyUpdatedTransaction:transaction];
        [self notifyRemovedTransaction:transaction];
    } else {
        // Buy
        [self postPaymentTransaction:transaction completionHandler:^(BOOL success){
            if(success) {
                [self showTransactionCompleteAlert];
            }
        }];
    }
}

- (void)showTransactionCompleteAlert
{
    // "You're all set."
    // "Your puchase was successful."
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"完了しました。"
                                                    message:@"購入手続きが完了しました。"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

// Completes a pending transaction.
- (void)finishTransaction:(SKPaymentTransaction *)transaction
{
    SKDebugLog(@"transaction: %@", transaction);

    if(transaction.transactionState == SKPaymentTransactionStatePurchasing) {
        [NSException raise:NSInvalidArgumentException format:@"Cannot finish a purchasing transaction"];
    }

    [_transactionStore remove:transaction];
    [self notifyRemovedTransaction:transaction];
}

// Asks the payment queue to restore previously completed purchases.
- (void)restoreCompletedTransactions
{
    [self connectToPaymentAPI:@{@"user_jwt": getUserJwtString()}
                         path:@"/payments/restorable"
                       method:@"GET"
            completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                SKDebugLog(@"TomboAPI::postPayments error: %@ response: %@, responseObject:%@", error, response, responseObject);
                if (error) {
                    [self notifyRestoreFailed:error];
                } else {
                    NSArray *transactionsDict = [responseObject objectForKey:@"data"];
                    NSMutableArray *transactions = [[NSMutableArray alloc] init];
                    for(NSDictionary *dict in transactionsDict) {
                        SKPaymentTransaction *originalTransaction = [[SKPaymentTransaction alloc] initWithResponseJSON:dict];
                        SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithPayment:originalTransaction.payment];
                        transaction.originalTransaction = originalTransaction;
                        transaction.transactionIdentifier = [NSUUID UUID].UUIDString.lowercaseString;
                        transaction.transactionState = SKPaymentTransactionStateRestored;
                        transaction.transactionDate = [NSDate date];
                        [transactions addObject:transaction];
                    }
                    [self notifyUpdatedTransactions:transactions];
                    [self notifyRestoreCompletion];
                }
            }];
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

- (void)processRemainings
{
    SKPaymentTransaction* transaction = [_transactionStore incompleteTransaction];
    if(transaction) {
        SKDebugLog(@"%@", transaction);
        [self postPaymentTransaction:transaction completionHandler:^(BOOL success){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processRemainings];
            });
        }];
    }
}

- (void)turnRemainingTransactionsFailed
{
    SKDebugLog(@"remainings %@", [_transactionStore allTransactions]);
    for(SKPaymentTransaction *transaction in [_transactionStore allTransactions]) {
        if(transaction.transactionState == SKPaymentTransactionStatePurchasing && transaction.requested == NO) {
            transaction.transactionState = SKPaymentTransactionStateFailed;
            // No notifications will be made because no observers are registered on start up.
        }
    }
}

- (NSArray*)transactions
{
    return [_transactionStore allTransactions];
}

@end
