#import <Foundation/NSObject.h>

@protocol NSValidatedUserInterfaceItem
- (int)tag;
- (SEL)action;
@end

@protocol NSUserInterfaceValidations
- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem;
@end
