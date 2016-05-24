include ../../Foundation/System/Makefile.template

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -D__IPHONE_OS_VERSION_MAX_ALLOWED=70000 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DTARGET_OS_IOS=1 -I./include -I./ -I./src/AFNetworking-3.0.4/SKAFNetworking
CFLAGS = -x objective-c
STYLE_LFLAGS ?= -O0
LFLAGS =

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(wildcard src/*.m) $(wildcard src/AFNetworking-3.0.4/SKAFNetworking/*.m)
PUBLIC_HEADERS	= $(wildcard include/**/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/**/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, StoreKit, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
