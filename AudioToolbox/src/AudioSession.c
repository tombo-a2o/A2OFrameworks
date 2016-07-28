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
