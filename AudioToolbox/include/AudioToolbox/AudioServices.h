/*
 *  AudioServices.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#ifndef __AudioServices__
#define __AudioServices__

#include <CoreFoundation/CoreFoundation.h>
#include <CoreAudio/CoreAudioTypes.h>

CF_EXTERN_C_BEGIN

typedef UInt32 SystemSoundID;

CF_ENUM(SystemSoundID)
{
  kSystemSoundID_Vibrate = 0x00000FFF
};

void AudioServicesPlaySystemSound(SystemSoundID inSystemSoundID);

CF_EXTERN_C_END

#endif
