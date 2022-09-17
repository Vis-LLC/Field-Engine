#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL
haxe -php out com.field -cp src -D EXCLUDE_RENDERING

pushd out
pushd lib

powershell Compress-Archive .\* ..\fe-php.zip

popd
popd

REM sh ./Build_Docs
REM cmd /c .\Build_Docs
popd