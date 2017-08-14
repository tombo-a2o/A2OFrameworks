#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "SKPayment+Internal.h"
#import <tombo_platform.h>
#import <TomboAFNetworking/TomboAFNetworking.h>

static SKPaymentQueue* _defaultQueue;

NSString * const SKErrorDomain = @"io.tombo.storekit.error";

@interface SKPayment (API)
+ (NSDictionary*)requestJSON:(NSArray<SKPayment*>*)payments;
@end

@interface SKPaymentTransaction (API)
- (instancetype)initWithResponseJSON:(NSDictionary*)json payment:(SKPayment*)payment;
+ (NSArray<SKPaymentTransaction*>*)transactionsWithJSON:(NSArray<NSDictionary*>*)json payments:(NSArray<SKPayment*>*)payments;
@end

@implementation SKPayment (API)
+ (NSDictionary*)requestJSON:(NSArray<SKPayment*>*)payments
{
    NSMutableArray *paymentsJson = [[NSMutableArray alloc] init];
    for(SKPayment* payment in payments) {
        [paymentsJson addObject:@{
            @"productIdentifier": payment.productIdentifier,
            @"quantity": [NSNumber numberWithInteger:payment.quantity],
            @"requestData": payment.requestData ?: [NSNull null],
            @"applicationUsername": payment.applicationUsername ?: [NSNull null],
            @"requestId": payment.requestId
        }];
    }

    return @{
        @"payments": paymentsJson,
        @"user_jwt": getUserJwtString()
    };
}
@end

@implementation SKPaymentTransaction (API)
- (instancetype)initWithResponseJSON:(NSDictionary*)json payment:(SKPayment*)payment
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *posixLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:posixLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];

    NSDictionary* attributes = [json objectForKey:@"attributes"];

    NSString *transactionIdentifier = [json objectForKey:@"id"];
    NSDate *transactionDate = [dateFormatter dateFromString:[attributes objectForKey:@"created_at"]];

    return [self initWithTransactionIdentifier:transactionIdentifier payment:payment transactionState:SKPaymentTransactionStatePurchased transactionDate:transactionDate error:nil];
}

+ (NSArray<SKPaymentTransaction*>*)transactionsWithJSON:(NSArray<NSDictionary*>*)json payments:(NSArray<SKPayment*>*)payments
{
    NSMutableArray *transactions = [[NSMutableArray alloc] init];
    [json enumerateObjectsUsingBlock:^(NSDictionary *transactionDict, NSUInteger index, BOOL *stop) {
        SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithResponseJSON:transactionDict payment:payments[index]];
        [transactions addObject:transaction];
    }];
    return transactions;
}

@end

@implementation SKPaymentQueue {
    NSMutableArray *_transactionObservers;
    TomboAFURLSessionManager *_URLSessionManager;
}

- (instancetype)init {
    _transactionObservers = [[NSMutableArray alloc] init];
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
    // TODO: show detailed log
    SKDebugLog(@"%s payment: %@", __FUNCTION__, payment);

    if(!payment.requestId) {
        payment.requestId = [NSUUID UUID].UUIDString;
    }

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _URLSessionManager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:configuration];
#ifdef DEBUG
    _URLSessionManager.securityPolicy.validatesDomainName = NO;
    _URLSessionManager.securityPolicy.allowInvalidCertificates = YES;
    SKDebugLog(@"ALLOW INVALID CERTIFICATES");
#endif

    NSString *urlString = [getTomboAPIServerUrlString() stringByAppendingString:@"/payments"];
    NSDictionary *parameters = [SKPayment requestJSON:@[payment]];
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[TomboAFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:&serializerError];
    _URLSessionManager.responseSerializer = [TomboAFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        _URLSessionManager = nil;

        SKDebugLog(@"TomboAPI::postPayments error: %@ response: %@", error, response);
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            if(responseObject) {
                NSArray *errors = [responseObject objectForKey:@"errors"];
                if(errors) {
                    NSString *errorMessage = errors[0];
                    error = [NSError errorWithDomain:SKErrorDomain code:0 userInfo:@{
                        NSLocalizedDescriptionKey: errorMessage
                    }];
                }

                NSMutableArray *transactions = [[NSMutableArray alloc] init];
                SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithTransactionIdentifier:nil payment:payment transactionState:SKPaymentTransactionStateFailed transactionDate:nil error:error];
                [transactions addObject:transaction];
                for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
                    [observer paymentQueue:self updatedTransactions:transactions];
                }

            } else {
                // Network error
            }
        } else {
            NSArray *data = [responseObject objectForKey:@"data"];
            NSArray *transactions = [SKPaymentTransaction transactionsWithJSON:data payments:@[payment]];
            SKDebugLog(@"transactions: %@", transactions);
            for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
                [observer paymentQueue:self updatedTransactions:transactions];
            }
        }
    }];

    [dataTask resume];
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
        // TODO: serialize and save payment
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
