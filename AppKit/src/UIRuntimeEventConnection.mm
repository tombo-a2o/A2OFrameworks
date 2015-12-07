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

#define EbrDebugLog(fmt, ...) NSLog(@fmt, __VA_ARGS__)

@implementation UIRuntimeEventConnection
- (id)initWithCoder:(NSCoder*)coder {
    targetControl = [coder decodeObjectForKey:@"UISource"];
    obj = [coder decodeObjectForKey:@"UIDestination"];
    selector = (SEL)NSSelectorFromString([coder decodeObjectForKey:@"UILabel"]);
    mask = [coder decodeInt32ForKey:@"UIEventMask"];

    return self;
}

- (void)makeConnection {
    EbrDebugLog("Source: %s\n", object_getClassName(targetControl));
    EbrDebugLog("Dest: %s\n", obj != nil ? object_getClassName(obj) : "nil (first responder?)");
    EbrDebugLog("Event label: %s\n", sel_getName(selector));
    EbrDebugLog("Event mask: %x\n", mask);

    valid = TRUE;

    if (obj != nil) {
        if ([obj isKindOfClass:[UIProxyObject class]]) {
            UIProxyObject *proxy = obj;
            obj = [proxy _getObject];
        }
    }

    assert(0);
    //[targetControl addEventConnection:self];
}

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
