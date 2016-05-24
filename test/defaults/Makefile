EM_OPTS=-O0 -v -s TOTAL_MEMORY=100000000 -s ASSERTIONS=1

CC=a2o

all:	def.js

def.js:	def.m
	EMCC_DEBUG=1 EMCC_DEBUG_SAVE=1 $(CC) $(EM_OPTS) -s NATIVE_LIBDISPATCH=1 -o $@ $<

def.ll:	def.m
	clang -emit-llvm -S -o $@ -c $<

def:	def.m
	clang -framework Foundation -o $@ $<

run:
	node --stack_trace_limit=10000 def.js

.PHONY:	run
