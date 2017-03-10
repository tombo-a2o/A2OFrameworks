#import <OpenGL/gl.h>
#ifdef WINDOWS
#import <OpenGL/glext.h>
#import <OpenGL/glweak.h>
#endif

#import <OpenGL/CGLTypes.h>
#import <OpenGL/CGLCurrent.h>

CGL_EXPORT CGLError CGLCreateContext(CGLPixelFormatObj pixelFormat, CGLContextObj share, CGLContextObj *result);

CGL_EXPORT CGLContextObj CGLRetainContext(CGLContextObj context);
CGL_EXPORT void CGLReleaseContext(CGLContextObj context);
CGL_EXPORT GLuint CGLGetContextRetainCount(CGLContextObj context);

CGL_EXPORT CGLError CGLDestroyContext(CGLContextObj context);

CGL_EXPORT CGLError CGLLockContext(CGLContextObj context);
CGL_EXPORT CGLError CGLUnlockContext(CGLContextObj context);

CGL_EXPORT CGLError CGLSetParameter(CGLContextObj context, CGLContextParameter parameter, const GLint *value);
CGL_EXPORT CGLError CGLGetParameter(CGLContextObj context, CGLContextParameter parameter, GLint *value);
CGL_EXPORT CGLError CGLFlushDrawable(CGLContextObj context);

CGL_EXPORT CGLError CGLChoosePixelFormat(const CGLPixelFormatAttribute *attributes, CGLPixelFormatObj *pixelFormatp, GLint *numberOfScreensp);
CGL_EXPORT CGLPixelFormatObj CGLRetainPixelFormat(CGLPixelFormatObj pixelFormat);
CGL_EXPORT void CGLReleasePixelFormat(CGLPixelFormatObj pixelFormat);
CGL_EXPORT CGLError CGLDestroyPixelFormat(CGLPixelFormatObj pixelFormat);
CGL_EXPORT GLuint CGLGetPixelFormatRetainCount(CGLPixelFormatObj pixelFormat);
CGL_EXPORT CGLError CGLDescribePixelFormat(CGLPixelFormatObj pixelFormat, GLint screenNumber, CGLPixelFormatAttribute attribute, GLint *valuep);

CGL_EXPORT CGLError CGLCreatePBuffer(GLsizei width, GLsizei height, GLenum target, GLenum internalFormat, GLint maxDetail, CGLPBufferObj *pbuffer);
CGL_EXPORT CGLError CGLDescribePBuffer(CGLPBufferObj pbuffer, GLsizei *width, GLsizei *height, GLenum *target, GLenum *internalFormat, GLint *mipmap);
CGL_EXPORT CGLPBufferObj CGLRetainPBuffer(CGLPBufferObj pbuffer);
CGL_EXPORT void CGLReleasePBuffer(CGLPBufferObj pbuffer);
CGL_EXPORT GLuint CGLGetPBufferRetainCount(CGLPBufferObj pbuffer);
CGL_EXPORT CGLError CGLDestroyPBuffer(CGLPBufferObj pbuffer);
CGL_EXPORT CGLError CGLGetPBuffer(CGLContextObj context, CGLPBufferObj *pbuffer, GLenum *face, GLint *level, GLint *screen);
CGL_EXPORT CGLError CGLSetPBuffer(CGLContextObj context, CGLPBufferObj pbuffer, GLenum face, GLint level, GLint screen);
CGL_EXPORT CGLError CGLTexImagePBuffer(CGLContextObj context, CGLPBufferObj pbuffer, GLenum sourceBuffer);
