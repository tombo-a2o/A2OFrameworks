#include <AudioToolbox/AudioFile.h>

OSStatus AudioFileOpenURL ( CFURLRef inFileRef, AudioFilePermissions inPermissions, AudioFileTypeID inFileTypeHint, AudioFileID *outAudioFile )
{
    printf("%s is not implemented\n",__FUNCTION__);
    return -1;
}

OSStatus AudioFileGetProperty ( AudioFileID inAudioFile, AudioFilePropertyID inPropertyID, UInt32 *ioDataSize, void *outPropertyData )
{
    printf("%s is not implemented\n",__FUNCTION__);
    return -1;
}

OSStatus AudioFileReadBytes ( AudioFileID inAudioFile, Boolean inUseCache, SInt64 inStartingByte, UInt32 * ioNumBytes, void *outBuffer )
{
    printf("%s is not implemented\n",__FUNCTION__);
    return -1;
}

OSStatus AudioFileClose ( AudioFileID inAudioFile )
{
    printf("%s is not implemented\n",__FUNCTION__);
    return -1;
}
