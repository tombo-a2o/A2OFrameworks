#import <MessageUI/MessageUI.h>

@implementation MFMessageComposeViewController
+ (BOOL)canSendText
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return NO;
}

+ (BOOL)canSendAttachments;
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return NO;
}

+ (BOOL)canSendSubject;
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return NO;
}

+ (BOOL)isSupportedAttachmentUTI:(NSString *)uti;
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return NO;
}

@end
