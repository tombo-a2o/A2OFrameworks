#include <AudioToolbox/AudioSession.h>
#include <AudioToolbox/AudioFile.h>
#include <AudioToolbox/ExtendedAudioFile.h>
#include <CoreFoundation/CoreFoundation.h>

struct OpaqueExtAudioFile {
    CFStringRef path;
    AudioStreamBasicDescription clientFormat;
};

OSStatus ExtAudioFileOpenURL ( CFURLRef inURL, ExtAudioFileRef *outExtAudioFile ) {
    ExtAudioFileRef extAudio  = (ExtAudioFileRef)malloc(sizeof(struct OpaqueExtAudioFile));
    extAudio->path = CFURLCopyFileSystemPath(inURL, kCFURLPOSIXPathStyle);

    *outExtAudioFile = extAudio;
    return noErr;
}

extern float audioBuffer_sampleRate(const char* name);
extern int audioBuffer_length(const char* name);
extern int audioBuffer_numberOfChannels(const char* name);
extern void audioBuffer_read(const char* name, int channel, int bytes, void* dest);

OSStatus ExtAudioFileGetProperty ( ExtAudioFileRef inExtAudioFile, ExtAudioFilePropertyID inPropertyID, UInt32 * ioPropertyDataSize, void * outPropertyData ) {
    const char* filename = CFStringGetCStringPtr(inExtAudioFile->path, CFStringGetSystemEncoding());
    
    switch(inPropertyID) {
    case kExtAudioFileProperty_FileDataFormat:
        assert(*ioPropertyDataSize == sizeof(AudioStreamBasicDescription));
        AudioStreamBasicDescription *desc = (AudioStreamBasicDescription*)outPropertyData;
        // TODO parse file
        desc->mSampleRate = audioBuffer_sampleRate(filename);
        desc->mFormatID = kAudioFormatMPEGLayer3;
        desc->mFormatFlags = 0;
        desc->mBytesPerPacket = 0;
        desc->mFramesPerPacket = 1152;
        desc->mBytesPerFrame = 0;
        desc->mChannelsPerFrame = audioBuffer_numberOfChannels(filename);
        desc->mBitsPerChannel = 0;
        break;
    case kExtAudioFileProperty_FileLengthFrames:
        assert(*ioPropertyDataSize == sizeof(SInt64));
        SInt64 *length = (SInt64*)outPropertyData;
        *length = audioBuffer_length(filename);
        break;
    default:
        return 1;
    }
    return noErr;
}

OSStatus ExtAudioFileSetProperty ( ExtAudioFileRef inExtAudioFile, ExtAudioFilePropertyID inPropertyID, UInt32 inPropertyDataSize, const void * inPropertyData ) {
    const char* filename = CFStringGetCStringPtr(inExtAudioFile->path, CFStringGetSystemEncoding());
    
    switch(inPropertyID) {
    case kExtAudioFileProperty_ClientDataFormat:
        assert(inPropertyDataSize == sizeof(AudioStreamBasicDescription));
        AudioStreamBasicDescription *desc = (AudioStreamBasicDescription*)inPropertyData;
        assert(desc->mFormatID == kAudioFormatLinearPCM);
        inExtAudioFile->clientFormat = *desc;
        break;
    default:
        return 1;
    }
    return noErr;
}

OSStatus ExtAudioFileRead ( ExtAudioFileRef inExtAudioFile, UInt32 * ioNumberFrames, AudioBufferList * ioData ) {
    const char* filename = CFStringGetCStringPtr(inExtAudioFile->path, CFStringGetSystemEncoding());
    AudioStreamBasicDescription *format = &inExtAudioFile->clientFormat;
    AudioBuffer buffer = ioData->mBuffers[0];
    
    assert(ioData->mNumberBuffers == 1);
    
    assert(format->mFramesPerPacket == 1);
    assert(format->mFormatID == kAudioFormatLinearPCM);
    assert(format->mBytesPerPacket == format->mBytesPerFrame);
    
    int bytes = format->mBytesPerFrame / format->mChannelsPerFrame;
    
    assert(format->mBitsPerChannel == bytes * 8);
    
    audioBuffer_read(filename, buffer.mNumberChannels, bytes, buffer.mData);
    return 0;
}

OSStatus ExtAudioFileDispose ( ExtAudioFileRef inExtAudioFile ) {
    CFRelease(inExtAudioFile->path);
    free(inExtAudioFile);
    return noErr;
}
