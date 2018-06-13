/*
 *  MFMailComposeViewController.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <MessageUI/MFMailComposeViewController.h>

@implementation MFMailComposeViewController
+ (BOOL)canSendMail
{
    NSLog(@"%s is not implemented", __FUNCTION__);
    return NO;
}

- (void)setSubject:(NSString *)subject
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)setToRecipients:(NSArray<NSString *> *)toRecipients
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)setCcRecipients:(NSArray<NSString *> *)ccRecipients
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)setBccRecipients:(NSArray<NSString *> *)bccRecipients
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

- (void)addAttachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename
{
    NSLog(@"%s is not implemented", __FUNCTION__);
}

@end
