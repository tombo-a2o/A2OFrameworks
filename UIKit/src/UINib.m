#import <UIKit/UINib.h>

NSString * const UINibProxiedObjectsKey = @"proxies";
NSString * const UINibExternalObjects = @"externals";

@interface NSNib(Private)
- (NSArray*)loadNibWithData:(NSData*)data withOwner:(id)ownerObject proxies:(NSDictionary*)proxies;
- (NSData*)_data;
- (void)_setData:(NSData*)data;
@end

@implementation UINib
- (instancetype)initWithCoder:(NSCoder*)coder
{
    //NSData *data = [coder decodeObjectForKey:@"archiveData"];
    id data = [coder decodeObjectForKey:@"archiveData"];
    NSLog(@"data %@", data);
    self = [super initWithNibData:data bundle:nil];
    return self;
}

- (NSArray *)instantiateWithOwner:(id)owner options:(NSDictionary *)options
{
    NSDictionary *proxies = options[UINibExternalObjects];
    return [self loadNibWithData:self._data withOwner:owner proxies:proxies];
}
@end
