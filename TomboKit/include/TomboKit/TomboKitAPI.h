#import <Foundation/Foundation.h>

extern NSString* TomboKitErrorDomain;

@interface TomboKitAPI : NSObject

- (void)postPayments:(NSString *)productIdentifier
            quantity:(NSInteger)quantity
         requestData:(NSData *)requestData
 applicationUsername:(NSString *)applicationUsername
           requestId:(NSString *)requestId
             success:(void (^)(NSArray *))success
             failure:(void (^)(NSError *))failure;

- (void)getProducts:(NSArray *)productIdentifiers
            success:(void (^)(NSArray *))success
            failure:(void (^)(NSError *))failure;

- (void)cancel;

@end
