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

#import <UIKit/UIView.h>
#import <UIKit/UIImage.h>

@interface UIImageNibPlaceholder : NSObject
@end

@implementation UIImageNibPlaceholder : NSObject
- (instancetype)initWithCoder:(NSCoder*)coder {
    id result = self;
    NSString* resourceName = [coder decodeObjectForKey:@"UIResourceName"];
    
    
    if (resourceName != nil) {
        id ret = [UIImage imageNamed:resourceName];
        NSLog(@"ret %@ %@", resourceName, ret);
        if (ret == nil) {
            ret = [UIImage imageWithCGImage:nil];
        }

        if ([coder containsValueForKey:@"UIImageWidth"] || [coder containsValueForKey:@"UIImageHeight"]) {
            float width = [coder decodeFloatForKey:@"UIImageWidth"];
            float height = [coder decodeFloatForKey:@"UIImageHeight"];

            if (width != 1.0 || height != 1.0) {
                assert(0);
                // ret = [[ret stretchableImageWithLeftCapWidth:width topCapHeight:height] retain];
            }
        }
        result = ret;
    }

    return result;
}

@end
