#!/bin/bash -ex

if [ "$1" = "" ]; then
    echo "usage: ./scripts/make_framework.sh framework_name"
    exit
fi

name=$1

if [ -d $name ]; then
    echo "$1 exists!"
    exit
fi
mkdir $name 
cd $name
sed -e s/Social/$1/g ../Social/Makefile > Makefile
echo build > .gitignore
mkdir -p include/$name
mkdir -p private_include/$name
touch include/$name/$name.h
mkdir src
echo "#import <$name/$name.h>" > src/Dummy.m
