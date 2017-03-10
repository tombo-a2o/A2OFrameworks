include ../../Foundation/System/Makefile.template

CC = emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fobjc-arc -fblocks -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -D__IPHONE_OS_VERSION_MAX_ALLOWED=70000 -D_BSD_SOURCE=1  -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DTARGET_OS_IOS=1 -I./TomboAFNetworking
CFLAGS = -x objective-c
STYLE_LFLAGS ?= -O0
LFLAGS =
STYLE_LFLAGS ?= -O0
LFLAGS =

BUILD_DIR ?= build/debug
INSTALL_DIR = $(EMSCRIPTEN)/system/frameworks

SOURCES = $(wildcard TomboAFNetworking/*.m)
PUBLIC_HEADERS = $(wildcard TomboAFNetworking/*.h)
PRIVATE_HEADERS =
RESOURCE_DIR = resource

$(warning $(SOURCES))

$(eval $(call framework_build, TomboAFNetworking, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
