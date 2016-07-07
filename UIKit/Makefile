include ../../Foundation/System/Makefile.template

CC				= emcc
STYLE_CPPFLAGS ?= -DDEBUG -O0 -g
CPPFLAGS = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fobjc-arc -fconstant-cfstrings -fno-exceptions -fblocks -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -I./include -I./private_include -include ./UIKit_Prefix.pch
CPPFLAGS_NOARC = -v -c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fno-objc-arc -fconstant-cfstrings -fno-exceptions -fblocks -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -I./include -I./private_include -include ./UIKit_Prefix.pch
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

# nib classes created for no-ARC (MRC) 

$(__OBJECTS_DIR__)/src/NSNib.o: src/NSNib.mm
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_NOARC) $(STYLE_CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(@:%.o=%.d) $< -o $@

$(__OBJECTS_DIR__)/src/NSNibUnarchiver.o: src/NSNibUnarchiver.mm
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_NOARC) $(STYLE_CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(@:%.o=%.d) $< -o $@

$(__OBJECTS_DIR__)/src/UIClassSwapper.o: src/UIClassSwapper.mm
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_NOARC) $(STYLE_CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(@:%.o=%.d) $< -o $@

$(__OBJECTS_DIR__)/src/UIImageNibPlaceholder.o: src/UIImageNibPlaceholder.mm
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_NOARC) $(STYLE_CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(@:%.o=%.d) $< -o $@

$(__OBJECTS_DIR__)/src/UIProxyObject.o: src/UIProxyObject.mm
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_NOARC) $(STYLE_CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(@:%.o=%.d) $< -o $@

$(__OBJECTS_DIR__)/src/UIProxyObjectPair.o: src/UIProxyObjectPair.mm
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_NOARC) $(STYLE_CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(@:%.o=%.d) $< -o $@

$(__OBJECTS_DIR__)/src/UIRuntimeConnection.o: src/UIRuntimeConnection.m
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_NOARC) $(STYLE_CPPFLAGS) $(CFLAGS) -MMD -MP -MF $(@:%.o=%.d) $< -o $@

$(__OBJECTS_DIR__)/src/UIRuntimeEventConnection.o: src/UIRuntimeEventConnection.mm
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_NOARC) $(STYLE_CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(@:%.o=%.d) $< -o $@

$(__OBJECTS_DIR__)/src/UIRuntimeOutletConnection.o: src/UIRuntimeOutletConnection.mm
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_NOARC) $(STYLE_CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(@:%.o=%.d) $< -o $@
