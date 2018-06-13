/*
 *  UIAlertController.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIAlertController.h>
#import <UIKit/UITextField.h>

@implementation UIAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle {
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

- (void)addAction:(UIAlertAction *)action
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end

@implementation UIAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler
{
    NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}

@end
