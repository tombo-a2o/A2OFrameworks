#import <Foundation/Foundation.h>

typedef enum {
    ACAccountCredentialRenewResultRenewed,
    ACAccountCredentialRenewResultRejected,
    ACAccountCredentialRenewResultFailed 
} ACAccountCredentialRenewResult;

@class ACAccount, ACAccountType;

typedef void(^ACAccountStoreRequestAccessCompletionHandler)(BOOL granted, NSError *error);

@interface ACAccountStore : NSObject
@property(readonly, weak, nonatomic) NSArray *accounts;
- (ACAccount *)accountWithIdentifier:(NSString *)identifier;
- (NSArray *)accountsWithAccountType:(ACAccountType *)accountType;
- (ACAccountType *)accountTypeWithAccountTypeIdentifier:(NSString *)typeIdentifier;
- (void)requestAccessToAccountsWithType:(ACAccountType *)accountType
                  withCompletionHandler:(ACAccountStoreRequestAccessCompletionHandler)handler;
@end
