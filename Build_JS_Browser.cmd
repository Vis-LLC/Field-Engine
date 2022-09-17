#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL

ECHO Building Library
DEL out\fe-browser.js
haxe -js out\fe-browser.js -cp src com.field -D JS_BROWSER -D %* $*
haxe -js out\fe-browser-2.js -cp src -cp lib-src -cp plugin-src com.field -D JS_BROWSER --macro "exclude('com.sdtk', true)" --macro "exclude('com.field', false)" --macro "exclude('com.field.manager', false)" --macro "exclude('com.field.navigator', false)" --macro "exclude('com.field.renderers', false)" --macro "exclude('com.field.search', false)" --macro "exclude('com.field.tests', false)" --macro "exclude('com.field.util', false)" --macro "exclude('com.field.views.AbstractView', false)" --macro "exclude('com.field.views.CommonSettings', false)" --macro "exclude('com.field.views.DefaultListenersOptions', false)" --macro "exclude('com.field.views.FieldView', false)" --macro "exclude('com.field.views.FieldViewAbstract', false)" --macro "exclude('com.field.views.FieldViewFullInterface', false)" --macro "exclude('com.field.views.FieldViewInterface', false)" --macro "exclude('com.field.views.FieldViewLayered', false)" --macro "exclude('com.field.views.FieldViewOptions', false)" --macro "exclude('com.field.views.FieldViewOptionsAbstract', false)" --macro "exclude('com.field.views.GamepadButtonInfo', false)" --macro "exclude('com.field.views.GamepadInfo', false)" --macro "exclude('com.field.views.InputSettings', false)" --macro "exclude('com.field.views.LocationView', false)" --macro "exclude('com.field.views.ScreensView', false)" --macro "exclude('com.field.views.ScreensViewOptions', false)" --macro "exclude('com.field.views.SpriteView', false)" --macro "exclude('com.field.views.VerticalMenuView', false)" --macro "exclude('com.field.views.VerticalMenuViewOptions', false)" --macro "exclude('com.field.views.VirtualGamepadView', false)" --macro "exclude('com.field.workers', false)" --macro "include('com.field.sdtk', false)" -D %* $*
MOVE out\fe-browser.js out\fe-browser.tmp
TYPE Append_To_Beginning.txt > out\fe-browser.js
TYPE src\base64.js >> out\fe-browser.js
TYPE out\fe-browser.tmp >> out\fe-browser.js
TYPE src\2start.js >> out\fe-browser.js
TYPE out\fe-browser-2.js >> out\fe-browser.js
TYPE src\2end.js >> out\fe-browser.js
DEL out\fe-browser.tmp
DEL out\fe-browser-2.js

popd