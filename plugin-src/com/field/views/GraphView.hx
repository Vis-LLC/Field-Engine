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
    A GraphView is a FieldView that is meant to display a graphing function.
**/
class GraphView extends FieldViewAbstract implements com.sdtk.graphs.Grapher.GrapherInterface {
    private var _colors : Array<String>;
    private var _plotFunctions : Array<Float->Float>;
    private var _plotType : Int;
    private var _locationsY : Array<Float>;
    private var _locationsX : Array<Float>;
    private var _coordinates : Array<String>;
    private var _groups : Array<String>;
    private var _changed : Bool;
    private var _centerOfX : Int;
    private var _centerOfY : Int;
    private var _shiftX : Int;
    private var _shiftY : Int;
    private var _convertedData : Array<Array<Dynamic>>;
    private var _lastX : Float;
    private var _lastI : Int;
    private var _dataByIndex : Bool;
    private var _fillGap : Bool;
    private var _reader : com.sdtk.table.DataTableReader;
    private var _dataX : Dynamic;
    private var _dataY : Dynamic;
    private var _dataGroup : Dynamic;
    private var _graphWidth : Int;
    private var _graphHeight : Int;

    private function new(options : GraphViewOptions) {
        var fo : NativeStringMap<Any> = options.toMap();
        var width : Int = cast fo.get("tileWidth");
        var height : Int = cast fo.get("tileHeight");
        var plotFunction : Float->Float = cast fo.get("plotFunction");
        _colors = cast fo.get("colors");
        _plotFunctions = cast fo.get("plotFunctions");
        if (_plotFunctions == null) {
            _plotFunctions = new Array<Float->Float>();
            _plotFunctions.resize(1);
            _plotFunctions[0] = plotFunction;
        }
        _plotType = cast fo.get("plotType");
        _centerOfX = cast fo.get("centerOfX");
        _centerOfY = cast fo.get("centerOfY");
        _graphWidth = cast fo.get("width");
        _graphHeight = cast fo.get("height");
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
        _reader = cast fo.get("reader");
        _dataX = cast fo.get("dataX");
        _dataY = cast fo.get("dataY");
        _dataGroup = cast fo.get("dataGroup");
        _dataByIndex = cast fo.get("dataByIndex");
        _fillGap = false;
        if (_plotFunctions[0] == null && _reader != null) {
            _plotFunctions[0] = plotForData;
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
        var renderer : com.field.renderers.RendererInterface = this.renderer();
        var exporter : GraphViewExporterExporter = new GraphViewExporterExporter(_innerElement, renderer);
        var v : NativeVector<Element> = renderer.getChildrenAsVector(_innerElement);
        var sText : com.field.renderers.Style = renderer.getStyleFor("graph-text");
        var sLine : com.field.renderers.Style = renderer.getStyleFor("line-segment");
        for (e in v) {
            var s : com.field.renderers.Style = renderer.getStyle(e);
            if (renderer.hasStyle(s, sText) || renderer.hasStyle(s, sLine)) {
                // TODO
                #if js
                    js.Syntax.code("{0}.parentNode.removeChild({0})", e);
                #end
            }
        }
        com.sdtk.graphs.Grapher._export(exporter,
            com.sdtk.graphs.Grapher._exportOptions().html().width(_graphWidth).height(_graphHeight),
            null, originX(), originY(), _rectWidth, _rectHeight, _tileWidth, _tileHeight, _shiftX, _shiftY, _plotType, _locationsX, _locationsY, _coordinates, _groups, _convertedData, _colors);
    }

    public function updateLocations() : Void {
        _convertedData = com.sdtk.graphs.Grapher._updateData(_convertedData, _reader, _plotType, _dataByIndex, _dataX, _dataY, _dataGroup);
        var results : com.sdtk.graphs.Grapher.GrapherUpdateLocationsResults = com.sdtk.graphs.Grapher._updateLocations(originX(), originY(), _rectWidth, _rectHeight, _tileWidth, _tileHeight, _shiftX, _shiftY, _plotFunctions, _plotType, _locationsX, _locationsY, _coordinates, _groups, _convertedData);
        _changed = results._changed;
        _locationsX = results._locationsX;
        _locationsY = results._locationsY;
        _coordinates = results._coordinates;
        _groups = results._groups;
    }

    public function getGroups() : Iterable<String> {
        return com.sdtk.graphs.Grapher._getGroups(_groups);
    }    

    public function exportOptions() : com.sdtk.graphs.Grapher.GraphExportTypeOptions {
        return new com.sdtk.graphs.Grapher.GraphExportTypeOptions(this);
    }

    public function export(options : com.sdtk.graphs.Grapher.GraphExportTypeOptionsFinish, ?callback : String->Void) {
        return com.sdtk.graphs.Grapher._export(null, options, callback, originX(), originY(), _rectWidth, _rectHeight, _tileWidth, _tileHeight, _shiftX, _shiftY, _plotType, _locationsX, _locationsY, _coordinates, _groups, _convertedData, _colors);
    }

    private function plotForData(x : Float) {
        return com.sdtk.graphs.Grapher._plotForData(x, _convertedData);
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

    public function circleY(x : Int, ox : Int, oy : Int, r : Float, ?y : Array<Int> = null, ?i : Int = 0) : Array<Int> {
        var y0 : Int = Math.floor(Math.sqrt(Math.pow(r, 2) - Math.pow(x - ox, 2)) + oy);
        if (y == null) {
            y = new Array<Int>();
            y.resize(2);
        }
        y[i] = y0;
        y[i + 1] = -y0;
        return y;
    }

    public function circleX(y : Int, ox : Int, oy : Int, r : Float, ?x : Array<Int> = null, ?i : Int = 0) : Array<Int> {
        var x0 : Int = Math.floor(Math.sqrt(Math.pow(r, 2) - Math.pow(y - oy, 2)) + ox);
        if (x == null) {
            x = new Array<Int>();
            x.resize(2);
        }
        x[i] = x0;
        x[i + 1] = -x0;
        return x;
    }
}

@:nativeGen
class GraphViewExporterExporter implements com.sdtk.graphs.Grapher.GrapherExporter<Element> {
    private var _innerElement : Element;
    private var _renderer : com.field.renderers.RendererInterface;
    private var _element : Element;

    public function new(innerElement : Element, renderer : com.field.renderers.RendererInterface) {
        _innerElement = innerElement;
        _renderer = renderer;
    }

    public function getTarget() : Element {
        return _innerElement;
    }

    public function start(sb : Element, width : Int, height : Int, scaleX : Float, scaleY : Float) : Void {
    }

    public function end(sb : Element) : String {
        return null;
    }    

    public function drawLine(sb : Element, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Void {
        _element = _renderer.drawLine(_innerElement, x1, y1, x2, y2);
    }    

    public function drawRect(sb : Element, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Void {
        _element = _renderer.createElement();
        _renderer.setStyle(_element, cast "graph-box");
        _renderer.setStyleLeft(_element, cast x1);
        _renderer.setStyleBottom(_element, cast y1);
        _renderer.forceHeight(_element, "" + (y2 - y1) + "px");
        _renderer.forceWidth(_element, "" + (x2 - x1) + "px");
        _renderer.appendChild(_innerElement, _element);
    }

    public function drawCircle(sb : Element, x : Int, y : Int, radius : Float) : Void {
        _element = _renderer.createElement();
        _renderer.setStyle(_element, cast "graph-circle");
        _renderer.setStyleLeft(_element, cast x);
        _renderer.setStyleBottom(_element, cast y);
        _renderer.forceHeight(_element, "" + (radius * 2) + "px");
        _renderer.forceWidth(_element, "" + (radius * 2) + "px");
        _renderer.appendChild(_innerElement, _element);
    }

    public function setCaption(sb : Element, caption : String) : Void {
        _renderer.setCaption(_element, caption);
    }

    public function setColor(sb : Element, color : String) : Void {
        _renderer.setColor(_element, color);
    }

    public function drawText(sb : Element, x : Int, y : Int, p : Float, s : String) : Void {
        _element = _renderer.createElement();
        _renderer.setStyle(_element, cast "graph-text");
        _renderer.setStyleLeft(_element, cast x);
        _renderer.setStyleBottom(_element, cast y);
        _renderer.setText(_element, s);
        // TODO
        #if js
            js.Syntax.code("{0}.style.position = \"absolute\"", _element);
        #end
        _renderer.appendChild(_innerElement, _element);
    }
}
#end