/*
 *  CTFontManager.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreFoundation/CoreFoundation.h>

enum {
    kCTFontManagerScopeNone = 0,
    kCTFontManagerScopeProcess = 1,
    kCTFontManagerScopeUser = 2,
    kCTFontManagerScopeSession = 3
};
typedef uint32_t CTFontManagerScope;

extern bool CTFontManagerRegisterFontsForURL(CFURLRef fontURL, CTFontManagerScope scope, CFErrorRef *error);
