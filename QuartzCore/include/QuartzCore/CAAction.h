#import <Foundation/NSObject.h>

@protocol CAAction
- (void)runActionForKey:(NSString *)key object:(id)anObject arguments:(NSDictionary *)dict;
@end
