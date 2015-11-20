include ../../Foundation/System/Makefile.template

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -I./include -I./private_include -include AppKit_Prefix.pch
CFLAGS = -x objective-c -std=gnu99
CXXFLAGS =-x objective-c++ -std=c++11

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(filter-out src/NSOpenGLDrawable_X11.m, $(wildcard src/NS*.m src/NS*.mm src/A2O*.m))
PUBLIC_HEADERS	= $(wildcard include/AppKit/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/AppKit/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, AppKit, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
