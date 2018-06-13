/*
 *  CoreAudioTypes.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#ifndef __CoreAudio__
#define __CoreAudio__

#include <MacTypes.h>

struct AudioStreamBasicDescription {
    Float64 mSampleRate;
    UInt32 mFormatID;
    UInt32 mFormatFlags;
    UInt32 mBytesPerPacket;
    UInt32 mFramesPerPacket;
    UInt32 mBytesPerFrame;
    UInt32 mChannelsPerFrame;
    UInt32 mBitsPerChannel;
    UInt32 mReserved;
};
typedef struct AudioStreamBasicDescription AudioStreamBasicDescription;

struct AudioBuffer {
    UInt32 mNumberChannels;
    UInt32 mDataByteSize;
    void *mData;
};
typedef struct AudioBuffer AudioBuffer;

struct AudioBufferList {
    UInt32 mNumberBuffers;
    AudioBuffer mBuffers[1];
};
typedef struct AudioBufferList AudioBufferList;


enum {
    kAudioFormatLinearPCM               = 'lpcm',
    kAudioFormatAC3                     = 'ac-3',
    kAudioFormat60958AC3                = 'cac3',
    kAudioFormatAppleIMA4               = 'ima4',
    kAudioFormatMPEG4AAC                = 'aac ',
    kAudioFormatMPEG4CELP               = 'celp',
    kAudioFormatMPEG4HVXC               = 'hvxc',
    kAudioFormatMPEG4TwinVQ             = 'twvq',
    kAudioFormatMACE3                   = 'MAC3',
    kAudioFormatMACE6                   = 'MAC6',
    kAudioFormatULaw                    = 'ulaw',
    kAudioFormatALaw                    = 'alaw',
    kAudioFormatQDesign                 = 'QDMC',
    kAudioFormatQDesign2                = 'QDM2',
    kAudioFormatQUALCOMM                = 'Qclp',
    kAudioFormatMPEGLayer1              = '.mp1',
    kAudioFormatMPEGLayer2              = '.mp2',
    kAudioFormatMPEGLayer3              = '.mp3',
    kAudioFormatTimeCode                = 'time',
    kAudioFormatMIDIStream              = 'midi',
    kAudioFormatParameterValueStream    = 'apvs',
    kAudioFormatAppleLossless           = 'alac',
    kAudioFormatMPEG4AAC_HE             = 'aach',
    kAudioFormatMPEG4AAC_LD             = 'aacl',
    kAudioFormatMPEG4AAC_ELD            = 'aace',
    kAudioFormatMPEG4AAC_ELD_SBR        = 'aacf',
    kAudioFormatMPEG4AAC_HE_V2          = 'aacp',
    kAudioFormatMPEG4AAC_Spatial        = 'aacs',
    kAudioFormatAMR                     = 'samr',
    kAudioFormatAudible                 = 'AUDB',
    kAudioFormatiLBC                    = 'ilbc',
    kAudioFormatDVIIntelIMA             = 0x6D730011,
    kAudioFormatMicrosoftGSM            = 0x6D730031,
    kAudioFormatAES3                    = 'aes3'
};

enum {
    kAudioFormatFlagIsFloat                  = (1 << 0),    // 0x1
    kAudioFormatFlagIsBigEndian              = (1 << 1),    // 0x2
    kAudioFormatFlagIsSignedInteger          = (1 << 2),    // 0x4
    kAudioFormatFlagIsPacked                 = (1 << 3),    // 0x8
    kAudioFormatFlagIsAlignedHigh            = (1 << 4),    // 0x10
    kAudioFormatFlagIsNonInterleaved         = (1 << 5),    // 0x20
    kAudioFormatFlagIsNonMixable             = (1 << 6),    // 0x40
    kAudioFormatFlagsAreAllClear             = (1 << 31),

    kLinearPCMFormatFlagIsFloat              = kAudioFormatFlagIsFloat,
    kLinearPCMFormatFlagIsBigEndian          = kAudioFormatFlagIsBigEndian,
    kLinearPCMFormatFlagIsSignedInteger      = kAudioFormatFlagIsSignedInteger,
    kLinearPCMFormatFlagIsPacked             = kAudioFormatFlagIsPacked,
    kLinearPCMFormatFlagIsAlignedHigh        = kAudioFormatFlagIsAlignedHigh,
    kLinearPCMFormatFlagIsNonInterleaved     = kAudioFormatFlagIsNonInterleaved,
    kLinearPCMFormatFlagIsNonMixable         = kAudioFormatFlagIsNonMixable,
    kLinearPCMFormatFlagsSampleFractionShift = 7,
    kLinearPCMFormatFlagsSampleFractionMask  = (0x3F << kLinearPCMFormatFlagsSampleFractionShift ),
    kLinearPCMFormatFlagsAreAllClear         = kAudioFormatFlagsAreAllClear,

    kAppleLosslessFormatFlag_16BitSourceData = 1,
    kAppleLosslessFormatFlag_20BitSourceData = 2,
    kAppleLosslessFormatFlag_24BitSourceData = 3,
    kAppleLosslessFormatFlag_32BitSourceData = 4
};

enum {
#if TARGET_RT_BIG_ENDIAN
    kAudioFormatFlagsNativeEndian       = kAudioFormatFlagIsBigEndian,
#else
    kAudioFormatFlagsNativeEndian       = 0,
#endif

#if !CA_PREFER_FIXED_POINT
    kAudioFormatFlagsCanonical          =   kAudioFormatFlagIsFloat | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked,
    kAudioFormatFlagsAudioUnitCanonical =   kAudioFormatFlagIsFloat | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved,
#else
    kAudioFormatFlagsCanonical          =   kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked,
    kAudioFormatFlagsAudioUnitCanonical =   kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved | (kAudioUnitSampleFractionBits << kLinearPCMFormatFlagsSampleFractionShift ),

#endif
    kAudioFormatFlagsNativeFloatPacked  =   kAudioFormatFlagIsFloat | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked
};

#define TestAudioFormatNativeEndian(f) ( (f.mFormatID == kAudioFormatLinearPCM) && ((f.mFormatFlags & kAudioFormatFlagIsBigEndian) == kAudioFormatFlagsNativeEndian) )

#endif
