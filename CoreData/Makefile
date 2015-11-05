include ../../Foundation/System/Makefile.template

CC				= emcc
CFLAGS			= -v -c -x objective-c -std=gnu99 -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -I./include

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(wildcard src/*.m)
PUBLIC_HEADERS	= $(wildcard include/CoreData/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/CoreData/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, CoreData, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
