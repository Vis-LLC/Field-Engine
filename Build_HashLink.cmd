#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL
haxe -hl out\fe-lib.hl -cp src com.field
popd