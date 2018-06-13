/*
 *  CommonHMAC.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CommonCrypto/CommonCryptoExport.h>
#import <CommonCrypto/CommonDigest.h>

#import <stdlib.h>

#define CC_SHA1_DIGEST_LENGTH 20

typedef enum {
    kCCHmacAlgSHA1,
    kCCHmacAlgMD5,
    kCCHmacAlgSHA256,
} CCHmacAlgorithm;

typedef struct {
    void *sslContext;
} CCHmacContext;

COMMONCRYPTO_EXPORT void CCHmacInit(CCHmacContext *context, CCHmacAlgorithm algorithm, const void *key, size_t keyLength);

COMMONCRYPTO_EXPORT void CCHmacUpdate(CCHmacContext *context, const void *data, size_t dataLength);
COMMONCRYPTO_EXPORT void CCHmacFinal(CCHmacContext *context, void *macOut);

COMMONCRYPTO_EXPORT void CCHmac(CCHmacAlgorithm algorithm, const void *key, size_t keyLength, const void *data, size_t dataLength, void *macOut);
