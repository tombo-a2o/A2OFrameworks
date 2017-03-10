#import <Social/SLComposeViewController.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CFBundlePriv.h>

NSString *const SLServiceTypeFacebook = @"facebook";
NSString *const SLServiceTypeTwitter = @"twitter";
NSString *const SLServiceTypeSinaWeibo = @"sinaWeibo";
NSString *const SLServiceTypeTencentWeibo = @"tencentWeibo";

@implementation SLComposeViewController {
    NSString *_initialText;
    NSMutableArray *_urls;
    NSBundle *_frameworkBundle;
}

+ (SLComposeViewController *)composeViewControllerForServiceType:(NSString *)serviceType
{
    return [[SLComposeViewController alloc] initForServiceType:serviceType];
}

+ (BOOL)isAvailableForServiceType:(NSString *)serviceType
{
    return [serviceType isEqualToString:SLServiceTypeFacebook] || [serviceType isEqualToString:SLServiceTypeTwitter];
}

- (instancetype)initForServiceType:(NSString *)serviceType
{
    self = [super init];
    if(self) {
        // self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _serviceType = serviceType;
        _urls = [[NSMutableArray alloc] init];
        _frameworkBundle = [NSBundle bundleWithPath:@"/frameworks/Social.framework/Resources"];
        [_frameworkBundle load];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([_serviceType isEqualToString:SLServiceTypeTwitter]) {
        [self _prepareTweetView];
    } else if([_serviceType isEqualToString:SLServiceTypeFacebook]) {
        [self _prepareFacebookView];
    } else {
        assert(0);
    }

}

#define TWITTER 1
#define FACEBOOK 2

#define SLLocalizedString(key) [self localizedString:key]

- (NSString*)localizedString:(NSString*)key
{
    NSArray* localizations = [_frameworkBundle localizations];
    NSArray* prefArray = [(NSArray*)CFBundleCopyLocalizationsForPreferences((CFArrayRef)localizations, NULL) autorelease];
    for(NSString *pref in prefArray) {
        return (NSString*)CFBundleCopyLocalizedStringForLocalization([_frameworkBundle _cfBundle], (CFStringRef)key, NULL, NULL, (CFStringRef)pref);
    }
    return key;
}

- (void)_prepareTweetView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                    message:[self localizedString:@"About to open a new tab"]
                                                   delegate:self
                                          cancelButtonTitle:[self localizedString:@"Cancel"]
                                          otherButtonTitles:[self localizedString:@"OK"], nil];
    alert.tag = TWITTER;
    [alert show];
}

- (void)_prepareFacebookView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                    message:[self localizedString:@"About to open a new tab"]
                                                   delegate:self
                                          cancelButtonTitle:[self localizedString:@"Cancel"]
                                          otherButtonTitles:[self localizedString:@"OK"], nil];
    alert.tag = FACEBOOK;
    [alert show];
}

-(void)applicationWillEnterForeground
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:^{
        self.completionHandler(SLComposeViewControllerResultDone);
    }];
}

static inline NSString* escapeHTML(NSString *input)
{
    return (NSString *)CFURLCreateStringByAddingPercentEscapes(
        NULL,
        (CFStringRef)input,
        NULL,
        CFSTR("!*'();:@&=+$,/?%#[]"),
        kCFStringEncodingUTF8);
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.completionHandler(SLComposeViewControllerResultCancelled);
        }];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];

        NSMutableString *baseUrl;
        if(alertView.tag == TWITTER) {
            baseUrl = [NSMutableString stringWithString:@"https://twitter.com/intent/tweet?text="];
            [baseUrl appendString:escapeHTML(_initialText)];
            if([_urls count]) {
                NSURL *url = [_urls lastObject];
                [baseUrl appendString:@"&url="];
                [baseUrl appendString:escapeHTML([url absoluteString])];
            }
        } else if(alertView.tag == FACEBOOK){
            baseUrl = [NSMutableString stringWithString:@"http://www.facebook.com/sharer/sharer.php?u="];
            if([_urls count]) {
                NSURL *url = [_urls lastObject];
                [baseUrl appendString:escapeHTML([url absoluteString])];
            } else {
                assert(0);
            }
        } else {
            assert(0);
        }
        BOOL ret = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:baseUrl]];
        if(!ret) {
            // TODO alert
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self dismissViewControllerAnimated:YES completion:^{
                self.completionHandler(SLComposeViewControllerResultCancelled);
            }];
        }
    }
}

- (BOOL)setInitialText:(NSString *)text
{
    _initialText = [text copy];
    return YES;
}

- (BOOL)addImage:(UIImage *)image
{
    return NO;
}

- (BOOL)removeAllImages
{
    return NO;
}

- (BOOL)addURL:(NSURL *)url
{
    [_urls addObject:url];
    return YES;
}

- (BOOL)removeAllURLs
{
    [_urls removeAllObjects];
    return YES;
}
@end
