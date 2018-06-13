/*
 *  SecPolicy.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Security/SecPolicy.h>
#import <stdio.h>

SecPolicyRef SecPolicyCreateBasicX509(void)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return NULL;
}

SecPolicyRef SecPolicyCreateSSL(Boolean server, CFStringRef hostname)
{
    printf("%s is not implemented\n", __FUNCTION__);
    return NULL;
}
