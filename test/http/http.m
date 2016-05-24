#import <Foundation/Foundation.h>
#include <assert.h>

@interface MyDelegate : NSObject
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end

@implementation MyDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
}

@end

int main(void)
{
  NSURLRequest *req =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://fchiba.net/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
  assert(req);

  MyDelegate *del = [[MyDelegate alloc] init];
  assert(del);

  NSURLConnection *conn = [NSURLConnection alloc];
  assert(conn != 0);
  conn = [conn initWithRequest:req delegate:del];
  assert(conn);

//  [[NSRunLoop currentRunLoop] run];

	return 0;
}
