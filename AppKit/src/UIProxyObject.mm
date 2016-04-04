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

#include "UIProxyObject.h"
#include <Foundation/Foundation.h>
#include "UIProxyObjectPair.h"

#if defined(NIBDEBUG)
#define EbrDebugLog(...) fprintf(stderr, __VA_ARGS__)
#else
#define EbrDebugLog(...)
#endif

id proxyObjects;

@implementation UIProxyObject : NSObject
+ (void)addProxyObject:(id)proxyObject withName:(NSObject*)objectName forCoder:(NSCoder*)coder {
    if (proxyObjects == 0) {
        proxyObjects = [[NSMutableArray alloc] initWithCapacity:64];
    }

    UIProxyObjectPair* newPair = [[UIProxyObjectPair alloc] init];
    newPair.proxiedObject = proxyObject;
    newPair.proxiedObjectCoder = coder;
    newPair.proxiedObjectName = objectName;

    [proxyObjects addObject:newPair];
    [newPair release];
}

+ (void)clearProxyObjects:(id)coder {
    int count = [proxyObjects count];

    for (int i = count - 1; i >= 0; i--) {
        UIProxyObjectPair* curObj = [proxyObjects objectAtIndex:i];

        if (curObj.proxiedObjectCoder == coder) {
            [proxyObjects removeObjectAtIndex:i];
        }
    }
}

- (instancetype)initWithCoder:(NSCoder*)coder {
    id proxiedObjectIdentifier = [coder decodeObjectForKey:@"UIProxiedObjectIdentifier"];

    int count = [proxyObjects count];

    for (int i = 0; i < count; i++) {
        UIProxyObjectPair* curObj = [proxyObjects objectAtIndex:i];

        if (curObj.proxiedObjectCoder == coder && [curObj.proxiedObjectName isEqual:proxiedObjectIdentifier]) {
            _obj = curObj.proxiedObject;
            EbrDebugLog("Proxied object found: %s", [proxiedObjectIdentifier UTF8String]);
            [self autorelease];
            return curObj.proxiedObject;
        }
    }

    EbrDebugLog("Proxy object not found: %s\n", [proxiedObjectIdentifier UTF8String]);
    return self;
}

- (id)_getObject {
    return _obj;
}

@end
