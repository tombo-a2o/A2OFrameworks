#import <Foundation/NSAttributedString.h>
#import <CoreGraphics/CoreGraphics.h>

@class UIImage;

@interface NSTextAttachment : NSObject
@property(nonatomic) CGRect bounds;
@property(strong, nonatomic) UIImage *image;
@end

@interface NSAttributedString (Attachement)
+ (NSAttributedString *)attributedStringWithAttachment:(NSTextAttachment *)attachment;
@end
