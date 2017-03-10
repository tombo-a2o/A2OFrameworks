#import <UIKit/UIViewController.h>

@class SKStoreProductViewController;

@protocol SKStoreProductViewControllerDelegate

// Responding to a Dismiss Action
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController;

@end

@interface SKStoreProductViewController : UIViewController

// Settings a Delegate
@property(nonatomic, assign) id< SKStoreProductViewControllerDelegate > delegate;

// Loading a New Product Screen
- (void)loadProductWithParameters:(NSDictionary*)parameters completionBlock:(void (^)(BOOL result, NSError *error))block;

@end

// Constants
extern NSString * const SKStoreProductParameterITunesItemIdentifier;
extern NSString * const SKStoreProductParameterAffiliateToken;
extern NSString * const SKStoreProductParameterCampaignToken;
extern NSString * const SKStoreProductParameterProviderToken;
