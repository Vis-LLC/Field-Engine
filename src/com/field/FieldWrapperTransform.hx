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

package com.field;

@:nativeGen
@:expose
/**
    A Decorator that changes a Field so that X and Y axis function differently.
**/
class FieldWrapperTransform<L, S> extends FieldWrapper<L, S> {
    private var _translateX : Int;
    private var _translateY : Int;
    private var _reverseX : Bool;
    private var _reverseY : Bool;
    private var _flipXY : Bool;

    /**
        Creates a FieldWrapperTransform based on the options.
    **/
    public static function create(options : FieldWrapperTransformOptions<Dynamic, Dynamic>) : FieldWrapperTransform<Dynamic, Dynamic>  {
        return new FieldWrapperTransform<Dynamic, Dynamic>(options);
    }

    /**
        Allows for the setting of options for the FieldWrapperTransform class.
    **/
    public static function options() : FieldWrapperTransformOptions<Dynamic, Dynamic> {
        return new FieldWrapperTransformOptions<Dynamic, Dynamic>();
    }

    private static function getField(options : FieldWrapperTransformOptions<Dynamic, Dynamic>) : FieldInterface<Dynamic, Dynamic> {
        var fo : NativeStringMap<Any> = options.toMap();
        return cast fo.get("field");
    }

    private function new(options : FieldWrapperTransformOptions<Dynamic, Dynamic>) {
        super(cast getField(options));
        var fo : NativeStringMap<Any> = options.toMap();
        options = null;
        _translateX = cast fo.get("translateX");
        _translateY = cast fo.get("translateY");
        _reverseX = cast fo.get("reverseX");
        _reverseY = cast fo.get("reverseY");
        _flipXY = cast fo.get("flipXY");
    }
/*
    public function getX() : Int {
        return _startX;
    }

    public function getY() : Int{
        return _startY;
    }
*/
    public override function get(x : Int, y : Int) : L {
        x += _translateX;
        y += _translateY;

        x = _reverseX ? -x : x;
        y = _reverseY ? -y : y;

        return _field.get(_flipXY ? y : x, _flipXY ? x : y);
    }

    public override function transformX(x : Float, y : Float) : Float {
        x += _translateX;
        y += _translateY;

        x = _reverseX ? -x : x;
        y = _reverseY ? -y : y;

        return _flipXY ? y : x;
    }

    public override function transformY(x : Float, y : Float) : Float {
        x += _translateX;
        y += _translateY;

        x = _reverseX ? -x : x;
        y = _reverseY ? -y : y;

        return _flipXY ? x : y;
    }
}