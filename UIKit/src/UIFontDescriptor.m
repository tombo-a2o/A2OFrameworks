/*
 *  UIFontDescriptor.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIFontDescriptor.h>

@implementation UIFontDescriptor

+ (UIFontDescriptor *)preferredFontDescriptorWithTextStyle:(UIFontTextStyle)style
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (UIFontDescriptor *)fontDescriptorWithSymbolicTraits:(UIFontDescriptorSymbolicTraits)symbolicTraits
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

@end
