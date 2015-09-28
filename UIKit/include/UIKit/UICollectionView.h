#import <UIKit/UIScrollView.h>

@protocol UICollectionViewDataSource
@end

@protocol UICollectionViewDelegate <UIScrollViewDelegate>
@end

@interface UICollectionView : UIScrollView
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (id)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
@end
