include ../../Foundation/System/Makefile.template

export PKG_CONFIG_LIBDIR=${EMSCRIPTEN}/system/lib/pkgconfig:${EMSCRIPTEN}/system/local/lib/pkgconfig

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -I./include -I./private_include `pkg-config pixman-1 --cflags` `pkg-config cairo --cflags`
CFLAGS = -x objective-c -std=gnu99

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(wildcard src/CG*.m src/A2O*.m)
PUBLIC_HEADERS	= $(wildcard include/CoreGraphics/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/CoreGraphics/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, CoreGraphics, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
