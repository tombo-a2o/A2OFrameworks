/*
 *  UTType.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreFoundation/CoreFoundation.h>

extern const CFStringRef kUTTagClassFilenameExtension;
extern const CFStringRef kUTTagClassMIMEType;
extern const CFStringRef kUTTagClassNSPboardType;
extern const CFStringRef kUTTagClassOSType;

extern const CFStringRef kUTTypeImage;
extern const CFStringRef kUTTypeJPEG;
extern const CFStringRef kUTTypeJPEG2000;
extern const CFStringRef kUTTypeTIFF;
extern const CFStringRef kUTTypePICT;
extern const CFStringRef kUTTypeGIF;
extern const CFStringRef kUTTypePNG;
extern const CFStringRef kUTTypeQuickTimeImage;
extern const CFStringRef kUTTypeAppleICNS;
extern const CFStringRef kUTTypeBMP;
extern const CFStringRef kUTTypeICO;

CFStringRef UTTypeCreatePreferredIdentifierForTag ( CFStringRef inTagClass, CFStringRef inTag, CFStringRef inConformingToUTI );
CFArrayRef UTTypeCreateAllIdentifiersForTag ( CFStringRef inTagClass, CFStringRef inTag, CFStringRef inConformingToUTI );
CFStringRef UTTypeCopyPreferredTagWithClass ( CFStringRef inUTI, CFStringRef inTagClass );
