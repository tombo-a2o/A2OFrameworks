#ifndef __AudioSession__
#define __AudioSession__

#include <Foundation/NSString.h>

extern NSString *const AVAudioSessionCategoryAmbient;
extern NSString *const AVAudioSessionCategorySoloAmbient;
extern NSString *const AVAudioSessionCategoryPlayback;
extern NSString *const AVAudioSessionCategoryRecord;
extern NSString *const AVAudioSessionCategoryPlayAndRecord;
extern NSString *const AVAudioSessionCategoryAudioProcessing;
extern NSString *const AVAudioSessionCategoryMultiRoute;


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
typedef UInt32 AudioSessionPropertyID;

OSStatus AudioSessionGetProperty ( AudioSessionPropertyID inID, UInt32 *ioDataSize, void *outData );

#endif
