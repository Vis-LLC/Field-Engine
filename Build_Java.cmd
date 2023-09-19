#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL
haxe -java out -cp src com.field -D fast_cast
move out\out.jar out\fe.jar > NUL 2> NUL
popd