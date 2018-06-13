/*
 *  AudioSession.c
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#include <AudioToolbox/AudioSession.h>

OSStatus AudioSessionGetProperty ( AudioSessionPropertyID inID, UInt32 *ioDataSize, void *outData ) {
    switch(inID) {
    case kAudioSessionProperty_OtherAudioIsPlaying:
        assert(*ioDataSize == sizeof(UInt32));
        UInt32 *isPlaying = (UInt32*)outData;
        isPlaying = 0;
        break;
    default:
        assert(0);
    }
    return noErr;
}

OSStatus AudioSessionSetProperty ( AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData ) {

    return noErr;
}

OSStatus AudioSessionInitialize ( CFRunLoopRef inRunLoop, CFStringRef inRunLoopMode,
                                    AudioSessionInterruptionListener inInterruptionListener, void *inClientData ) {

    return noErr;
}

OSStatus AudioSessionSetActive ( Boolean active ) {
    fprintf(stderr, "AudioSessionSetActive is not implemented\n");
    return noErr;
}
