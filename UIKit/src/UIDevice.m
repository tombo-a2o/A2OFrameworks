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

#import <UIKit/UIKit.h>
#import "UIScreen+UIPrivate.h"
#import <SystemConfiguration/SystemConfiguration.h>

NSString *const UIDeviceOrientationDidChangeNotification = @"UIDeviceOrientationDidChangeNotification";

static UIDevice *theDevice;

@interface UIDevice () {
    UIDeviceOrientation _orientation;
}
@property (nonatomic, readwrite) UIDeviceOrientation orientation;
@end

void setDeviceOrientation(UIDeviceOrientation orientation) __attribute__((used))
{
    theDevice.orientation = orientation;
}

@implementation UIDevice

+ (void)initialize
{
    if (self == [UIDevice class]) {
        theDevice = [[UIDevice alloc] init];
    }
}

+ (UIDevice *)currentDevice
{
    return theDevice;
}

- (id)init
{
    if ((self=[super init])) {
        _userInterfaceIdiom = UIUserInterfaceIdiomPhone;
        _orientation = UIDeviceOrientationPortrait;
    }
    return self;
}

- (NSString *)name
{
    return (__bridge_transfer NSString *)SCDynamicStoreCopyComputerName(NULL,NULL);
}

- (void)setOrientation:(UIDeviceOrientation)orientation
{
    if(_orientation != orientation) {
        _orientation = orientation;
        [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:self];
    }
}

- (UIDeviceOrientation)orientation
{
    return _orientation;
}

- (BOOL)isMultitaskingSupported
{
    return YES;
}

- (NSString *)systemName
{
    return [[NSProcessInfo processInfo] operatingSystemName];
}

- (NSString *)systemVersion
{
    return @"8.0";
}

- (NSString *)model
{
    return @"Mac";
}

- (NSString*)uniqueIdentifier
{
    return @"";
}

- (BOOL)isGeneratingDeviceOrientationNotifications
{
    return NO;
}

- (void)beginGeneratingDeviceOrientationNotifications
{
}

- (void)endGeneratingDeviceOrientationNotifications
{
}

@end
