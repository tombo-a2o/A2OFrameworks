#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "SKPaymentTransaction+Internal.h"
#import "SKPaymentTransactionStore.h"
#import "SKPayment+Internal.h"
#import <TomboAFNetworking/TomboAFNetworking.h>

#if defined(A2O_EMSCRIPTEN)
    #import <UIKit/UIAlertView+Blocks.h>
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

    SKDebugLog(@"%@ %d %@", self, status, requestId);

    if(self.transactionState != SKPaymentTransactionStatePurchasing) {
        // TODO log error
        return NO;
    }

    if(status == 2) {
        self.transactionState = SKPaymentTransactionStatePurchased;
        self.transactionIdentifier = [json objectForKey:@"id"];
        self.transactionDate = parseDate([attributes objectForKey:@"created_at"]);
        return YES;
    } else if(status == 1){
        self.transactionState = SKPaymentTransactionStateFailed;
        self.transactionIdentifier = [json objectForKey:@"id"];
        self.transactionDate = parseDate([attributes objectForKey:@"created_at"]);
        return YES;
    } else {
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

            NSString *requestId = transactionDict[@"attributes"][@"request_id"];

            if(![transaction.requestId.lowercaseString isEqualToString:requestId.lowercaseString]) {
                // already paid: non consumable
                [self showGetAgainNotice:transaction json:transactionDict completionHandler:completionHandler];
                return;
            }

            BOOL updated = [transaction updateWithResponseJSON:transactionDict];
            if(updated) {
                [_transactionStore update:transaction];
                [self notifyUpdatedTransaction:transaction];
            }
            if(completionHandler) completionHandler(YES);
        }
    }];
}

- (void)showGetAgainNotice:(SKPaymentTransaction*)transaction json:(NSDictionary*)json completionHandler:(void (^)(BOOL))completionHandler
{
    SKDebugLog(@"%@", transaction);

    void (^handler)(UIAlertView* view, NSInteger buttonIndex) = ^(UIAlertView* view, NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            // Cancel
            transaction.transactionState = SKPaymentTransactionStateFailed;
            transaction.error = [NSError errorWithDomain:SKErrorDomain code:0 userInfo:nil];
            [self notifyUpdatedTransaction:transaction];
            [_transactionStore remove:transaction];
            [self notifyRemovedTransaction:transaction];
            if(completionHandler) completionHandler(NO);
        } else {
            // OK
            transaction.originalTransaction = [[SKPaymentTransaction alloc] initWithResponseJSON:json];
            transaction.transactionState = SKPaymentTransactionStatePurchased;
            transaction.transactionIdentifier = [NSUUID UUID].UUIDString.lowercaseString; // TODO generate on server
            transaction.transactionDate = [NSDate date];
            [_transactionStore update:transaction];
            [self notifyUpdatedTransaction:transaction];
            if(completionHandler) completionHandler(YES);
        }
    };



    // Show
#if defined(A2O_EMSCRIPTEN)
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You've already purchaged this!"
                                                    message:@"Would you like to get it again for free?"
                                             clickedHandler:handler
                                            canceledHandler:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
#else
    handler(nil, 1);
#endif
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

+ (NSString*)confirmationMessage:(SKPayment*)payment
{
    SKProduct *product = payment.product;

    NSNumberFormatter *quantityFormatter = [[NSNumberFormatter alloc] init];
    quantityFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
    priceFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    priceFormatter.locale = product.priceLocale;
    NSNumber *quantity = [NSNumber numberWithInteger:payment.quantity];
    NSDecimalNumber *decimalQuantity = [NSDecimalNumber decimalNumberWithDecimal:[quantity decimalValue]];
    NSDecimalNumber *totalPrice = [product.price decimalNumberByMultiplyingBy:decimalQuantity];

    NSString *quantityString = [quantityFormatter stringFromNumber:quantity];
    NSString *title = product ? product.localizedTitle : @"(TODO: get title)";
    NSString *price = product ? [priceFormatter stringFromNumber:totalPrice] : @"(TODO: get price)";

    return [NSString stringWithFormat:@"Do you want to buy %@ %@ for %@", quantity, title, price];
}

// Adds a payment request to the queue.
- (void)addPayment:(SKPayment *)payment
{
    __block SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithPayment:payment];
    [_transactionStore insert:transaction];
    [self notifyUpdatedTransaction:transaction];

    void (^handler)(UIAlertView* view, NSInteger idx) = ^(UIAlertView* view, NSInteger buttonIndex){
        if(buttonIndex == 0) {
            // Cancel
            transaction.transactionState = SKPaymentTransactionStateFailed;
            transaction.error = [NSError errorWithDomain:SKErrorDomain code:0 userInfo:nil];
            [self notifyUpdatedTransaction:transaction];
            [_transactionStore remove:transaction];
            [self notifyRemovedTransaction:transaction];
        } else {
            // Buy
            [self postPaymentTransaction:transaction completionHandler:^(BOOL success){
                SKDebugLog(@"success %d", success);
                if(success) {
                    [self showTransactionCompleteAlert];
                }
            }];
        }
    };

#if defined(A2O_EMSCRIPTEN)
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Your In-App Purchase"
                                                    message:[self.class confirmationMessage:payment]
                                             clickedHandler:handler
                                            canceledHandler:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Buy", nil];
    [alert show];
#else
    handler(nil, 1);
#endif
}

- (void)addTransactionForTest:(SKPaymentTransaction *)transaction
{
    [_transactionStore insert:transaction];
    [self notifyUpdatedTransaction:transaction];
    [self postPaymentTransaction:transaction completionHandler:nil];
}

- (void)showTransactionCompleteAlert
{
    SKDebugLog(@"showing alert");
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
            [_transactionStore update:transaction];
        }
    }
}

- (NSArray*)transactions
{
    return [_transactionStore allTransactions];
}

@end
