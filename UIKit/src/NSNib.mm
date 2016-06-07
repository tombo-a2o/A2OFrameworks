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

#import <UIKit/NSNib.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIWindow.h>
#import "UIProxyObject.h"
#import "UIRuntimeOutletConnection.h"
#import "NSNibUnarchiver.h"

@implementation NSNib {
    NSBundle *_bundle;
    NSData *_data;
}

- (instancetype)initWithNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle
{
    _bundle = bundle ?: [NSBundle mainBundle];
    NSString *path = [[_bundle resourcePath] stringByAppendingPathComponent:nibName];
    _data = [[NSData alloc] initWithContentsOfFile:path];
    if (_data == nil) {
        _data = [[NSData alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:@"/runtime.nib"]];
    }
    return self;
}

- (instancetype)initWithNibData:(NSData *)nibData bundle:(NSBundle *)bundle
{
    _bundle = bundle ?: [NSBundle mainBundle];
    _data = [nibData retain];
    return self;
}

/**
 @Status Interoperable
*/
- (NSArray*)loadNib:(NSString*)filename withOwner:(id)ownerObject {
    return [self loadNib:filename withOwner:ownerObject proxies:nil];
}

/**
 @Status Interoperable
*/
- (NSArray*)loadNib:(NSString*)filename withOwner:(id)ownerObject proxies:(NSDictionary*)proxies {
    NSData* data = [NSData dataWithContentsOfFile:filename];
    if (data == nil) {
        data = [NSData dataWithContentsOfFile:[filename stringByAppendingPathComponent:@"/runtime.nib"]];
    }

    return [self loadNibWithData:data withOwner:ownerObject proxies:proxies];
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

    [prop _setBundle:(id)_bundle];
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

- (void)_setBundle:(NSBundle*)bundle {
    _bundle = bundle;
}

- (NSBundle*)_bundle {
    return _bundle;
}

- (void)_setData:(NSData*)data {
    _data = data;
}

- (NSData*)_data {
    return _data;
}

- (void)dealloc {
    [_data release];
    _bundle = nil;
    [super dealloc];
}

@end
