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
