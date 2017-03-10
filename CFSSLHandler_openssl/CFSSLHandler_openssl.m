#import "CFSSLHandler_openssl.h"
#import <Foundation/NSSocket.h>
#import <Foundation/NSData.h>
#import <Foundation/NSRaiseException.h>

#include <pthread.h>
#import <openssl/err.h>

@implementation CFSSLHandler(openssl)

+allocWithZone:(NSZone *)zone {
   return NSAllocateObject([CFSSLHandler_openssl class],0,zone);
}

@end

@implementation CFSSLHandler_openssl

static pthread_mutex_t  initLock=PTHREAD_MUTEX_INITIALIZER;
static pthread_mutex_t *lockTable;

static void locking_function(int mode,int idx,const char *file,int line){
   if(mode&CRYPTO_LOCK){
    pthread_mutex_lock(&(lockTable[idx]));
   }
   else {
    pthread_mutex_unlock(&(lockTable[idx]));
   }
}

#if 0
// We don't need this on Windows but it should be implemented generally
static threadid_func(CRYPTO_THREADID *id){
}
#endif

+(void)initialize {
   if(self==[CFSSLHandler_openssl class]){
    pthread_mutex_lock(&initLock);
    CRYPTO_malloc_init();
    SSL_load_error_strings();
    ERR_load_BIO_strings();
    SSL_library_init();

    int i,numberOfLocks=CRYPTO_num_locks();
    lockTable=OPENSSL_malloc(numberOfLocks*sizeof(pthread_mutex_t));
    for(i=0;i<numberOfLocks;i++)
     pthread_mutex_init(&(lockTable[i]),NULL);
    
    CRYPTO_set_locking_callback(locking_function);
    pthread_mutex_unlock(&initLock);
   }
}

-initWithProperties:(CFDictionaryRef )properties {
   _properties=CFRetain(properties);
   
   CFStringRef level=CFDictionaryGetValue(_properties,kCFStreamSSLLevel);
   
   if(level==NULL)
     _method=SSLv23_client_method();
   else if(CFStringCompare(level,kCFStreamSocketSecurityLevelSSLv3,0)==kCFCompareEqualTo)
     _method=SSLv3_client_method();
   else if(CFStringCompare(level,kCFStreamSocketSecurityLevelSSLv2,0)==kCFCompareEqualTo)
     _method=SSLv2_client_method();
   else if(CFStringCompare(level,kCFStreamSocketSecurityLevelTLSv1,0)==kCFCompareEqualTo)
     _method=TLSv1_client_method();
   else
     _method=SSLv23_client_method();
   
   CFNumberRef validatesCertChain=CFDictionaryGetValue(_properties,kCFStreamSSLValidatesCertificateChain);
   
   if(validatesCertChain!=NULL){
   }
   
   _context=SSL_CTX_new(_method);
   _connection=SSL_new(_context);
   _incoming=BIO_new(BIO_s_mem());
   _outgoing=BIO_new(BIO_s_mem());

   SSL_set_bio(_connection,_incoming,_outgoing);
   
   SSL_set_connect_state(_connection);
   
   /* The SSL_read doc.s say that when SSL_read returns Wants More you should use the same arguments
      the next call. It is a little ambiguous whether the same exact pointer should be used, so we don't
      chance it and just maintain a buffer for this purpose. */
      
   _stableBufferCapacity=8192;
   _stableBuffer=NSZoneMalloc(NULL,_stableBufferCapacity);
   _readBuffer=[[NSMutableData alloc] init];
   
   return self;
}

-(void)dealloc {
   CFRelease(_properties);
   SSL_free(_connection);
   NSZoneFree(NULL,_stableBuffer);
   [super dealloc];
}

-(void)close {
   SSL_shutdown(_connection);
}

-(BOOL)isHandshaking {
   return SSL_in_init(_connection)?YES:NO;
}

-(NSInteger)writePlaintext:(const uint8_t *)buffer maxLength:(NSUInteger)length {
   int result=SSL_write(_connection,buffer,length);
   
   if(result<0){
    int error=SSL_get_error(_connection,result);

    switch(error) {
     case SSL_ERROR_ZERO_RETURN:
      break;
      
     case SSL_ERROR_NONE: 
      break;
      
     case SSL_ERROR_WANT_READ:
      break;

     default :;
      char errorCString[256];

       while (error != 0){
        ERR_error_string_n(error, errorCString, sizeof(errorCString));

        NSCLog("SSL_write(%d) returned error %d - %s",length,error,errorCString);

         error = ERR_get_error();
       }
       break;
    }
   }
   
   return result;
}

-(NSInteger)writeBytesAvailable {
   return BIO_ctrl_pending(_outgoing);
}

-(BOOL)wantsMoreIncoming {
   return SSL_want_read(_connection);
}

-(NSInteger)readEncrypted:(uint8_t *)buffer maxLength:(NSUInteger)length {
   int check=BIO_read(_outgoing,buffer,length);

   if(check<=0){
    // This shouldn't happen unless we read when not ready
    NSCLog("BIO_read(_outgoing,buffer,%d) returned %d ",length,check);
   }
   
   return check;
}

-(NSInteger)writeEncrypted:(const uint8_t *)buffer maxLength:(NSUInteger)length {
   size_t check=BIO_write(_incoming,buffer,length);
   
   if(check<=0){
    // This shouldn't happen unless we are out of memory?
    NSCLog("BIO_write(_incoming,buffer,%d) returned %d ",length,check);
   }
   
   return check;
}

-(NSInteger)_readPostSSL:(uint8_t *)buffer maxLength:(NSUInteger)length {
   int check=SSL_read(_connection,buffer,length);
   
   if(check<=0){
    int error = SSL_get_error(_connection, check);

    switch(error){
     case SSL_ERROR_ZERO_RETURN:
      return 0;
      
     case SSL_ERROR_NONE: 
      return 0;
      
     case SSL_ERROR_WANT_READ:
      return 0;

     default :;
      char errorCString[256];

       while (error != 0){
        ERR_error_string_n(error, errorCString, sizeof(errorCString));

        NSCLog("SSL_read(%d) returned error %d - %s",length,error,errorCString);

        error = ERR_get_error();
       }
       break;
    }
   }
   
   return check;
}

-(NSInteger)readBytesAvailable {
/* SSL_pending() is useless here because it doesn't actually process anything, it will return 0 when there are bytes
   available post-processing.
 */
   if([_readBuffer length]>0)
    return [_readBuffer length];
   else {
    NSInteger result=[self _readPostSSL:_stableBuffer maxLength:_stableBufferCapacity];
   
    if(result<=0)
     return 0;

    [_readBuffer appendBytes:_stableBuffer length:result];
    return result;
   }
}

-(NSInteger)readPlaintext:(uint8_t *)buffer maxLength:(NSUInteger)length {
   if([_readBuffer length]>0){
    NSInteger qty=MIN([_readBuffer length],length);
    
    [_readBuffer getBytes:buffer length:qty];
    [_readBuffer replaceBytesInRange:NSMakeRange(0,qty) withBytes:NULL length:0];
    return qty;
   }
   
   return [self _readPostSSL:buffer maxLength:length];
}

-(NSInteger)transferOneBufferFromSSLToSocket:(NSSocket *)socket {
   NSInteger available=[self readEncrypted:_stableBuffer maxLength:_stableBufferCapacity];
   
   if(available<=0)
    return available;
   else {
    NSInteger check=[socket write:_stableBuffer maxLength:available];
    
    if(check!=available)
     NSCLog("failure socket write:%d=%d",available,check);
   
    return check;
   }
}

-(NSInteger)transferOneBufferFromSocketToSSL:(NSSocket *)socket {
   NSInteger result=[socket read:_stableBuffer maxLength:_stableBufferCapacity];
     
   if(result<=0)
    return result;
     
   NSInteger check;
     
   if((check=[self writeEncrypted:_stableBuffer maxLength:result])!=result){
    NSCLog("[sslHandler writeEncrypted:socketBuffer maxLength:%d] failed %d",result,check);
   }
      
   return result;
}

-(void)runHandshakeIfNeeded:(NSSocket *)socket {
   while([self isHandshaking]){     
    int check=SSL_do_handshake(_connection);
    
    if(check==1){
     break;
    }
    
    if(check==0){
     break;
    }
    
     if([self writeBytesAvailable]){
      if((check=[self transferOneBufferFromSSLToSocket:socket])<=0)
        break;
     }
     
     if([self wantsMoreIncoming]){
      if((check=[self transferOneBufferFromSocketToSSL:socket])<=0)
       break;
     }
   }
}

-(void)runWithSocket:(NSSocket *)socket {
    while([self writeBytesAvailable] || [self wantsMoreIncoming]){
     NSInteger check;
     
     if([self writeBytesAvailable]){
      if((check=[self transferOneBufferFromSSLToSocket:socket])<=0)
        break;
     }
    
     if([self wantsMoreIncoming]){
      if((check=[self transferOneBufferFromSocketToSSL:socket])<=0)
       break;
     }
    }
}


@end

