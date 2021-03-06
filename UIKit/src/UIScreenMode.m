/*
 * Copyright (c) 2011, The Iconfactory. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of The Iconfactory nor the names of its contributors may
 *    be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE ICONFACTORY BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <UIKit/UIScreenMode.h>
#import <UIKit/UIGeometry.h>
#import <emscripten.h>

extern unsigned int UIKit_getScreenModeNumber(void);
extern unsigned int UIKit_getScreenWidthAt(int idx);
extern unsigned int UIKit_getScreenHeightAt(int idx);
extern unsigned int UIKit_getScreenScaleAt(int idx);

@implementation UIScreenMode

+ (id)screenModeIphone5
{
    UIScreenMode *mode = [[self alloc] init];
    mode->_size = CGSizeMake(640, 1136);
    mode->_pixelAspectRatio = 2.0;
    return mode;
}

+ (NSArray*)_userDefinedModes
{
    int num = UIKit_getScreenModeNumber();

    if(!num) return nil;

    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:num];
    for(int i = 0; i < num; i++) {
        UIScreenMode *mode = [[UIScreenMode alloc] init];
        int width = UIKit_getScreenWidthAt(i);
        int height = UIKit_getScreenHeightAt(i);
        float scale = UIKit_getScreenScaleAt(i);
        mode->_size = CGSizeMake(width, height);
        mode->_pixelAspectRatio = scale;
        [ret addObject:mode];
    }
    return ret;
}

- (CGSize)logicalSize
{
    return CGSizeMake(_size.width/_pixelAspectRatio, _size.height/_pixelAspectRatio);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; size = %@>", [self class], self, NSStringFromCGSize(self.size)];
}

@end
