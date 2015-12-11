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

#import "UIRuntimeEventConnection.h"
#import "UIProxyObject.h"
#import <UIKit/UIControl.h>

#if defined(DEBUG)
#define EbrDebugLog(...) fprintf(stderr, __VA_ARGS__)
#else
#define EbrDebugLog(...)
#endif

@implementation UIRuntimeEventConnection
- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    mask = [coder decodeInt32ForKey:@"UIEventMask"];
    return self;
}

- (void)makeConnection {
    EbrDebugLog("Source: %s\n", object_getClassName(source));
    EbrDebugLog("Dest: %s\n", destination != nil ? object_getClassName(destination) : "nil (first responder?)");
    EbrDebugLog("Event label: %s\n", [label UTF8String]);
    EbrDebugLog("Event mask: %x\n", mask);

    valid = TRUE;

    if (destination != nil) {
        if ([destination isKindOfClass:[UIProxyObject class]]) {
            UIProxyObject *proxy = destination;
            destination = [proxy _getObject];
        }
    }
    
    UIControl *control = source;
    [control addTarget:destination action:NSSelectorFromString(label) forControlEvents:mask];
}

/*
- (instancetype)initWithTarget:(id)target sel:(id)targetsel eventMask:(uint32_t)targetmask {
    obj = target;
    selector = (SEL)NSSelectorFromString(targetsel);
    mask = targetmask;

    valid = TRUE;

    return self;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)targetSel eventMask:(uint32_t)targetmask {
    obj = target;
    selector = targetSel;
    mask = targetmask;

    valid = TRUE;

    return self;
}

- (id)obj {
    return obj;
}

- (SEL)sel {
    return selector;
}
*/

- (uint32_t)mask {
    return mask;
}

- (BOOL)isValid {
    return valid;
}

- (void)invalidate {
    valid = FALSE;
}

@end
