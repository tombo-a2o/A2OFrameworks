include ../../Foundation/System/Makefile.template

CC				= emcc
#CFLAGS			= -v -c -x objective-c -std=gnu99 -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -I./include -Werror=objc-method-access -Werror=objc-multiple-method-names
STYLE_CFLAGS	= -DDEBUG
CFLAGS			= -v -c -x objective-c -std=gnu99 -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -I./include -I./private_include -include AppKit_Prefix.pch
STYLE_CPPFLAGS	= -DDEBUG
CPPFLAGS		= -v -c -x objective-c++ -std=c++11 -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -I./include -I./private_include -include AppKit_Prefix.pch

BUILD_DIR		= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(filter-out src/NSOpenGLDrawable_X11.m, $(wildcard src/NS*.m src/NS*.mm))
PUBLIC_HEADERS	= $(wildcard include/AppKit/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/AppKit/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, AppKit, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
