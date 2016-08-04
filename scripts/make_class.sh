#!/bin/bash -ex

if [ "$1" = "" ]; then
    echo "usage: ../scripts/make_class.sh class_name"
    exit
fi

name=$1
pwd=`pwd`
framework=`basename $pwd`
fullpath=include/$framework/$name.h
if [ -d $fullpath ]; then
    echo "$fullpath exists!"
    exit
fi

cat <<EOF > $fullpath 
#import <Foundation/Foundation.h>

@interface $name : NSObject
@end
EOF

srcpath=src/$name.m
if [ -d $srcpath ]; then
    echo "$srcpath exists!"
    exit
fi

cat <<EOF > $srcpath
#import <$framework/$framework.h>

@implementation $name
@end
EOF

if ! grep $name.h include/$framework/$framework.h; then
    echo "#import <$framework/$name.h>" >> include/$framework/$framework.h
fi
