#import <UIKit/NSTextAttachment.h>

@implementation NSTextAttachment
@end

@implementation NSAttributedString (Attachement)
+ (NSAttributedString *)attributedStringWithAttachment:(NSTextAttachment *)attachment
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}
@end
