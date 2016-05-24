EM_OPTS=-O0 -v -s TOTAL_MEMORY=100000000 -s ASSERTIONS=0

CC=a2o

all:	str.js

str.js:	str.m
	EMCC_DEBUG=1 EMCC_DEBUG_SAVE=1 $(CC) $(EM_OPTS) -o $@ $<

str.ll:	str.m
	$(CC) -emit-llvm -S -o $@ $<

str:	str.m
	clang -framework Foundation -o $@ $<
