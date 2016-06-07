#import <UIKit/NSNib.h>

extern NSString * const UINibProxiedObjectsKey;
extern NSString * const UINibExternalObjects;

@interface UINib : NSNib
- (instancetype)initWithCoder:(NSCoder*)coder;
- (NSArray *)instantiateWithOwner:(id)ownerOrNil options:(NSDictionary *)options;
@end
