/*
 *  UIAlertView+Blocks.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIAlertView.h>

@interface UIAlertView (WithBlocks)
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
     clickedHandler:(void(^)(UIAlertView*, NSInteger))clickedHandler
    canceledHandler:(void(^)(UIAlertView*))canceledHandler
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;
@end
