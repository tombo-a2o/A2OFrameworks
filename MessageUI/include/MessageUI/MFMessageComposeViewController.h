#import <UIKit/UIKit.h>

enum MessageComposeResult {
    MessageComposeResultCancelled,
    MessageComposeResultSent,
    MessageComposeResultFailed
};
typedef enum MessageComposeResult MessageComposeResult;

@protocol MFMessageComposeViewControllerDelegate
@end

@interface MFMessageComposeViewController : UINavigationController
+ (BOOL)canSendText;
+ (BOOL)canSendAttachments;
+ (BOOL)canSendSubject;
+ (BOOL)isSupportedAttachmentUTI:(NSString *)uti;
@property(nonatomic, assign) id< MFMessageComposeViewControllerDelegate > messageComposeDelegate;

@property(nonatomic, copy) NSArray *recipients;
@property(nonatomic, copy) NSString *subject;
@property(nonatomic, copy) NSString *body;
@property(nonatomic, copy, readonly) NSArray *attachments;
@end
