/*
 *  O2EXIFDecoder.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

//
//  O2EXIFDecoder.h
//  AppKit
//
//  Created by Airy ANDRE on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface O2EXIFDecoder : NSObject {
    NSMutableDictionary *_tags;
}
- (id)initWithBytes:(const uint8_t *)bytes length:(size_t)length;
- (NSMutableDictionary *)tags;
@end
