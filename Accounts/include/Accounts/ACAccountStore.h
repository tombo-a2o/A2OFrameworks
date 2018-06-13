/*
 *  ACAccountStore.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

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
