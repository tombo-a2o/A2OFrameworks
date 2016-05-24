#import <Foundation/Foundation.h>
#include <time.h>

@interface Hoge : NSObject
- (id)doIt:(id)dummy;
@end

@implementation Hoge
- (id)doIt:(id)dummy  {
  NSLog(@"hogehoge");
  return nil;
}
@end

int main(void)
{
  Hoge *hoge = [[Hoge alloc] init];

  [hoge doIt:nil];
  [hoge performSelector:@selector(doIt:) withObject:nil];
  [hoge performSelector:@selector(doIt:) withObject:nil afterDelay:2.0f];
  [[NSRunLoop currentRunLoop] run];

	return 0;
}
