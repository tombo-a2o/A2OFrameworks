#import <StoreKit/StoreKit.h>

@implementation SKProduct

- (instancetype)initWithProductIdentifier:(NSString *)productIdentifier localizedTitle:(NSString *)localizedTitle localizedDescription:(NSString *)localizedDescription price:(NSDecimalNumber *)price priceLocale:(NSLocale *)priceLocale {
    self = [super init];

    if(self) {
        _productIdentifier = productIdentifier;
        _localizedTitle = localizedTitle;
        _localizedDescription = localizedDescription;
        _price = price;
        _priceLocale = priceLocale;
    }

    return self;
}

// TODO: implement setter method for downloadable content information
//       @property(readonly) BOOL downloadable;
//       @property(nonatomic, readonly) NSArray<NSNumber *> *downloadContentLengths;
//       @property(nonatomic, readonly) NSString *downloadContentVersion;

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@ 0x%p> {%@, %@, %@, %@, %@}", NSStringFromClass([self class]), self, _productIdentifier, _localizedTitle, _localizedDescription, _price, _priceLocale];
}

@end
