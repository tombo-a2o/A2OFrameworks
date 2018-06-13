/*
 *  CGImageDestination.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */


typedef struct O2ImageDestination *CGImageDestinationRef;

#import <CoreGraphics/CGImage.h>
#import <CoreGraphics/CGImageSource.h>
#import <CoreGraphics/CGDataConsumer.h>
#import <CoreFoundation/CFURL.h>
#import <MobileCoreServices/UTType.h>

COREGRAPHICS_EXPORT const CFStringRef kCGImageDestinationLossyCompressionQuality;
COREGRAPHICS_EXPORT const CFStringRef kCGImageDestinationBackgroundColor;
COREGRAPHICS_EXPORT const CFStringRef kCGImageDestinationDPI;

COREGRAPHICS_EXPORT CFTypeID CGImageDestinationGetTypeID(void);

COREGRAPHICS_EXPORT CFArrayRef CGImageDestinationCopyTypeIdentifiers(void);

COREGRAPHICS_EXPORT CGImageDestinationRef CGImageDestinationCreateWithData(CFMutableDataRef data, CFStringRef type, size_t imageCount, CFDictionaryRef options);
COREGRAPHICS_EXPORT CGImageDestinationRef CGImageDestinationCreateWithDataConsumer(CGDataConsumerRef dataConsumer, CFStringRef type, size_t imageCount, CFDictionaryRef options);
COREGRAPHICS_EXPORT CGImageDestinationRef CGImageDestinationCreateWithURL(CFURLRef url, CFStringRef type, size_t imageCount, CFDictionaryRef options);

COREGRAPHICS_EXPORT void CGImageDestinationSetProperties(CGImageDestinationRef self, CFDictionaryRef properties);

COREGRAPHICS_EXPORT void CGImageDestinationAddImage(CGImageDestinationRef self, CGImageRef image, CFDictionaryRef properties);
COREGRAPHICS_EXPORT void CGImageDestinationAddImageFromSource(CGImageDestinationRef self, CGImageSourceRef imageSource, size_t index, CFDictionaryRef properties);

COREGRAPHICS_EXPORT bool CGImageDestinationFinalize(CGImageDestinationRef self);
