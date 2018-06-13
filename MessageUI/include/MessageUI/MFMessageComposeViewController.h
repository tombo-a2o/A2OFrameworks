/*
 *  MFMessageComposeViewController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIKit.h>

enum MessageComposeResult {
    MessageComposeResultCancelled,
    MessageComposeResultSent,
    MessageComposeResultFailed
};
typedef enum MessageComposeResult MessageComposeResult;

@protocol MFMessageComposeViewControllerDelegate
@end

@interface MFMessageComposeViewController : UINavigationController
+ (BOOL)canSendText;
+ (BOOL)canSendAttachments;
+ (BOOL)canSendSubject;
+ (BOOL)isSupportedAttachmentUTI:(NSString *)uti;
@property(nonatomic, assign) id< MFMessageComposeViewControllerDelegate > messageComposeDelegate;

@property(nonatomic, copy) NSArray *recipients;
@property(nonatomic, copy) NSString *subject;
@property(nonatomic, copy) NSString *body;
@property(nonatomic, copy, readonly) NSArray *attachments;
@end
