/*
 *  SecSharedCredential.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Security/SecSharedCredential.h>
#import <Foundation/Foundation.h>



void SecAddSharedWebCredential(CFStringRef fqdn, CFStringRef account, CFStringRef password, void (^completionHandler)(CFErrorRef error))
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    completionHandler(NULL);
}

void SecRequestSharedWebCredential(CFStringRef fqdn, CFStringRef account, void (^completionHandler)(CFArrayRef credentials, CFErrorRef error))
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    completionHandler(NULL, NULL);
}

CFStringRef SecCreateSharedWebCredentialPassword(void)
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return NULL;
}
