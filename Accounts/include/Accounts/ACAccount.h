/*
 *  ACAccount.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>

@class ACAccountType, ACAccountCredential;

@interface ACAccount : NSObject
@property(copy, nonatomic) NSString *accountDescription;
@property(strong, nonatomic) ACAccountType *accountType;
@property(strong, nonatomic) ACAccountCredential *credential;
@property(readonly, weak, nonatomic) NSString *identifier;
@property(copy, nonatomic) NSString *username;
@end
