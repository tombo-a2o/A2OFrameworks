#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>

@interface SKProductsResponse : NSObject

// Response Information
@property(readonly) NSArray<SKProduct *> *products;
@property(readonly) NSArray *invalidProductIdentifiers;

// FIXME: move to private
- (instancetype)initWithProducts:(NSArray *)products invalidProductIdentifiers:(NSArray*)invalidProductIdentifiers;

@end
