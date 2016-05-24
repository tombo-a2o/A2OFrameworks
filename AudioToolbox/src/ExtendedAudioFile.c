#include <AudioToolbox/AudioSession.h>
#include <AudioToolbox/AudioFile.h>
#include <AudioToolbox/ExtendedAudioFile.h>
#include <CoreFoundation/CoreFoundation.h>

struct OpaqueExtAudioFile {
};

OSStatus ExtAudioFileOpenURL ( CFURLRef inURL, ExtAudioFileRef *outExtAudioFile ) {
    return 1;
}

OSStatus ExtAudioFileGetProperty ( ExtAudioFileRef inExtAudioFile, ExtAudioFilePropertyID inPropertyID, UInt32 * ioPropertyDataSize, void * outPropertyData ) {
    return 1;
}

OSStatus ExtAudioFileSetProperty ( ExtAudioFileRef inExtAudioFile, ExtAudioFilePropertyID inPropertyID, UInt32 inPropertyDataSize, const void * inPropertyData ) {
    return 1;
}

OSStatus ExtAudioFileRead ( ExtAudioFileRef inExtAudioFile, UInt32 * ioNumberFrames, AudioBufferList * ioData ) {
    return 1;
}

OSStatus ExtAudioFileDispose ( ExtAudioFileRef inExtAudioFile ) {
    return 1;
}
