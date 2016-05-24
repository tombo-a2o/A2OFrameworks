SOURCES= Dummy.c
OBJECTS = $(patsubst %.c,%.o,$(SOURCES))
HFILES = $(wildcard include/**/*.h)


OBJBASE_ROOT = build
OBJBASE = $(OBJBASE_ROOT)/$(STYLE)
DSTBASE = $(EMSCRIPTEN)/system/frameworks

STYLE=normal
STYLE_CFLAGS=-O2
STYLE_LFLAGS ?= -O0
LFLAGS =
STYLE_LFLAGS=
ARCHFLAGS=

CC = emcc

MAX_MACOSX_VERSION=MAC_OS_X_VERSION_10_9
CFLAGS=-v -c -x objective-c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=$(MAX_MACOSX_VERSION) -DCF_BUILDING_CF=1 -I./include -I./ -I../CoreFoundation/src -I../Foundation/src -I../CFNetwork/include -include ../CoreFoundation/src/CoreFoundation_Prefix.h
STYLE_LFLAGS ?= -O0
LFLAGS =

.PHONY: all install clean

all: $(OBJBASE)/CoreText_$(STYLE)

clean:
	-/bin/rm -rf $(OBJBASE)

$(OBJBASE)/CoreText:
	/bin/mkdir -p $(OBJBASE)/CoreText

$(OBJBASE)/%.o: src/%.c $(HFILES) $(OBJBASE)/CoreText
	$(CC) $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@
STYLE_LFLAGS ?= -O0
LFLAGS =

%.ll: %.c $(HFILES)
	$(CC) -emit-llvm -S $(STYLE_CFLAGS) $(ARCHFLAGS) $(CFLAGS) $< -o $@
STYLE_LFLAGS ?= -O0
LFLAGS =

$(OBJBASE)/CoreText_$(STYLE): $(addprefix $(OBJBASE)/,$(OBJECTS))
	llvm-link -o $(OBJBASE)/CoreText_$(STYLE).bc $^
	rm -f $(OBJBASE)/CoreText_$(STYLE)
	llvm-ar rcs $(OBJBASE)/CoreText_$(STYLE) $(OBJBASE)/CoreText_$(STYLE).bc

install: $(OBJBASE)/CoreText_$(STYLE)
	/bin/rm -rf $(DSTBASE)/CoreText.framework
	/bin/mkdir -p $(DSTBASE)/CoreText.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreText.framework/Versions/A/Headers
	/bin/mkdir -p $(DSTBASE)/CoreText.framework/Versions/A/PrivateHeaders
	/bin/ln -sf A $(DSTBASE)/CoreText.framework/Versions/Current
	/bin/ln -sf Versions/Current/Resources $(DSTBASE)/CoreText.framework/Resources
	/bin/ln -sf Versions/Current/Headers $(DSTBASE)/CoreText.framework/Headers
	/bin/ln -sf Versions/Current/PrivateHeaders $(DSTBASE)/CoreText.framework/PrivateHeaders
	/bin/ln -sf Versions/Current/CoreText $(DSTBASE)/CoreText.framework/CoreText
	#/bin/cp Info.plist $(DSTBASE)/CoreText.framework/Versions/A/Resources
	/bin/mkdir -p $(DSTBASE)/CoreText.framework/Versions/A/Resources/en.lproj
	/bin/cp include/CoreText/* $(DSTBASE)/CoreText.framework/Versions/A/Headers
	/bin/cp $(OBJBASE)/CoreText_$(STYLE) $(DSTBASE)/CoreText.framework/Versions/A/CoreText
	@echo "Installing done.  The framework is in $(DSTBASE)"

