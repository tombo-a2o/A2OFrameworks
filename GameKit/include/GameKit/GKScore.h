#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
#import <Foundation/NSError.h>

@interface GKScore : NSObject
- (instancetype)initWithCategory:(NSString *)category;
- (void)reportScoreWithCompletionHandler:(void (^)(NSError *error))completionHandler;
@property(assign, nonatomic) int64_t value;
@end
