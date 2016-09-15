#import <CommonCrypto/CommonHMAC.h>
//#import <Foundation/NSRaise.h>
#import <string.h>
#import <openssl/hmac.h>
#import <assert.h>

void CCHmacInit(CCHmacContext *context,CCHmacAlgorithm algorithm,const void *key,size_t keyLength) {
    context->sslContext=malloc(sizeof(HMAC_CTX));
    HMAC_CTX_init(context->sslContext);
    switch(algorithm) {
    case kCCHmacAlgSHA1:
        HMAC_Init(context->sslContext,key,keyLength,EVP_sha1());
        break;
    case kCCHmacAlgMD5:
        HMAC_Init(context->sslContext,key,keyLength,EVP_md5());
        break;
    case kCCHmacAlgSHA256:
        HMAC_Init(context->sslContext,key,keyLength,EVP_sha256());
        break;
    default:
        assert(0);
    }
}

void CCHmacUpdate(CCHmacContext *context,const void *bytes,size_t len) {
   HMAC_Update(context->sslContext,bytes,len);
}

void CCHmacFinal(CCHmacContext *context,void *macOut) {
   unsigned len=0;
   
   HMAC_Final(context->sslContext,macOut,&len);
   HMAC_CTX_cleanup(context->sslContext);
   free(context->sslContext);
}

void CCHmac(CCHmacAlgorithm algorithm,const void *key,size_t keyLength,const void *data,size_t dataLength,void *macOut) {
   CCHmacContext context;
   
   CCHmacInit(&context,algorithm,key,keyLength);
   CCHmacUpdate(&context,data,dataLength);
   CCHmacFinal(&context,macOut);
}
