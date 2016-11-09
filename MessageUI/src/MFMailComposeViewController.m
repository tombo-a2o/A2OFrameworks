#import <MessageUI/MFMailComposeViewController.h>

@implementation MFMailComposeViewController
+ (BOOL)canSendMail
{
    NSLog(@"%s is not implemented", __FUNCTION__);
    return NO;
}

- (void)setSubject:(NSString *)subject
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)setToRecipients:(NSArray<NSString *> *)toRecipients
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)setCcRecipients:(NSArray<NSString *> *)ccRecipients
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)setBccRecipients:(NSArray<NSString *> *)bccRecipients
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)addAttachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

@end
