include ../../Foundation/System/Makefile.template

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -DDEPLOYMENT_TARGET_EMSCRIPTEN=1  -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -I./include -I./private_include
CFLAGS = -x objective-c -std=gnu99

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(wildcard src/*.m)
PUBLIC_HEADERS	= $(wildcard include/QuartzCore/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/QuartzCore/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, QuartzCore, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
