#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL

DEL out\fe-wsh.js
haxe -js out\fe-wsh.js -cp src com.field -D JS_WSH -D %* $*
MOVE out\fe-wsh.js out\fe-wsh.tmp
TYPE Append_To_Beginning.txt > out\fe-wsh.js
TYPE out\fe-wsh.tmp >> out\fe-wsh.js
DEL out\fe-wsh.tmp

popd