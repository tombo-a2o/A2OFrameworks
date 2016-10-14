#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MFMailComposeResult) {
    MFMailComposeResultCancelled,
    MFMailComposeResultSaved,
    MFMailComposeResultSent,
    MFMailComposeResultFailed,
};

@protocol MFMailComposeViewControllerDelegate 
@end

@interface MFMailComposeViewController : UINavigationController
+ (BOOL)canSendMail;
@property(nonatomic, assign) id<MFMailComposeViewControllerDelegate> mailComposeDelegate;
@end
