#!/bin/sh
@ECHO OFF 2> NUL
pushd . 2> NUL
cd "%~dp0" 2> NUL
cd $(dirname "$0") 2> NUL
python Build.py -lua STANDARD
python3 Build.py -lua STANDARD
popd