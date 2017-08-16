#import <StoreKit/SKProduct.h>

@interface SKPayment : NSObject <NSCopying, NSMutableCopying> {
    NSString *_productIdentifier;
    NSInteger _quantity;
    NSData *_requestData;
    NSString *_applicationUsername;
}

// Creating Instances
+ (instancetype)paymentWithProduct:(SKProduct *)product;
+ (id)paymentWithProductIdentifier:(NSString *)identifier;

// Getting Attributes
@property(nonatomic, copy, readonly) NSString *productIdentifier;
@property(nonatomic, readonly) NSInteger quantity;
@property(nonatomic, copy, readonly) NSData *requestData;
@property(nonatomic, copy, readonly) NSString *applicationUsername;

@end

@interface SKMutablePayment : SKPayment

// Getting and Settings Attributes
@property(nonatomic, copy, readwrite) NSString *productIdentifier;
@property(nonatomic, readwrite) NSInteger quantity;
@property(nonatomic, copy, readwrite) NSData *requestData;
@property(nonatomic, copy, readwrite) NSString *applicationUsername;
@end
