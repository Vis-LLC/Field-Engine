/*
    Copyright (C) 2020-2021 Vis LLC - All Rights Reserved

    This program is free software : you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https ://www.gnu.org/licenses/>.
*/

/*
    FieldEngine
    FieldEngine - Source code can be found on SourceForge.net
*/

package com.field.views;

#if !EXCLUDE_RENDERING
import com.field.NativeObjectMap;
import com.field.renderers.Element;

@:expose
@:nativeGen
/**
    A ScreensView is a FieldView that is meant to display a series of full screen information.
**/
class ScreensView extends FieldViewAbstract {
    private var _start : Int;
    private var _end : Int;
    private var _time : Null<Int>;
    private var _onStart : Void->Void;
    private var _onEach : Int->Void;
    private var _onEnd : Void->Void;
    private var _currentScreen : Int;
    private var _interval : Float;

    private function new(options : ScreensViewOptions) {
        var fo : NativeStringMap<Any> = options.toMap();
        var field : FieldInterface<Dynamic, Dynamic> = fo.get("field");
        var scroll : String = cast fo.get("scroll");

        if (field == null) {
            var screens : NativeVector<String> = cast fo.get("screens");
            var arr : NativeArray<NativeVector<String>> = new NativeArray<NativeVector<String>>();
            if (scroll == "horizontal") {
                var a : NativeArray<String> = new NativeArray<String>();
                a.push("");
                a = a.concat(screens.toArray());
                a.push("");
                arr.push(a.toVector());
            } else if (scroll == "vertical") {
                var a : NativeArray<String> = new NativeArray<String>();
                a.push("");
                arr.push(a.toVector());
                for (o in screens) {
                    a = new NativeArray<String>();
                    a.push(o);
                    arr.push(a.toVector());
                }
                a = new NativeArray<String>();
                a.push("");
                arr.push(a.toVector());
            }
            field = com.field.Convert.array2DToFieldNoIndexesOptions().value(arr.toVector()).execute();
            options.field(field);
            arr = null;
        }

        _start = cast fo.get("start");
        _end = cast fo.get("end");
        _time = cast fo.get("time");
        _onStart = cast fo.get("onStart");
        _onEach = cast fo.get("onEach");
        _onEnd = cast fo.get("onEnd");

        if (fo.get("tileHeight") == null) {
            options.tileHeight(1);
        }
        if (fo.get("tileWidth") == null) {
            options.tileWidth(1);
        }
        if (fo.get("tileBuffer") == null) {
            options.tileBuffer(2);
        }
        if (fo.get("locationEffectElement") == null) {
            options.locationEffectElement(false);
        }
        if (fo.get("locationSelectElement") == null) {
            options.locationSelectElement(false);
        }
        if (fo.get("calculatedAttributes") == null) {
            options.simpleView();
        }
        if (fo.get("style") == null) {
            options.style("screens");
        }
        super(options.toMap());
        if (_time != null) {
            // TODO - Reversible
            _interval = _time / (_end - _start);
            autoScroll(-(fo.get("scroll") == "horizontal" ? 1 : 0), -(fo.get("scroll") == "vertical" ? 1 : 0), cast _interval, false);
            updateStyles();
            _currentScreen = 0;
            _autoScrollEach = function () {
                if (_onStart != null && _currentScreen == _start) {
                    _onStart();                    
                }
                if (_onEach != null) {
                    _onEach(_currentScreen + _start);
                }
                if (_onEnd != null && _currentScreen == _end) {
                    _onEnd();
                }
                if (_currentScreen == _end || getParent(_element) == null) {
                    endAutoScroll();
                    _autoScrollEach = null;
                }
                _currentScreen++;
            };
        }
    }

    private override function getAdditionalFieldStyleSheet() : String {
        return "#" + _id + " ." + SpriteView.FIELD_SPRITE_STYLE + ", #" + _id + " ." + FieldViewAbstract.FIELD_VIEW_INNER_STYLE + " { transition: width " + _interval + "ms linear, height " + _interval + "ms linear, left " + _interval + "ms linear, top " + _interval + "ms linear, transform " + _interval + "ms linear; }";
    }

    public static function create(options : ScreensViewOptions) : ScreensView {
        return new ScreensView(options);
    }

    public static function options() : ScreensViewOptions {
        return new ScreensViewOptions();
    }
}
#end