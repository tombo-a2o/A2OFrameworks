#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#if defined(DEBUG)
#define GL_ASSERT() { GLenum err = glGetError(); if(err != GL_NO_ERROR) { fprintf(stderr, "%s(%d) %x\n", __FILE__, __LINE__, err); assert(0);}}
#else
#define GL_ASSERT()
#endif

extern GLuint loadShader(const char *source, GLenum type);
extern GLuint linkProgram(GLuint vertexShader, GLuint fragmentShader);
extern GLuint loadAndLinkShader(const char *vertexShaderSource, const char *fragmentShaderSource);
