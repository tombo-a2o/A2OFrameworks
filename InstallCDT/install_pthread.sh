#!/bin/sh
installResources=`pwd`/Resources
scriptResources=$installResources/scripts

productFolder=/Developer/Cocotron/1.0
downloadFolder=$productFolder/Downloads/pthread


PREFIX=`pwd`/../system/i386-mingw32msvc
INCLUDE=$PREFIX/include
BIN=$PREFIX/bin
LIB=$PREFIX/lib

mkdir -p $downloadFolder

$scriptResources/downloadFilesIfNeeded.sh $downloadFolder "ftp://sourceware.org/pub/pthreads-win32/dll-latest/dll/x86/pthreadGC2.dll ftp://sourceware.org/pub/pthreads-win32/dll-latest/lib/x86/libpthreadGC2.a ftp://sourceware.org/pub/pthreads-win32/dll-latest/include/pthread.h ftp://sourceware.org/pub/pthreads-win32/dll-latest/include/sched.h ftp://sourceware.org/pub/pthreads-win32/dll-latest/include/semaphore.h"


mkdir -p $PREFIX/bin
cp $downloadFolder/pthreadGC2.dll  $PREFIX/bin

mkdir -p $PREFIX/lib
cp $downloadFolder/libpthreadGC2.a  $PREFIX/lib

mkdir -p $PREFIX/include
cp $downloadFolder/pthread.h  $PREFIX/include
cp $downloadFolder/sched.h  $PREFIX/include
cp $downloadFolder/semaphore.h  $PREFIX/include

