#import <Foundation/NSObject.h>

typedef enum {
    ACAccountCredentialRenewResultRenewed,
    ACAccountCredentialRenewResultRejected,
    ACAccountCredentialRenewResultFailed 
} ACAccountCredentialRenewResult;

@interface ACAccountStore : NSObject
@end
