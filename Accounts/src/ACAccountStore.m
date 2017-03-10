#import <Accounts/Accounts.h>

@implementation ACAccountStore

- (ACAccount *)accountWithIdentifier:(NSString *)identifier
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return nil;
}

- (NSArray *)accountsWithAccountType:(ACAccountType *)accountType
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return nil;
}

- (ACAccountType *)accountTypeWithAccountTypeIdentifier:(NSString *)typeIdentifier
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return nil;
}

- (void)requestAccessToAccountsWithType:(ACAccountType *)accountType
                  withCompletionHandler:(ACAccountStoreRequestAccessCompletionHandler)handler
{
    NSLog(@"%s not implemented", __FUNCTION__);
}

@end
