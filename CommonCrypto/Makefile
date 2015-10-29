include ../../Foundation/System/Makefile.template

CC				= emcc
STYLE_CFLAGS	= -DDEBUG
CFLAGS			= -v -c -x objective-c -std=gnu99 -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -DOPENSSL_USE_DEPRECATED -I..
STYLE_CPPFLAGS	= -DDEBUG
CPPFLAGS		= -v -c -x objective-c++ -std=c++11 -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -DOPENSSL_USE_DEPRECATED -I..

BUILD_DIR		= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(filter-out dllmain.m, $(wildcard *.m))
PUBLIC_HEADERS	= $(wildcard *.h)
PRIVATE_HEADERS	=
RESOURCE_DIR	=

$(eval $(call framework_build, CommonCrypto, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
