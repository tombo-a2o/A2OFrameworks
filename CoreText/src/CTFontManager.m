/*
 *  CTFontManager.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreText/CTFontManager.h>
#import <Foundation/Foundation.h>

#import <Onyx2D/O2Font.h>

bool CTFontManagerRegisterFontsForURL(CFURLRef fontURL, CTFontManagerScope scope, CFErrorRef *error)
{
    NSURL *url = (NSURL*)fontURL;
    if(![url isFileURL]) {
        NSLog(@"Cannot register fonts: file url only");
        return NO;
    }

    NSString *path = [url path];
    NSString *name = [[path lastPathComponent] stringByDeletingPathExtension];
    [O2Font registerFont:path withName:name];
    return NO;
}
