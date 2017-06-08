#import <UIKit/UIViewController.h>

@class GKGameCenterViewController;

@protocol GKGameCenterControllerDelegate
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController;
@end

@interface GKGameCenterViewController : UIViewController
@end
