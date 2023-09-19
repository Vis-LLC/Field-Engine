#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL
haxe -python out/fe.py -cp src com.field -D fast_cast
MOVE out\fe.py out\fe.tmp
TYPE Append_To_Beginning.py > out\fe.py
TYPE out\fe.tmp >> out\fe.py
DEL out\fe.tmp
popd