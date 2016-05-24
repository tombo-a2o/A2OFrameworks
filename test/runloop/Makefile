EM_OPTS=-O0 -v -s TOTAL_MEMORY=100000000 -s ASSERTIONS=1

CC=a2o

all:	loop.html

loop.html:	loop.m
	EMCC_DEBUG=1 EMCC_DEBUG_SAVE=1 $(CC) $(EM_OPTS) -s USE_PTHREADS=1 --emrun -s PTHREAD_POOL_SIZE=3 -o $@ $<

loop.ll:	loop.m
	clang -emit-llvm -S -o $@ -c $<

loop:	loop.m
	clang -framework Foundation -o $@ $<

run:
	emrun --kill_start --browser firefox_nightly --profile=emscripten_user loop.html

.PHONY:	run
