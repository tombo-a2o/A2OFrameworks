#import <StoreKit/SKStoreProductViewController.h>

@implementation SKStoreProductViewController

// Loads a new product screen to display.
- (void)loadProductWithParameters:(NSDictionary*)parameters completionBlock:(void (^)(BOOL result, NSError *error))block
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

@end

// Constants
NSString * const SKStoreProductParameterITunesItemIdentifier= @"id";
NSString * const SKStoreProductParameterAffiliateToken = @"at";
NSString * const SKStoreProductParameterCampaignToken = @"ct";
NSString * const SKStoreProductParameterProviderToken = @"pt";
