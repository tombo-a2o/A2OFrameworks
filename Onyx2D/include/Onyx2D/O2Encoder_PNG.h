/*
 *  O2Encoder_PNG.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2DataConsumer.h>
#import <Onyx2D/O2Image.h>
#import <stdbool.h>
#import <stdint.h>

typedef struct O2PNGEncoder {
    O2DataConsumerRef _consumer;
} * O2PNGEncoderRef;

O2PNGEncoderRef O2PNGEncoderCreate(O2DataConsumerRef consumer);
void O2PNGEncoderDealloc(O2PNGEncoderRef self);

void O2PNGEncoderWriteImage(O2PNGEncoderRef self, O2ImageRef image, CFDictionaryRef properties);
