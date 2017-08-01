#import <UIKit/UIFontDescriptor.h>

@implementation UIFontDescriptor

+ (UIFontDescriptor *)preferredFontDescriptorWithTextStyle:(UIFontTextStyle)style
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (UIFontDescriptor *)fontDescriptorWithSymbolicTraits:(UIFontDescriptorSymbolicTraits)symbolicTraits
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

@end
