#ifndef __ExtendedAudioFile__
#define __ExtendedAudioFile__

#include <CoreFoundation/CoreFoundation.h>
#include <CoreAudio/CoreAudio.h>

CF_EXTERN_C_BEGIN

enum {
    kExtAudioFileProperty_FileDataFormat       = 'ffmt',
    kExtAudioFileProperty_FileChannelLayout    = 'fclo',
    kExtAudioFileProperty_ClientDataFormat     = 'cfmt',
    kExtAudioFileProperty_ClientChannelLayout  = 'cclo',
    kExtAudioFileProperty_CodecManufacturer    = 'cman',
    kExtAudioFileProperty_AudioConverter       = 'acnv',
    kExtAudioFileProperty_AudioFile            = 'afil',
    kExtAudioFileProperty_FileMaxPacketSize    = 'fmps',
    kExtAudioFileProperty_ClientMaxPacketSize  = 'cmps',
    kExtAudioFileProperty_FileLengthFrames     = '#frm',
    kExtAudioFileProperty_ConverterConfig      = 'accf',
    kExtAudioFileProperty_IOBufferSizeBytes    = 'iobs',
    kExtAudioFileProperty_IOBuffer             = 'iobf',
    kExtAudioFileProperty_PacketTable          = 'xpti'
};
typedef UInt32 ExtAudioFilePropertyID;

typedef struct OpaqueExtAudioFile *ExtAudioFileRef;

OSStatus ExtAudioFileOpenURL ( CFURLRef inURL, ExtAudioFileRef *outExtAudioFile );
OSStatus ExtAudioFileGetProperty ( ExtAudioFileRef inExtAudioFile, ExtAudioFilePropertyID inPropertyID, UInt32 * ioPropertyDataSize, void * outPropertyData );
OSStatus ExtAudioFileSetProperty ( ExtAudioFileRef inExtAudioFile, ExtAudioFilePropertyID inPropertyID, UInt32 inPropertyDataSize, const void * inPropertyData );
OSStatus ExtAudioFileRead ( ExtAudioFileRef inExtAudioFile, UInt32 * ioNumberFrames, AudioBufferList * ioData );
OSStatus ExtAudioFileDispose ( ExtAudioFileRef inExtAudioFile );

CF_EXTERN_C_END

#endif
