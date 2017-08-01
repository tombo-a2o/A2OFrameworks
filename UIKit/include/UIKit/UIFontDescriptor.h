#import <Foundation/NSObject.h>

extern NSString *const UIFontTextStyleHeadline;
extern NSString *const UIFontTextStyleSubheadline;
extern NSString *const UIFontTextStyleBody;
extern NSString *const UIFontTextStyleFootnote;
extern NSString *const UIFontTextStyleCaption1;
extern NSString *const UIFontTextStyleCaption2;

typedef NSString *UIFontTextStyle;
typedef NS_ENUM(NSUInteger, UIFontDescriptorSymbolicTraits) {
    UIFontDescriptorTraitItalic = 1u << 0,
    UIFontDescriptorTraitBold = 1u << 1,
    UIFontDescriptorTraitExpanded = 1u << 5,
    UIFontDescriptorTraitCondensed = 1u << 6,
    UIFontDescriptorTraitMonoSpace = 1u << 10,
    UIFontDescriptorTraitVertical = 1u << 11,
    UIFontDescriptorTraitUIOptimized = 1u << 12,
    UIFontDescriptorTraitTightLeading = 1u << 15,
    UIFontDescriptorTraitLooseLeading = 1u << 16,
    UIFontDescriptorClassMask = 0xF0000000,
    UIFontDescriptorClassUnknown = 0u << 28,
    UIFontDescriptorClassOldStyleSerifs = 1u << 28,
    UIFontDescriptorClassTransitionalSerifs = 2u << 28,
    UIFontDescriptorClassModernSerifs = 3u << 28,
    UIFontDescriptorClassClarendonSerifs = 4u << 1,
    UIFontDescriptorClassSlabSerifs = 5u << 1,
    UIFontDescriptorClassFreeformSerifs = 7u << 1,
    UIFontDescriptorClassSansSerif = 8u << 1,
    UIFontDescriptorClassOrnamentals = 9u << 1,
    UIFontDescriptorClassScripts = 10u << 1,
    UIFontDescriptorClassSymbolic = 12u << 1,
};

@interface UIFontDescriptor : NSObject
- (UIFontDescriptor *)fontDescriptorWithSymbolicTraits:(UIFontDescriptorSymbolicTraits)symbolicTraits;
+ (UIFontDescriptor *)preferredFontDescriptorWithTextStyle:(UIFontTextStyle)style;
@end
