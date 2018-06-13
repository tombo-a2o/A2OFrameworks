/*
 *  O2Encoder_JPG.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#ifdef __APPLE__
// compiling on OS X
#else
//#import "O2Defines_libjpeg.h"
#endif

#ifdef LIBJPEG_PRESENT
#import <Onyx2D/O2DataConsumer.h>
#import <Onyx2D/O2Image.h>
#import <stdbool.h>
#import <stdint.h>

typedef struct O2JPGEncoder {
    O2DataConsumerRef _consumer;
} * O2JPGEncoderRef;

O2JPGEncoderRef O2JPGEncoderCreate(O2DataConsumerRef consumer);
void O2JPGEncoderDealloc(O2JPGEncoderRef self);

void O2JPGEncoderWriteImage(O2JPGEncoderRef self, O2ImageRef image, CFDictionaryRef properties);
#endif
