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

#include "UIClassSwapper.h"
#include <objc/runtime.h>

#if defined(DEBUG)
#define EbrDebugLog(...) fprintf(stderr, __VA_ARGS__)
#else
#define EbrDebugLog(...)
#endif

@implementation UIClassSwapper : NSObject
- (id)initWithCoder:(id)coder {
    self = [self instantiateWithCoder:coder];
    if([self respondsToSelector:@selector(initWithCoder:)]) {
        self = [self initWithCoder:coder];
    } else {
        self = [self init];
    }
    return self;
}

- (id)instantiateWithCoder:(id)coder {
    className = [coder decodeObjectForKey:@"UIClassName"];
    originalClassName = [coder decodeObjectForKey:@"UIOriginalClassName"];
    const char* identifier = [className UTF8String];
    const char* identifier2 = [originalClassName UTF8String];

    //EbrDebugLog("Swap class: %s->%s\n", identifier2, identifier);
    id classNameId = objc_getClass(identifier);

    if (classNameId != nil) {
        return [classNameId alloc];
    } else {
        EbrDebugLog("Class %s not found!\n", identifier);
        return nil;
    }
}

- (NSString*)originalClassName {
    return originalClassName;
}

- (NSString*)className {
    return className;
}

@end
