#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "SKPaymentTransaction+Internal.h"
#import <tombo_platform.h>
#import <TomboAFNetworking/TomboAFNetworking.h>

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

    SKDebugLog(@"%s %d %@ %@", __FUNCTION__, status, requestId, self);

    if(![self.requestId isEqualToString:requestId]) {
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

- (void)connectToPaymentAPI:(SKPaymentTransaction *)transaction
{
    // TODO: show detailed log
    SKDebugLog(@"%s transaction: %@", __FUNCTION__, transaction);

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _URLSessionManager = [[TomboAFURLSessionManager alloc] initWithSessionConfiguration:configuration];
#ifdef DEBUG
    _URLSessionManager.securityPolicy.validatesDomainName = NO;
    _URLSessionManager.securityPolicy.allowInvalidCertificates = YES;
    SKDebugLog(@"ALLOW INVALID CERTIFICATES");
#endif

    NSString *urlString = [getTomboAPIServerUrlString() stringByAppendingString:@"/payments"];
    NSDictionary *parameters = [transaction requestJSON];
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[TomboAFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:&serializerError];
    _URLSessionManager.responseSerializer = [TomboAFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        _URLSessionManager = nil;

        SKDebugLog(@"TomboAPI::postPayments error: %@ response: %@, responseObject:%@", error, response, responseObject);
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            if(responseObject) {
                NSArray *errors = [responseObject objectForKey:@"errors"];
                if(errors) {
                    NSString *errorMessage = errors[0];
                    error = [NSError errorWithDomain:SKServerErrorDomain code:0 userInfo:@{
                        NSLocalizedDescriptionKey: errorMessage
                    }];
                }

                transaction.error = error;
                NSArray *updatedTransactions = [NSArray arrayWithObject:transaction];
                for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
                    [observer paymentQueue:self updatedTransactions:updatedTransactions];
                }
            } else {
                // Network error
            }
        } else {
            NSMutableArray *updatedTransactions = [[NSMutableArray alloc] init];

            NSArray *data = [responseObject objectForKey:@"data"];
            for(NSDictionary *transactionDict in data) {
                BOOL updated = [transaction updateWithResponseJSON:transactionDict];
                if(updated) {
                    [updatedTransactions addObject:transaction];
                }
            }

            SKDebugLog(@"updatedTransactions: %@", updatedTransactions);
            for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
                [observer paymentQueue:self updatedTransactions:updatedTransactions];
            }
        }
    }];

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

    objc_setAssociatedObject(alert, transactionKey, transaction, OBJC_ASSOCIATION_RETAIN);
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    SKPaymentTransaction* transaction = objc_getAssociatedObject(alertView, transactionKey);
    if(buttonIndex == 0) {
        transaction.transactionState = SKPaymentTransactionStateFailed;
        transaction.error = [NSError errorWithDomain:SKErrorDomain code:0 userInfo:nil];

        NSArray *updatedTransactions = [NSArray arrayWithObject:transaction];
        for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
            [observer paymentQueue:self updatedTransactions:updatedTransactions];
        }
    } else {
        // TODO: serialize and save payment
        [self connectToPaymentAPI:transaction];
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
