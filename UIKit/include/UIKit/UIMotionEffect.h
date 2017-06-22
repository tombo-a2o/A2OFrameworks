#import <Foundation/Foundation.h>

@interface UIMotionEffect : NSObject
- (instancetype)init;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (NSDictionary<NSString *,id> *)keyPathsAndRelativeValuesForViewerOffset:(UIOffset)viewerOffset;
@end

typedef NS_ENUM(NSInteger, UIInterpolatingMotionEffectType) {
    UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis,
    UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis
};

@interface UIInterpolatingMotionEffect : UIMotionEffect
- (instancetype)initWithKeyPath:(NSString *)keyPath type:(UIInterpolatingMotionEffectType)type;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

@property(readonly, nonatomic) NSString *keyPath;
@property(readonly, nonatomic) UIInterpolatingMotionEffectType type;
@property(strong, nonatomic) id minimumRelativeValue;
@property(strong, nonatomic) id maximumRelativeValue;
@end

@interface UIMotionEffectGroup : UIMotionEffect
@property(copy, nonatomic) NSArray<__kindof UIMotionEffect *> *motionEffects;
@end

@class UIView;

@interface UIView (MotionEffect)
@property(copy, nonatomic) NSArray<__kindof UIMotionEffect *> *motionEffects;
- (void)addMotionEffect:(UIMotionEffect *)effect;
- (void)removeMotionEffect:(UIMotionEffect *)effect;
@end
