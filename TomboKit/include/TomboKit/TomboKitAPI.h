#import <Foundation/Foundation.h>

@interface TomboKitAPI : NSObject

- (void)postPayments:(NSString *)productIdentifier
            quantity:(NSInteger)quantity
         requestData:(NSData *)requestData
 applicationUsername:(NSString *)applicationUsername
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failure;

- (void)getProducts:(NSArray *)productIdentifiers
           quantity:(NSInteger)quantity
        requestData:(NSData *)requestData
applicationUsername:(NSString *)applicationUsername
            success:(void (^)(NSDictionary *))success
            failure:(void (^)(NSError *))failure;

@end
