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

    public function exportOptions() : GraphExportTypeOptions {
        return new GraphExportTypeOptions(this);
    }

    public function export(options : GraphExportTypeOptionsFinish, ?callback : String->Void) {
        var fo : NativeStringMap<Any> = options.toMap();
        var exporter : GraphViewExporter = cast fo.get("type");
        var sb : StringBuf = new StringBuf();
        var width : Int = fo.get("width");
        var height : Int = fo.get("height");

        if (width == null) {
            width = Math.round(_tileWidth * _rectWidth);
        }

        if (height == null) {
            height = Math.round(_tileHeight * _rectHeight);
        }

        var start : Float = -1;
        var end : Float = -1;
        var increment : Float = -1;
        var scale : Float = -1;

        switch (_plotType) {
            case 1:
                start = originY();
                end = start + _tileHeight;
                increment = 1/_rectHeight;
                scale = height / (_tileHeight * _rectHeight);
            case 2:
                start = originX();
                end = start + _tileWidth;
                increment = 1/_rectWidth;
                scale = width / (_tileWidth * _rectWidth);                
        }

        var size : Int = Math.round((end - start)/increment);

        exporter.start(sb, width, height);
        var j : Int = 1;
        var multiX : Float = _rectWidth * scale;
        var multiY : Float = _rectHeight * scale;
        var prevX : Int = Math.round(_locationsX.get(j - 1) * multiX);
        var prevY : Int = Math.round(_locationsY.get(j - 1) * multiY);
        while (j < size) {
            var newX : Int = Math.round(_locationsX.get(j) * multiX);
            var newY : Int = Math.round(_locationsY.get(j) * multiY);
            exporter.drawLine(sb, prevX, prevY, newX, newY);
            prevX = newX;
            prevY = newY;
            j++;
        }
        exporter.end(sb);

        if (callback != null) {
            callback(sb.toString());
            return null;
        } else {
            return sb.toString();
        }
    }
}

@:nativeGen
class GraphViewDrawer {
    public function linearInterpolationY(x : Int, x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Int {
        return Math.round(y1 + (x - x1) * (y2 - y1) / (x2 - x1));
    }

    public function linearInterpolationX(y : Int, x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Int {
        return Math.round(x1 + (y - y1) * (x2 - x1) / (y2 - y1));
    }

    public function circleY(x : Int, ox : Int, oy : Int, r : Float, ?y : NativeVector<Int> = null, ?i : Int = 0) : NativeVector<Int> {
        var y0 : Int = Math.floor(Math.sqrt(Math.pow(r, 2) - Math.pow(x - ox, 2)) + oy);
        if (y == null) {
            y = new NativeVector<Int>(2);
        }
        y.set(i, y0);
        y.set(i + 1, -y0);
        return y;
    }

    public function circleX(y : Int, ox : Int, oy : Int, r : Float, ?x : NativeVector<Int> = null, ?i : Int = 0) : NativeVector<Int> {
        var x0 : Int = Math.floor(Math.sqrt(Math.pow(r, 2) - Math.pow(y - oy, 2)) + ox);
        if (x == null) {
            x = new NativeVector<Int>(2);
        }
        x.set(i, x0);
        x.set(i + 1, -x0);
        return x;
    }
}

@:nativeGen
class GraphExportTypeOptions {
    private var _values : NativeStringMap<Any> = new NativeStringMap<Any>();
    private var _view : GraphView;

    public function new(view : GraphView) {
        _view = view;
    }

    public function html() : GraphExportTypeOptionsFinish {
        return setType(GraphViewHTMLExporter.getInstance());
    }

    public function svg() : GraphExportTypeOptionsFinish {
        return setType(GraphViewSVGExporter.getInstance());
    }

    public function tex() : GraphExportTypeOptionsFinish {
        return setType(GraphViewTEXExporter.getInstance());
    }    

    private function setType(t : GraphViewExporter) : GraphExportTypeOptionsFinish {
        _values.set("type", t);
        return new GraphExportTypeOptionsFinish(_view, _values);
    }
}

@:nativeGen
class GraphExportTypeOptionsFinish {
    private var _values : NativeStringMap<Any>;
    private var _view : GraphView;

    public function new(view : GraphView, values : NativeStringMap<Any>) {
        _view = view;
        _values = values;
    }

    public function width(width : Int) : GraphExportTypeOptionsFinish {
        _values.set("width", width);
        return this;
    }

    public function height(height : Int) : GraphExportTypeOptionsFinish {
        _values.set("height", height);
        return this;
    }

    public function toMap() : NativeStringMap<Any> {
        return _values;
    }

    public function execute(?callback : String->Void) : String {
        return _view.export(this, callback);
    }
}

@:nativeGen
interface GraphViewExporter {
    function start(sb : StringBuf, width : Int, height : Int) : Void;
    function end(sb : StringBuf) : Void;
    function drawLine(sb : StringBuf, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Void;
}

@:nativeGen
class GraphViewHTMLExporter implements GraphViewExporter {
    private function new() { }

    private static var _instance : GraphViewExporter = new GraphViewHTMLExporter();

    public static function getInstance() : GraphViewExporter {
        return _instance;
    }

    public function start(sb : StringBuf, width : Int, height : Int) : Void {
        sb.add("<html><head><style>.line-segment { transform: rotate(calc(var(--angle) * 1deg)); transform-origin: left bottom; bottom: calc(var(--y1) * 1px); left: calc(var(--x1) * 1px); height: 1px; position: absolute; background-color: black; width: calc((var(--x2) - var(--x1)) * 1px); }</style></head><body><div style=\"width:");
        sb.add(width);
        sb.add("px; height: ");
        sb.add(height);
        sb.add("px;\">");
    }

    public function end(sb : StringBuf) : Void {
        sb.add("</div></body></html>");
    }    

    public function drawLine(sb : StringBuf, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Void {
        var angle : Float = Math.atan2(y2 - y1, x2 - x1) / Math.PI * 180;
        sb.add("<div ");
        sb.add("class=\"line-segment\" ");
        sb.add("style=\"--x1: ");
        sb.add(x1);
        sb.add("; --y1: ");
        sb.add(y1);
        sb.add("; --x2: ");
        sb.add(x2);
        sb.add("; --y2: ");
        sb.add(y2);
        sb.add("; --angle: ");
        sb.add(angle);
        sb.add("; \"> </div>\n");
    }    
}

@:nativeGen
class GraphViewSVGExporter implements GraphViewExporter {
    private function new() { }

    private static var _instance : GraphViewExporter = new GraphViewSVGExporter();
    
    public static function getInstance() : GraphViewExporter {
        return _instance;
    }

    public function start(sb : StringBuf, width : Int, height : Int) : Void {
        sb.add("<svg viewBox=\"0 0 ");
        sb.add(width);
        sb.add(" ");
        sb.add(height);
        sb.add("\" xmlns=\"http://www.w3.org/2000/svg\">");
    }

    public function end(sb : StringBuf) : Void {
        sb.add("</svg>");
    }

    public function drawLine(sb : StringBuf, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Void {
        sb.add("<line x1=\"");
        sb.add(x1);
        sb.add("\" y1=\"");
        sb.add(y1);
        sb.add("\" x2=\"");
        sb.add(x2);
        sb.add("\" y2=\"");
        sb.add(y2);
        sb.add("\" stroke=\"black\" />\n");
    }    
}

@:nativeGen
class GraphViewTEXExporter implements GraphViewExporter {
    private function new() { }

    private static var _instance : GraphViewExporter = new GraphViewTEXExporter();
    
    public static function getInstance() : GraphViewExporter {
        return _instance;
    }

    public function start(sb : StringBuf, width : Int, height : Int) : Void {
        sb.add("\\documentclass{article}\n");
        sb.add("\\begin{document}\n");
        sb.add("\\begin{picture}(");
        sb.add(width);
        sb.add(",");
        sb.add(height);
        sb.add(")\n");
    }

    public function end(sb : StringBuf) : Void {
        sb.add("\\end{picture}\n");
        sb.add("\\end{document}\n");
    }        

    // TODO - pstricks, tikz, xpicture

    public function drawLine(sb : StringBuf, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Void {
        sb.add("\\qbezier(");
        sb.add(x1);
        sb.add(",");
        sb.add(y1);
        sb.add(")(");
        sb.add((x1+x2)/2);
        sb.add(",");
        sb.add((y1+y2)/2);
        sb.add(")(");
        sb.add(x2);
        sb.add(",");
        sb.add(y2);
        sb.add(")\n");
    }
}