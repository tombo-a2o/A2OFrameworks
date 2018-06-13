/*
 *  MFMailComposeViewController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MFMailComposeResult) {
    MFMailComposeResultCancelled,
    MFMailComposeResultSaved,
    MFMailComposeResultSent,
    MFMailComposeResultFailed,
};

@protocol MFMailComposeViewControllerDelegate
@end

@interface MFMailComposeViewController : UINavigationController
+ (BOOL)canSendMail;
- (void)setSubject:(NSString *)subject;
- (void)setToRecipients:(NSArray<NSString *> *)toRecipients;
- (void)setCcRecipients:(NSArray<NSString *> *)ccRecipients;
- (void)setBccRecipients:(NSArray<NSString *> *)bccRecipients;
- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML;
- (void)addAttachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename;
@property(nonatomic, assign) id<MFMailComposeViewControllerDelegate> mailComposeDelegate;
@end
