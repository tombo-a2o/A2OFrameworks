#import <UIKit/UIViewController.h>

@protocol UISearchControllerDelegate <NSObject>
@end

@protocol UISearchResultsUpdating <NSObject>
@end

@interface UISearchController : UIViewController
- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController;
@property(nonatomic, weak) id<UISearchControllerDelegate> delegate;

@property(nonatomic, strong, readonly) UISearchBar *searchBar;
@property(nonatomic, weak) id<UISearchResultsUpdating> searchResultsUpdater;
@property(nonatomic, strong, readonly) UIViewController *searchResultsController;
@property(nonatomic, assign, getter=isActive) BOOL active;

@property(nonatomic, assign) BOOL obscuresBackgroundDuringPresentation;
@property(nonatomic, assign) BOOL dimsBackgroundDuringPresentation;
@property(nonatomic, assign) BOOL hidesNavigationBarDuringPresentation;
@end
