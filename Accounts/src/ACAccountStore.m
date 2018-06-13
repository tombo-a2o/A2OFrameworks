/*
 *  ACAccountStore.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
