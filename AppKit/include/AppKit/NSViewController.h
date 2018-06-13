/*
 *  NSViewController.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <AppKit/NSResponder.h>

@class NSView;

@interface NSViewController : NSResponder {
    NSString *_nibName;
    NSBundle *_nibBundle;
    id _representedObject;
    NSString *_title;
    NSView *_view;
}

- initWithNibName:(NSString *)name bundle:(NSBundle *)bundle;

- (NSString *)nibName;
- (NSBundle *)nibBundle;

- (NSView *)view;
- (NSString *)title;
- representedObject;

- (void)setRepresentedObject:object;

- (void)setTitle:(NSString *)value;

- (void)setView:(NSView *)value;

- (void)loadView;

- (void)discardEditing;

- (BOOL)commitEditing;
- (void)commitEditingWithDelegate:delegate didCommitSelector:(SEL)didCommitSelector contextInfo:(void *)contextInfo;

@end
