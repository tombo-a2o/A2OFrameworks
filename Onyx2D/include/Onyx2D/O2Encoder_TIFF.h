/*
 *  O2Encoder_TIFF.h
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

typedef struct O2TIFFEncoder {
    bool _bigEndian;
    size_t _consumerOffset;
    size_t _consumerPosition;
    size_t _bufferCapacity;
    size_t _bufferCount;
    uint8_t *_mutableBytes;
    CFIndex _length;
    O2DataConsumerRef _consumer;
} * O2TIFFEncoderRef;

O2TIFFEncoderRef O2TIFFEncoderCreate(O2DataConsumerRef consumer);
void O2TIFFEncoderDealloc(O2TIFFEncoderRef self);

void O2TIFFEncoderBegin(O2TIFFEncoderRef self);
void O2TIFFEncoderWriteImage(O2TIFFEncoderRef self, O2ImageRef image, CFDictionaryRef properties, bool lastImage);
void O2TIFFEncoderEnd(O2TIFFEncoderRef self);
