/*
 *  UIStoryboardSegue.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIKit.h>

@interface UIStoryboardEmbedSegueTemplate : NSObject <NSCoding>
// - (id)initWithCoder:(NSCoder *)coder;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) UIViewController *viewController;
@end

@implementation UIStoryboardEmbedSegueTemplate
// - (id)initWithCoder:(NSCoder *)coder
// {
//     return self;
// }
@end

@interface UIStoryboardShowSegueTemplate : NSObject
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) UIViewController *viewController;
@end

@implementation UIStoryboardShowSegueTemplate
@end

@implementation UIStoryboardSegue
@end
