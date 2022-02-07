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

import com.field.NativeObjectMap;
import com.field.renderers.Element;

@:expose
@:nativeGen
/**
    A GraphView is a FieldView that is meant to display a graphing function.
**/
class GraphView extends FieldViewAbstract {
    private var _plotFunction : Float->Float;
    private var _plotType : Int;
    private var _locationsY : NativeVector<Float>;
    private var _locationsX : NativeVector<Float>;
    private var _coordinates : NativeVector<String>;
    private var _changed : Bool;
    private var _centerOfX : Int;
    private var _centerOfY : Int;
    private var _shiftX : Int;
    private var _shiftY : Int;

    private function new(options : GraphViewOptions) {
        var fo : NativeStringMap<Any> = options.toMap();
        var width : Int = cast fo.get("tileWidth");
        var height : Int = cast fo.get("tileHeight");
        _plotFunction = cast fo.get("plotFunction");
        _plotType = cast fo.get("plotType");
        _centerOfX = cast fo.get("centerOfX");
        _centerOfY = cast fo.get("centerOfY");
        if (_centerOfX == null) {
            _centerOfX = 0;
        }
        if (_centerOfY == null) {
            _centerOfY = 0;
        }
        _shiftX = cast fo.get("shiftX");
        _shiftY = cast fo.get("shiftY");
        if (_shiftX == null) {
            switch (_centerOfX) {
                case 1:
                    _shiftX = 0;
                case 0:
                    _shiftX = cast (width / 2);
                case -1:
                    _shiftX = width;
            }
        }
        if (_shiftY == null) {
            switch (_centerOfY) {
                case 1:
                    _shiftY = 0;
                case 0:
                    _shiftY = cast (height / 2);
                case -1:
                    _shiftY = height;
            }
        }        
        super(fo);
    }

    public static function create(options : GraphViewOptions) : GraphView {
        return new GraphView(options);
    }

    public static function options() : GraphViewOptions {
        return new GraphViewOptions();
    }

    public override function update() : Void {
        super.update();
        updateLocations();
        updatePlot();
    }

    public override function fullRefresh() : Void {
        super.fullRefresh();
        updateLocations();
        updatePlot();
    }

    private function updatePlot() : Void {
        var start : Float = -1;
        var end : Float = -1;
        var increment : Float = -1;

        switch (_plotType) {
            case 1:
                start = originY();
                end = start + _tileHeight;
                increment = 1/_rectHeight;
            case 2:
                start = originX();
                end = start + _tileWidth;
                increment = 1/_rectWidth;
        }

        var size : Int = Math.round((end - start)/increment);

        now(function () {
            clearLines(_innerElement);

            var j : Int = 1;
            while (j < size) {
                var line : Element = drawLine(_innerElement, Math.round(_locationsX.get(j - 1) * _rectWidth), Math.round(_locationsY.get(j - 1) * _rectHeight), Math.round(_locationsX.get(j) * _rectWidth), Math.round(_locationsY.get(j) * _rectHeight));
                setCaption(line, _coordinates.get(j - 1));
                j++;
            }
        });
    }

    private function updateLocations() : Void {
        var start : Float = -1;
        var end : Float = -1;
        var increment : Float = -1;
        var size : Int;

        switch (_plotType) {
            case 1:
                start = originY() - _shiftY;
                end = start + _tileHeight;
                increment = 1/_rectHeight;
            case 2:
                start = originX() - _shiftX;
                end = start + _tileWidth;
                increment = 1/_rectWidth;
        }

        size = Math.round((end - start)/increment);        

        var locationsY : NativeVector<Float> = new NativeVector<Float>(size);
        var locationsX : NativeVector<Float> = new NativeVector<Float>(size);
        var coordinates : NativeVector<String> = new NativeVector<String>(size);
        var locationUse : NativeVector<Float> = null;
        var locationResult : NativeVector<Float> = null;
        var locationCompare : NativeVector<Float> = null;
        var shiftUse : Float = -1;
        var shiftResult : Float = -1;
        var getCoordinates : Null<Float->Float->String> = null;

        switch (_plotType) {
            case 1:
                locationUse = locationsY;
                locationResult = locationsX;
                locationCompare = _locationsX;
                shiftUse = _shiftY;
                shiftResult = _shiftX;
                getCoordinates = function (y : Float, x : Float) {
                    return "" + x + "," + y;
                }
            case 2:
                locationUse = locationsX;
                locationResult = locationsY;
                locationCompare = _locationsY;
                shiftUse = _shiftX;
                shiftResult = _shiftY;                
                getCoordinates = function (x : Float, y : Float) {
                    return "" + x + "," + y;
                }                
        }        

        var changed : Bool = (_locationsX == null);
        var locations : NativeStringMap<Float> = new NativeStringMap<Float>();

        {
            var i : Float = start;
            var j : Int = 0;
            while (j < size) {
                var result : Float = _plotFunction(i);
                locationUse.set(j, i + shiftUse);
                locationResult.set(j, result + shiftResult);
                coordinates.set(j, getCoordinates(i, result));
                if (!changed && locationCompare.get(j) != locationResult.get(j)) {
                    changed = true;
                }
                i += increment;
                j++;
            }
        }

        if (changed) {
            _locationsX = locationsX;
            _locationsY = locationsY;
            _coordinates = coordinates;
            _changed = true;
        }
    }
}