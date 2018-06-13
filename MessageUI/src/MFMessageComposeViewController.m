/*
 *  MFMessageComposeViewController.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <MessageUI/MessageUI.h>

@implementation MFMessageComposeViewController
+ (BOOL)canSendText
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return NO;
}

+ (BOOL)canSendAttachments;
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return NO;
}

+ (BOOL)canSendSubject;
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return NO;
}

+ (BOOL)isSupportedAttachmentUTI:(NSString *)uti;
{
    NSLog(@"%s not implemented", __FUNCTION__);
    return NO;
}

@end
