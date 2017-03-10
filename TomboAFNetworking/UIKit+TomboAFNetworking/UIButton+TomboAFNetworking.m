// UIButton+TomboAFNetworking.m
// Copyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIButton+TomboAFNetworking.h"

#import <objc/runtime.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import "TomboAFURLResponseSerialization.h"
#import "TomboAFHTTPRequestOperation.h"

#import "UIImageView+TomboAFNetworking.h"

@interface UIButton (_TomboAFNetworking)
@end

@implementation UIButton (_TomboAFNetworking)

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_sharedImageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_sharedImageRequestOperationQueue = [[NSOperationQueue alloc] init];
        _af_sharedImageRequestOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    });

    return _af_sharedImageRequestOperationQueue;
}

#pragma mark -

static char TomboAFImageRequestOperationNormal;
static char TomboAFImageRequestOperationHighlighted;
static char TomboAFImageRequestOperationSelected;
static char TomboAFImageRequestOperationDisabled;

static const char * af_imageRequestOperationKeyForState(UIControlState state) {
    switch (state) {
        case UIControlStateHighlighted:
            return &TomboAFImageRequestOperationHighlighted;
        case UIControlStateSelected:
            return &TomboAFImageRequestOperationSelected;
        case UIControlStateDisabled:
            return &TomboAFImageRequestOperationDisabled;
        case UIControlStateNormal:
        default:
            return &TomboAFImageRequestOperationNormal;
    }
}

- (TomboAFHTTPRequestOperation *)af_imageRequestOperationForState:(UIControlState)state {
    return (TomboAFHTTPRequestOperation *)objc_getAssociatedObject(self, af_imageRequestOperationKeyForState(state));
}

- (void)af_setImageRequestOperation:(TomboAFHTTPRequestOperation *)imageRequestOperation
                           forState:(UIControlState)state
{
    objc_setAssociatedObject(self, af_imageRequestOperationKeyForState(state), imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

static char TomboAFBackgroundImageRequestOperationNormal;
static char TomboAFBackgroundImageRequestOperationHighlighted;
static char TomboAFBackgroundImageRequestOperationSelected;
static char TomboAFBackgroundImageRequestOperationDisabled;

static const char * af_backgroundImageRequestOperationKeyForState(UIControlState state) {
    switch (state) {
        case UIControlStateHighlighted:
            return &TomboAFBackgroundImageRequestOperationHighlighted;
        case UIControlStateSelected:
            return &TomboAFBackgroundImageRequestOperationSelected;
        case UIControlStateDisabled:
            return &TomboAFBackgroundImageRequestOperationDisabled;
        case UIControlStateNormal:
        default:
            return &TomboAFBackgroundImageRequestOperationNormal;
    }
}

- (TomboAFHTTPRequestOperation *)af_backgroundImageRequestOperationForState:(UIControlState)state {
    return (TomboAFHTTPRequestOperation *)objc_getAssociatedObject(self, af_backgroundImageRequestOperationKeyForState(state));
}

- (void)af_setBackgroundImageRequestOperation:(TomboAFHTTPRequestOperation *)imageRequestOperation
                                     forState:(UIControlState)state
{
    objc_setAssociatedObject(self, af_backgroundImageRequestOperationKeyForState(state), imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation UIButton (TomboAFNetworking)

+ (id <TomboAFImageCache>)sharedImageCache {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(sharedImageCache)) ?: [UIImageView sharedImageCache];
#pragma clang diagnostic pop
}

+ (void)setSharedImageCache:(id <TomboAFImageCache>)imageCache {
    objc_setAssociatedObject(self, @selector(sharedImageCache), imageCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

- (id <TomboAFURLResponseSerialization>)imageResponseSerializer {
    static id <TomboAFURLResponseSerialization> _af_defaultImageResponseSerializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_defaultImageResponseSerializer = [TomboAFImageResponseSerializer serializer];
    });

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(imageResponseSerializer)) ?: _af_defaultImageResponseSerializer;
#pragma clang diagnostic pop
}

- (void)setImageResponseSerializer:(id <TomboAFURLResponseSerialization>)serializer {
    objc_setAssociatedObject(self, @selector(imageResponseSerializer), serializer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
{
    [self setImageForState:state withURL:url placeholderImage:nil];
}

- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setImageForState:state withURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageForState:(UIControlState)state
          withURLRequest:(NSURLRequest *)urlRequest
        placeholderImage:(UIImage *)placeholderImage
                 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                 failure:(void (^)(NSError *error))failure
{
    [self cancelImageRequestOperationForState:state];

    UIImage *cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            [self setImage:cachedImage forState:state];
        }

        [self af_setImageRequestOperation:nil forState:state];
    } else {
        if (placeholderImage) {
            [self setImage:placeholderImage forState:state];
        }

        __weak __typeof(self)weakSelf = self;
        TomboAFHTTPRequestOperation *imageRequestOperation = [[TomboAFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        imageRequestOperation.responseSerializer = self.imageResponseSerializer;
        [imageRequestOperation setCompletionBlockWithSuccess:^(TomboAFHTTPRequestOperation *operation, id responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([[urlRequest URL] isEqual:[operation.request URL]]) {
                if (success) {
                    success(operation.request, operation.response, responseObject);
                } else if (responseObject) {
                    [strongSelf setImage:responseObject forState:state];
                }
            }
            [[[strongSelf class] sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
        } failure:^(TomboAFHTTPRequestOperation *operation, NSError *error) {
            if ([[urlRequest URL] isEqual:[operation.request URL]]) {
                if (failure) {
                    failure(error);
                }
            }
        }];

        [self af_setImageRequestOperation:imageRequestOperation forState:state];
        [[[self class] af_sharedImageRequestOperationQueue] addOperation:imageRequestOperation];
    }
}

#pragma mark -

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSURL *)url
{
    [self setBackgroundImageForState:state withURL:url placeholderImage:nil];
}

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSURL *)url
                  placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setBackgroundImageForState:state withURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setBackgroundImageForState:(UIControlState)state
                    withURLRequest:(NSURLRequest *)urlRequest
                  placeholderImage:(UIImage *)placeholderImage
                           success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                           failure:(void (^)(NSError *error))failure
{
    [self cancelBackgroundImageRequestOperationForState:state];

    UIImage *cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            [self setBackgroundImage:cachedImage forState:state];
        }

        [self af_setBackgroundImageRequestOperation:nil forState:state];
    } else {
        if (placeholderImage) {
            [self setBackgroundImage:placeholderImage forState:state];
        }

        __weak __typeof(self)weakSelf = self;
        TomboAFHTTPRequestOperation *backgroundImageRequestOperation = [[TomboAFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        backgroundImageRequestOperation.responseSerializer = self.imageResponseSerializer;
        [backgroundImageRequestOperation setCompletionBlockWithSuccess:^(TomboAFHTTPRequestOperation *operation, id responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([[urlRequest URL] isEqual:[operation.request URL]]) {
                if (success) {
                    success(operation.request, operation.response, responseObject);
                } else if (responseObject) {
                    [strongSelf setBackgroundImage:responseObject forState:state];
                }
            }
            [[[strongSelf class] sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
        } failure:^(TomboAFHTTPRequestOperation *operation, NSError *error) {
            if ([[urlRequest URL] isEqual:[operation.request URL]]) {
                if (failure) {
                    failure(error);
                }
            }
        }];

        [self af_setBackgroundImageRequestOperation:backgroundImageRequestOperation forState:state];
        [[[self class] af_sharedImageRequestOperationQueue] addOperation:backgroundImageRequestOperation];
    }
}

#pragma mark -

- (void)cancelImageRequestOperationForState:(UIControlState)state {
    [[self af_imageRequestOperationForState:state] cancel];
    [self af_setImageRequestOperation:nil forState:state];
}

- (void)cancelBackgroundImageRequestOperationForState:(UIControlState)state {
    [[self af_backgroundImageRequestOperationForState:state] cancel];
    [self af_setBackgroundImageRequestOperation:nil forState:state];
}

@end

#endif
