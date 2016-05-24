#include <AudioToolbox/AudioSession.h>
#include <AudioToolbox/AudioFile.h>
#include <CoreFoundation/CoreFoundation.h>

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
