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

#import "UIPhotosAlbum.h"
#import <UIKit/UIKit.h>
#import <emscripten.h>

@implementation UIPhotosAlbum

+ (UIPhotosAlbum *)sharedPhotosAlbum
{
    static UIPhotosAlbum *album = nil;

    if (!album) {
        album = [[self alloc] init];
    }

    return album;
}

- (void)writeImage:(UIImage *)image completionTarget:(id)target action:(SEL)action context:(void *)context
{
    if (image) {
        NSData *data = UIImagePNGRepresentation(image);
        NSError *error = nil;

        // http://qiita.com/ukyo/items/d623209655a003b13add
        EM_ASM_({
            var a = document.createElement('a');
            var blob = new Blob([HEAPU8.subarray($0, $0+$1)], {type: 'image/png'});
            var url = window.URL.createObjectURL(blob);
            a.href = url;
            a.download = 'image'+(new Date().toISOString().replace(/[-:.TZ]/g,''))+'.png';
            var e = document.createEvent('MouseEvent');
            e.initEvent("click", true, true, window, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
            a.dispatchEvent(e);
        }, data.bytes, data.length);

        if (target) {
            typedef void(*ActionMethod)(id, SEL, id, NSError *, void *);
            ActionMethod method = (ActionMethod)[target methodForSelector:action];
            method(target, action, image, error, context);
        }
    }
}

@end
