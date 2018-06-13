/*
 *  loop.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/Foundation.h>
#include <time.h>

@interface Hoge : NSObject
- (id)doIt:(id)dummy;
@end

@implementation Hoge
- (id)doIt:(id)dummy  {
  NSLog(@"hogehoge");
  return nil;
}
@end

int main(void)
{
  Hoge *hoge = [[Hoge alloc] init];

  [hoge doIt:nil];
  [hoge performSelector:@selector(doIt:) withObject:nil];
  [hoge performSelector:@selector(doIt:) withObject:nil afterDelay:2.0f];
  [[NSRunLoop currentRunLoop] run];

	return 0;
}
