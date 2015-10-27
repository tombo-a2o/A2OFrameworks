#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

extern GLuint loadShader(const char *source, GLenum type);
extern GLuint linkProgram(GLuint vertexShader, GLuint fragmentShader);
extern GLuint loadAndLinkShader(const char *vertexShaderSource, const char *fragmentShaderSource);
