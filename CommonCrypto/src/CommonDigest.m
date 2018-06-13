/*
 *  CommonDigest.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CommonCrypto/CommonDigest.h>
#import <openssl/md5.h>
#import <openssl/sha.h>
#include <assert.h>

int CC_MD5_Init(CC_MD5_CTX *c)
{
    assert(sizeof(MD5_CTX)==sizeof(CC_MD5_CTX));
    return MD5_Init((MD5_CTX*)c);
}

int CC_MD5_Update(CC_MD5_CTX *c, const void *data, CC_LONG len)
{
    return MD5_Update((MD5_CTX*)c, data, len);
}

int CC_MD5_Final(unsigned char *md, CC_MD5_CTX *c)
{
    return MD5_Final(md, (MD5_CTX*)c);
}

unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)
{
    assert(sizeof(SHA_CTX)==sizeof(CC_MD5_CTX));
    return MD5(data, len, md);
}

int CC_SHA1_Init(CC_SHA1_CTX *c)
{
    assert(sizeof(SHA_CTX)==sizeof(CC_SHA1_CTX));
    return SHA1_Init((SHA_CTX*)c);
}

int CC_SHA1_Update(CC_SHA1_CTX *c, const void *data, CC_LONG len)
{
    return SHA1_Update((SHA_CTX*)c, data, len);
}

int CC_SHA1_Final(unsigned char *md, CC_SHA1_CTX *c)
{
    return SHA1_Final(md, (SHA_CTX*)c);
}

unsigned char *CC_SHA1(const void *data, CC_LONG len, unsigned char *md)
{
    assert(sizeof(SHA_CTX)==sizeof(CC_SHA1_CTX));
    return SHA1(data, len, md);
}

int CC_SHA256_Init(CC_SHA256_CTX *c)
{
    assert(sizeof(SHA256_CTX)==sizeof(CC_SHA256_CTX));
    return SHA256_Init((SHA256_CTX*)c);
}

int CC_SHA256_Update(CC_SHA256_CTX *c, const void *data, CC_LONG len)
{
    return SHA256_Update((SHA256_CTX*)c, data, len);
}

int CC_SHA256_Final(unsigned char *md, CC_SHA256_CTX *c)
{
    return SHA256_Final(md, (SHA256_CTX*)c);
}

unsigned char *CC_SHA256(const void *data, CC_LONG len, unsigned char *md)
{
    assert(sizeof(SHA256_CTX)==sizeof(CC_SHA256_CTX));
    return SHA256(data, len, md);
}
