#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL
haxe -lua out\fe-ti.lua com.field -cp src -D LUA_TI -D EXCLUDE_PARAMETERS -D EXCLUDE_FILES -D EXCLUDE_DATABASE -D EXCLUDE_PROCESS -D %* $*

SET outputfile=out\temp.lua
SET inputfile=out\fe-ti.lua
CALL :PROCESS_FILE

GOTO DO_EXIT

:PROCESS_FILE
ECHO %inputfile%
ECHO 1
SET search=__lua_lib_luautf8_Utf8.len
SET replace=utf8.len
CALL :DO_REPLACE
ECHO 2
SET search=__lua_lib_luautf8_Utf8.char
SET replace=utf8.char
CALL :DO_REPLACE
ECHO 3
SET search=__lua_lib_luautf8_Utf8.byte
SET replace=utf8.byte
CALL :DO_REPLACE
ECHO 4
SET search=__lua_lib_luautf8_Utf8.find
SET replace=string.find
CALL :DO_REPLACE
ECHO 5
SET search=__lua_lib_luautf8_Utf8.upper
SET replace=string.upper
CALL :DO_REPLACE
ECHO 6
SET search=__lua_lib_luautf8_Utf8.lower
SET replace=string.lower
CALL :DO_REPLACE
ECHO 7
SET search=__lua_lib_luautf8_Utf8.sub
SET replace=string.sub
CALL :DO_REPLACE
ECHO 8
SET search=local _hx_hidden = {__id__=true, hx__closures=true, super=true, prototype=true, __fields__=true, __ifields__=true, __class__=true, __properties__=true, __fields__=true, __name__=true}
SET replace=-
CALL :DO_REPLACE
ECHO 9
SET search=__lua_lib_luautf8_Utf8 = _G.require("lua-utf8")
SET replace=-
CALL :DO_REPLACE
EXIT /B


:DO_REPLACE
setlocal EnableDelayedExpansion

if "%replace%"=="-" (
    set search=%2

    (for /f "delims=" %%i in ('findstr /v /c:"%search%" %inputfile%') do (
        set "line=%%i"
        echo(!line!
    )) > %outputfile%
) else (
    (for /f "delims=" %%i in ('findstr /n "^" %inputfile%') do (
        set "line=%%i"
        set "line=!line:%search%=%replace%!"
        set "line=!line:*:=!"
        echo(!line!
    )) > %outputfile%
    )

xcopy /y %outputfile% %inputfile% >> NUL
EXIT /B

:DO_EXIT
DEL out\temp.lua 2> NUL
popd