#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL
haxe -cs out -cp src com.field -D fast_cast
move out\bin\out.dll out\fe.dll > NUL 2> NUL

popd