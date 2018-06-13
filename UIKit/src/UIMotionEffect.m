/*
 *  UIMotionEffect.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIKit.h>

@implementation UIMotionEffect
- (instancetype)init
{
    NSLog(@"*** %s is not implemented yet", __FUNCTION__);
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"*** %s is not implemented yet", __FUNCTION__);
    return nil;
}

- (NSDictionary<NSString *,id> *)keyPathsAndRelativeValuesForViewerOffset:(UIOffset)viewerOffset
{
    NSLog(@"*** %s is not implemented yet", __FUNCTION__);
    return nil;
}

@end

@implementation UIInterpolatingMotionEffect
- (instancetype)initWithKeyPath:(NSString *)keyPath type:(UIInterpolatingMotionEffectType)type
{
    NSLog(@"*** %s is not implemented yet", __FUNCTION__);
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"*** %s is not implemented yet", __FUNCTION__);
    return nil;
}
@end

@implementation UIMotionEffectGroup
@end
