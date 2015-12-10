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

#include "UIRuntimeOutletConnection.h"

#if defined(DEBUG)
#define EbrDebugLog(...) fprintf(stderr, __VA_ARGS__)
#else
#define EbrDebugLog(...)
#endif

@implementation UIRuntimeOutletConnection
- (instancetype)initWithCoder:(NSCoder*)coder {
    return [super initWithCoder:coder];
}

- (void)makeConnection {
    const char* labelName = [label UTF8String];
    if (source != nil) {
        EbrDebugLog("Setting property on %s: %s\n", object_getClassName(source), labelName);
    } else {
        EbrDebugLog("Source = nil, can't set property %s\n", labelName);
    }

    [source setValue:destination forKey:label];
}

@end
