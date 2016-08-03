#import <UIKit/UIPasteboard.h>

@implementation UIPasteboard

+ (UIPasteboard *)generalPasteboard
{
    return nil;
}
+ (UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create
{
    return nil;
}

- (void)addItems:(NSArray *)items
{
    
}

- (void)setData:(NSData *)data forPasteboardType:(NSString *)pasteboardType
{
    
}

- (void)setValue:(id)value forPasteboardType:(NSString *)pasteboardType
{
    
}


@end
