#import <StoreKit/SKPayment.h>

@interface SKPayment () <NSCoding>
@property(nonatomic, readwrite) SKProduct *product;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;
@end
