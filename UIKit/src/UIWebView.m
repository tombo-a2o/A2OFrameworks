#import <UIKit/UIWebView.h>
#import <emscripten/webview.h>

@implementation UIWebView {
    int _iFrameId;
}

- (void)_setFrame
{
    if(self.superview) {
        CGRect frame = [self.superview convertRect:self.frame toView:self.window];
        iframe_setFrame(_iFrameId, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    _iFrameId = iframe_create();
    return [super initWithFrame:frame];
}

- (id)initWithCoder:(NSCoder*)coder
{
    _iFrameId = iframe_create();
    return [super initWithCoder:coder];
}

- (void)dealloc
{
    if(_iFrameId) {
        iframe_destroy(_iFrameId);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if(newSuperview) {
        iframe_setVisible(_iFrameId, 1);
        [self _setFrame];
    } else {
        iframe_setVisible(_iFrameId, 0);
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if(newWindow) {
        iframe_setVisible(_iFrameId, 1);
        [self _setFrame];
    } else {
        iframe_setVisible(_iFrameId, 0);
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self _setFrame];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self _setFrame];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self _setFrame];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    iframe_loadString(_iFrameId, [string UTF8String]);
}

- (void)loadRequest:(NSURLRequest *)request;
{
    NSURL *url = request.URL;
    assert([request.HTTPMethod isEqualToString:@"GET"]);
    if([url.scheme isEqualToString:@"file"]) {
        NSError *error;
        NSString *contents = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        [self loadHTMLString:contents baseURL:nil];
    } else if([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        iframe_loadUrl(_iFrameId, [url.absoluteString UTF8String]);
    } else {
        assert(0);
    }
}

- (void)stopLoading
{
    iframe_stopLoading(_iFrameId);
}

- (void)reload
{
    iframe_reload(_iFrameId);
}

- (void)goBack
{
    iframe_goBack(_iFrameId);
}

- (void)goForward
{
    iframe_goForward(_iFrameId);
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script
{
    char *result = iframe_evalJs(_iFrameId, [script UTF8String]);
    NSString *ret = [NSString stringWithUTF8String:result];
    free(result);
    return ret;
}

@end
