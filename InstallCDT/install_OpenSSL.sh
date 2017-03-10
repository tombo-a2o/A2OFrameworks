#!/bin/sh
installResources=`pwd`/Resources
scriptResources=$installResources/scripts

productFolder=/Developer/Cocotron/1.0
downloadFolder=$productFolder/Downloads

SSLVERSION=0.9.8h-1

PREFIX=`pwd`/../system/i386-mingw32msvc/openssl-$SSLVERSION

INCLUDE=$PREFIX/include
BIN=$PREFIX/bin
LIB=$PREFIX/lib

$scriptResources/downloadFilesIfNeeded.sh $downloadFolder "http://downloads.sourceforge.net/gnuwin32/openssl-"$SSLVERSION"-lib.zip http://downloads.sourceforge.net/gnuwin32/openssl-"$SSLVERSION"-bin.zip"

TMPDIR=/tmp/install_OpenSSL$$
mkdir $TMPDIR
cd $TMPDIR
unzip $downloadFolder/openssl-"$SSLVERSION"-bin.zip
unzip $downloadFolder/openssl-"$SSLVERSION"-lib.zip

mkdir -p $PREFIX/bin
cp bin/libeay32.dll $PREFIX/bin
cp bin/libssl32.dll $PREFIX/bin

mkdir -p $PREFIX/lib
cp lib/libcrypto.a $PREFIX/lib
cp lib/libssl.a $PREFIX/lib

mkdir -p $PREFIX/include
cp -r include/openssl $PREFIX/include

