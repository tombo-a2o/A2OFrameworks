include ../../Foundation/System/Makefile.template

CC				= emcc
STYLE_CFLAGS	= -DDEBUG
CFLAGS			= -v -c -std=gnu99 -pipe -Wmost -Wno-trigraphs -Wreturn-type -fobjc-arc -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=ios-8 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -I./include -I./private_include -include ./UIKit_Prefix.pch
STYLE_CPPFLAGS	= -DDEBUG
CPPFLAGS		= -v -c -std=c++11 -pipe -Wmost -Wno-trigraphs -Wreturn-type -fobjc-arc -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=ios-8 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -I./include -I./private_include -include ./UIKit_Prefix.pch

BUILD_DIR		= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

SOURCES			= $(wildcard src/*.m src/*.mm)
PUBLIC_HEADERS	= $(wildcard include/UIKit/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/UIKit/*.h)
RESOURCE_DIR	= resource

$(eval $(call framework_build, UIKit, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))
