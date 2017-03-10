//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#import <Foundation/Foundation.h>
#import <UIKit/UINib.h>
#import <UIKit/UIView.h>
#import <UIKit/UIWindow.h>
#import "UIProxyObject.h"
#import "UIRuntimeOutletConnection.h"
#import "NSNibUnarchiver.h"

NSString * const UINibProxiedObjectsKey = @"proxies";
NSString * const UINibExternalObjects = @"externals";

@implementation UINib {
    NSBundle *_bundle;
    NSData *_data;
}

+ (UINib *)nibWithNibName:(NSString *)name bundle:(NSBundle *)bundle
{
    return [[[UINib alloc] initWithNibNamed:name bundle:bundle] autorelease];
}

+ (UINib *)nibWithData:(NSData *)data bundle:(NSBundle *)bundle
{
    return [[[UINib alloc] initWithNibData:data bundle:bundle] autorelease];
}

- (instancetype)initWithNibNamed:(NSString *)name bundle:(NSBundle *)bundle
{
    bundle = bundle ?: [NSBundle mainBundle];
    
    NSString *path = [bundle pathForResource:name ofType:@"nib"];
    if(!path) {
        path = [bundle pathForResource:name ofType:@"nib"];
    }
    if(!path) {
        // FIXME Is this correct???
        path = [bundle pathForResource:@"runtime" ofType:@"nib" inDirectory:name];
    }
    
    return [self initWithNibData:[NSData dataWithContentsOfFile:path] bundle:bundle];
}

- (instancetype)initWithNibData:(NSData *)data bundle:(NSBundle *)bundle;
{
    self = [super init];
    _data = [data retain];
    _bundle = bundle ? [bundle retain] : [[NSBundle mainBundle] retain];
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    _data = [[coder decodeObjectForKey:@"archiveData"] retain];
    return self;
}

- (void)dealloc {
    [_data release];
    [_bundle release];
    [super dealloc];
}

- (NSArray *)instantiateWithOwner:(id)owner options:(NSDictionary *)options
{
    NSDictionary *proxies = options[UINibExternalObjects];
    return [self loadNibWithData:_data withOwner:owner proxies:proxies];
}

- (NSArray*)loadNibWithData:(NSData*)data withOwner:(id)ownerObject proxies:(NSDictionary*)proxies {
    char* bytes = (char*)[data bytes];
    if (!bytes) {
        return nil;
    }

    id prop;

    if (memcmp(bytes, "NIBArchive", 10) == 0) {
        prop = [NSNibUnarchiver alloc];
    } else {
        prop = [NSKeyedUnarchiver alloc];
    }

    [UIProxyObject addProxyObject:nil withName:@"IBFirstResponder" forCoder:prop];
    [UIProxyObject addProxyObject:ownerObject withName:@"IBFilesOwner" forCoder:prop];

    for (id key in proxies) {
        id curObj = [proxies objectForKey:key];

        [UIProxyObject addProxyObject:curObj withName:key forCoder:prop];
    }

    [prop initForReadingWithData:data];
//    return nil; ok
    // id allObjects = prop("decodeObjectForKey:", @"UINibObjectsKey");
    NSArray* connections = [prop decodeObjectForKey:@"UINibConnectionsKey"];
    NSArray* topLevelObjects = [prop decodeObjectForKey:@"UINibTopLevelObjectsKey"];
    NSArray* visibleObjects = [prop decodeObjectForKey:@"UINibVisibleWindowsKey"];
    NSArray* allObjects = [prop decodeObjectForKey:@"UINibObjectsKey"];

    for (UIRuntimeOutletConnection* curconnection in connections) {
        [curconnection makeConnection];
    }

    for (UIView* curobject in visibleObjects) {
        [curobject setHidden:FALSE];

        if ([curobject isKindOfClass:[UIWindow class]]) {
            [(UIWindow*)curobject makeKeyAndVisible];
        }
    };

    for (id curobject in allObjects) {
        if (curobject != ownerObject) {
            if ([curobject respondsToSelector:@selector(awakeFromNib)]) {
                [curobject performSelector:@selector(awakeFromNib)];
            }
        }
    }

    [prop autorelease];

    //  Grab TLO's, excluding owner
    NSMutableArray* ret = [NSMutableArray array];
    for (id curobject in topLevelObjects) {
        if (curobject != ownerObject) {
            [ret addObject:curobject];
        }
    }

    [UIProxyObject clearProxyObjects:prop];

    return ret;
}

@end
