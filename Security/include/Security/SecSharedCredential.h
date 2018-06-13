/*
 *  SecSharedCredential.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#ifndef _SECURITY_SECSHAREDCRED_H_
#define _SECURITY_SECSHAREDCRED_H_

#include <Security/SecBase.h>
#include <CoreFoundation/CFString.h>
#include <CoreFoundation/CFError.h>

extern const CFStringRef kSecSharedPassword;

void SecAddSharedWebCredential(CFStringRef fqdn, CFStringRef account, CFStringRef password, void (^completionHandler)(CFErrorRef error));
void SecRequestSharedWebCredential(CFStringRef fqdn, CFStringRef account, void (^completionHandler)(CFArrayRef credentials, CFErrorRef error));
CFStringRef SecCreateSharedWebCredentialPassword(void);

#endif
