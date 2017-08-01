#import <UIKit/UIViewController.h>

@class UITextField;

typedef NS_ENUM(NSInteger, UIAlertControllerStyle) {
    UIAlertControllerStyleActionSheet = 0,
    UIAlertControllerStyleAlert,
};

@class UIAlertAction;

@interface UIAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle;
- (void)addAction:(UIAlertAction *)action;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

@property(nonatomic, readonly) NSArray<UITextField *> *textFields;
@end

typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
    UIAlertActionStyleDefault = 0,
    UIAlertActionStyleCancel,
    UIAlertActionStyleDestructive
};

@interface UIAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) UIAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@end
