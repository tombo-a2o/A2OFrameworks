#import <CoreVideo/CVBase.h>

enum {
    kCVReturnSuccess = 0,
    kCVReturnFirst = -6660,
    kCVReturnError = -6660,
    kCVReturnInvalidArgument = -6661,
    kCVReturnAllocationFailed = -6662,
    kCVReturnInvalidDisplay = -6670,
    kCVReturnDisplayLinkAlreadyRunning = -6671,
    kCVReturnDisplayLinkNotRunning = -6672,
    kCVReturnDisplayLinkCallbacksNotSet = -6673,
    kCVReturnInvalidPixelFormat = -6680,
    kCVReturnInvalidSize = -6681,
    kCVReturnInvalidPixelBufferAttributes = -6682,
    kCVReturnPixelBufferNotOpenGLCompatible = -6683,
    kCVReturnPoolAllocationFailed = -6690,
    kCVReturnInvalidPoolAttributes = -6691,
    kCVReturnLast = -6699
};

typedef int32_t CVReturn;
