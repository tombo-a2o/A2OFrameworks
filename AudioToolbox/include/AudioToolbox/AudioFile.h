#ifndef __AudioFile__
#define __AudioFile__

#include <CoreFoundation/CoreFoundation.h>
#include <CoreAudio/CoreAudioTypes.h>

CF_EXTERN_C_BEGIN

typedef struct OpaqueAudioFileID *AudioFileID;

enum {
    kAudioFileReadPermission      = 0x01,
    kAudioFileWritePermission     = 0x02,
    kAudioFileReadWritePermission = 0x03 
};
typedef UInt32 AudioFilePermissions;

enum {
    kAudioFileAIFFType            = 'AIFF',
    kAudioFileAIFCType            = 'AIFC',
    kAudioFileWAVEType            = 'WAVE',
    kAudioFileSoundDesigner2Type  = 'Sd2f',
    kAudioFileNextType            = 'NeXT',
    kAudioFileMP3Type             = 'MPG3',
    kAudioFileMP2Type             = 'MPG2',
    kAudioFileMP1Type             = 'MPG1',
    kAudioFileAC3Type             = 'ac-3',
    kAudioFileAAC_ADTSType        = 'adts',
    kAudioFileMPEG4Type           = 'mp4f',
    kAudioFileM4AType             = 'm4af',
    kAudioFileCAFType             = 'caff',
    kAudioFile3GPType             = '3gpp',
    kAudioFile3GP2Type            = '3gp2',
    kAudioFileAMRType             = 'amrf'
};
typedef UInt32 AudioFileTypeID;

enum {
    kAudioFilePropertyFileFormat            = 'ffmt',
    kAudioFilePropertyDataFormat            = 'dfmt',
    kAudioFilePropertyIsOptimized           = 'optm',
    kAudioFilePropertyMagicCookieData       = 'mgic',
    kAudioFilePropertyAudioDataByteCount    = 'bcnt',
    kAudioFilePropertyAudioDataPacketCount  = 'pcnt',
    kAudioFilePropertyMaximumPacketSize     = 'psze',
    kAudioFilePropertyDataOffset            = 'doff',
    kAudioFilePropertyChannelLayout         = 'cmap',
    kAudioFilePropertyDeferSizeUpdates      = 'dszu',
    kAudioFilePropertyDataFormatName        = 'fnme',
    kAudioFilePropertyMarkerList            = 'mkls',
    kAudioFilePropertyRegionList            = 'rgls',
    kAudioFilePropertyPacketToFrame         = 'pkfr',
    kAudioFilePropertyFrameToPacket         = 'frpk',
    kAudioFilePropertyPacketToByte          = 'pkby',
    kAudioFilePropertyByteToPacket          = 'bypk',
    kAudioFilePropertyChunkIDs              = 'chid',
    kAudioFilePropertyInfoDictionary        = 'info',
    kAudioFilePropertyPacketTableInfo       = 'pnfo',
    kAudioFilePropertyFormatList            = 'flst',
    kAudioFilePropertyPacketSizeUpperBound  = 'pkub',
    kAudioFilePropertyReserveDuration       = 'rsrv',
    kAudioFilePropertyEstimatedDuration     = 'edur',
    kAudioFilePropertyBitRate               = 'brat',
    kAudioFilePropertyID3Tag                = 'id3t',
    kAudioFilePropertySourceBitDepth        = 'sbtd',
    kAudioFilePropertyAlbumArtwork          = 'aart'
};
typedef UInt32 AudioFilePropertyID;

OSStatus AudioFileOpenURL ( CFURLRef inFileRef, AudioFilePermissions inPermissions, AudioFileTypeID inFileTypeHint, AudioFileID *outAudioFile );
OSStatus AudioFileGetProperty ( AudioFileID inAudioFile, AudioFilePropertyID inPropertyID, UInt32 *ioDataSize, void *outPropertyData );
OSStatus AudioFileReadBytes ( AudioFileID inAudioFile, Boolean inUseCache, SInt64 inStartingByte, UInt32 * ioNumBytes, void *outBuffer );
OSStatus AudioFileClose ( AudioFileID inAudioFile );

CF_EXTERN_C_END

#endif
