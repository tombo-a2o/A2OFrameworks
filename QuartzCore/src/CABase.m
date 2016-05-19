#import <QuartzCore/CABase.h>
#import <emscripten.h>

CFTimeInterval CACurrentMediaTime(void) {
   return emscripten_get_now()/1000000;
}
