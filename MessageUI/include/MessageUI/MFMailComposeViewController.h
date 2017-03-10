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
- (void)setSubject:(NSString *)subject;
- (void)setToRecipients:(NSArray<NSString *> *)toRecipients;
- (void)setCcRecipients:(NSArray<NSString *> *)ccRecipients;
- (void)setBccRecipients:(NSArray<NSString *> *)bccRecipients;
- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML;
- (void)addAttachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename;
@property(nonatomic, assign) id<MFMailComposeViewControllerDelegate> mailComposeDelegate;
@end
