include ../../Foundation/System/Makefile.template

export PKG_CONFIG_LIBDIR=${EMSCRIPTEN}/system/lib/pkgconfig:${EMSCRIPTEN}/system/local/lib/pkgconfig

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DLIBPNG_PRESENT=1 -I./include -Werror=incompatible-pointer-types -s USE_LIBPNG=1 -s USE_ZLIB=1 `pkg-config freetype2 --cflags`
CFLAGS = -x objective-c -std=gnu99

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(wildcard src/*.m)
PUBLIC_HEADERS	= $(wildcard include/Onyx2D/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/Onyx2D/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, Onyx2D, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
