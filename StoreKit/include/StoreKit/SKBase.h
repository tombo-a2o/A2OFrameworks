#import <Foundation/NSString.h>

extern NSString * const SKErrorDomain;

enum {
    SKErrorUnknown,
    SKErrorClientInvalid,
    SKErrorPaymentCancelled,
    SKErrorPaymentInvalid,
    SKErrorPaymentNotAllowed,
    SKErrorStoreProductNotAvailable
};
