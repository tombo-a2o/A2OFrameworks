include ../../Foundation/System/Makefile.template

export PKG_CONFIG_LIBDIR=${EMSCRIPTEN}/system/lib/pkgconfig:${EMSCRIPTEN}/system/local/lib/pkgconfig

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -I./include `pkg-config freetype2 --cflags`
CFLAGS = -std=gnu99

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(wildcard src/*.m)
PUBLIC_HEADERS	= $(wildcard include/CoreText/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/CoreText/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, CoreText, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
