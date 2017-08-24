#import <StoreKit/SKPayment.h>

@interface SKPayment () <NSCoding>
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;
@end
