include ../../Foundation/System/Makefile.template

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fobjc-arc -fconstant-cfstrings -fno-exceptions -fblocks -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -I./include -I./private_include -include ./UIKit_Prefix.pch
CFLAGS = -std=gnu99
STYLE_LFLAGS ?= -O0
LFLAGS =
CXXFLAGS = -std=c++11

BUILD_DIR		?= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(wildcard src/*.m src/*.mm)
PUBLIC_HEADERS	= $(wildcard include/UIKit/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/UIKit/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, UIKit, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
