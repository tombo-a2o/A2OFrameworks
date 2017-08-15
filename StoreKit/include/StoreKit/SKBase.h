#import <Foundation/NSString.h>

extern NSString * const SKErrorDomain;
extern NSString * const SKServerErrorDomain;

enum {
    SKErrorUnknown,
    SKErrorClientInvalid,
    SKErrorPaymentCancelled,
    SKErrorPaymentInvalid,
    SKErrorPaymentNotAllowed,
    SKErrorStoreProductNotAvailable
};
