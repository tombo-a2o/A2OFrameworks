/*
 *  CVBase.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <CoreFoundation/CoreFoundation.h>

#define COREVIDEO_EXPORT extern

typedef uint64_t CVOptionFlags;

struct CVSMPTETime {
    SInt16 subframes;
    SInt16 subframeDivisor;
    UInt32 counter;
    UInt32 type;
    UInt32 flags;
    SInt16 hours;
    SInt16 minutes;
    SInt16 seconds;
    SInt16 frames;
};

typedef struct CVSMPTETime CVSMPTETime;

typedef struct {
    uint32_t version;
    int32_t videoTimeScale;
    int64_t videoTime;
    uint64_t hostTime;
    double rateScalar;
    int64_t videoRefreshPeriod;
    CVSMPTETime smpteTime;
    uint64_t flags;
    uint64_t reserved;
} CVTimeStamp;
