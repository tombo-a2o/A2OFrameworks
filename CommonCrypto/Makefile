include ../../Foundation/System/Makefile.template

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DOPENSSL_USE_DEPRECATED -I..
CFLAGS = -x objective-c -std=gnu99
CXXFLAGS =-x objective-c++ -std=c++11

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(wildcard src/*.m)
PUBLIC_HEADERS	= $(wildcard include/CommonCrypto/*.h)
PRIVATE_HEADERS	=
RESOURCE_DIR	= resource

$(eval $(call framework_build, CommonCrypto, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
