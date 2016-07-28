#ifndef __AudioSession__
#define __AudioSession__

#include <CoreFoundation/CoreFoundation.h>

enum {
    kAudioSessionProperty_PreferredHardwareSampleRate          = 'hwsr',
    kAudioSessionProperty_PreferredHardwareIOBufferDuration    = 'iobd',
    kAudioSessionProperty_AudioCategory                        = 'acat',
    kAudioSessionProperty_AudioRouteChange                     = 'roch',
    kAudioSessionProperty_CurrentHardwareSampleRate            = 'chsr',
    kAudioSessionProperty_CurrentHardwareInputNumberChannels   = 'chic',
    kAudioSessionProperty_CurrentHardwareOutputNumberChannels  = 'choc',
    kAudioSessionProperty_CurrentHardwareOutputVolume          = 'chov',
    kAudioSessionProperty_CurrentHardwareInputLatency          = 'cilt',
    kAudioSessionProperty_CurrentHardwareOutputLatency         = 'colt',
    kAudioSessionProperty_CurrentHardwareIOBufferDuration      = 'chbd',
    kAudioSessionProperty_OtherAudioIsPlaying                  = 'othr',
    kAudioSessionProperty_OverrideAudioRoute                   = 'ovrd',
    kAudioSessionProperty_AudioInputAvailable                  = 'aiav',
    kAudioSessionProperty_ServerDied                           = 'died',
    kAudioSessionProperty_OtherMixableAudioShouldDuck          = 'duck',
    kAudioSessionProperty_OverrideCategoryMixWithOthers        = 'cmix',
    kAudioSessionProperty_OverrideCategoryDefaultToSpeaker     = 'cspk',
    kAudioSessionProperty_OverrideCategoryEnableBluetoothInput = 'cblu',
    kAudioSessionProperty_InterruptionType                     = 'type',
    kAudioSessionProperty_Mode                                 = 'mode',
    kAudioSessionProperty_InputSources                         = 'srcs',
    kAudioSessionProperty_OutputDestinations                   = 'dsts',
    kAudioSessionProperty_InputSource                          = 'isrc',
    kAudioSessionProperty_OutputDestination                    = 'odst',
    kAudioSessionProperty_InputGainAvailable                   = 'igav',
    kAudioSessionProperty_InputGainScalar                      = 'igsc',
    kAudioSessionProperty_AudioRouteDescription                = 'crar',
};
enum {
    kAudioSessionProperty_AudioRoute  = 'rout'
};
enum {
    kAudioSessionCategory_AmbientSound              = 'ambi',
    kAudioSessionCategory_SoloAmbientSound          = 'solo',
    kAudioSessionCategory_MediaPlayback             = 'medi',
    kAudioSessionCategory_RecordAudio               = 'reca',
    kAudioSessionCategory_PlayAndRecord             = 'plar',
    kAudioSessionCategory_AudioProcessing           = 'proc'
};
enum {
    kAudioSessionBeginInterruption  = 1,
    kAudioSessionEndInterruption    = 0
};

typedef UInt32 AudioSessionPropertyID;
typedef void (*AudioSessionInterruptionListener)( void *inClientData, UInt32 inInterruptionState );

OSStatus AudioSessionGetProperty ( AudioSessionPropertyID inID, UInt32 *ioDataSize, void *outData );
OSStatus AudioSessionSetProperty ( AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData );
OSStatus AudioSessionInitialize ( CFRunLoopRef inRunLoop, CFStringRef inRunLoopMode, AudioSessionInterruptionListener inInterruptionListener, void *inClientData );
OSStatus AudioSessionSetActive ( Boolean active );

#endif
