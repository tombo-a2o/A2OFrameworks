/*
 *  UIPasteboard.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <UIKit/UIPasteboard.h>

@implementation UIPasteboard

+ (UIPasteboard *)generalPasteboard
{
    return nil;
}
+ (UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create
{
    return nil;
}

- (void)addItems:(NSArray *)items
{

}

- (void)setData:(NSData *)data forPasteboardType:(NSString *)pasteboardType
{

}

- (void)setValue:(id)value forPasteboardType:(NSString *)pasteboardType
{

}


@end
