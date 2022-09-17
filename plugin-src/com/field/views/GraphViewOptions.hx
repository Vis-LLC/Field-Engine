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
import com.field.navigator.DirectionInterface;

@:expose
@:nativeGen
/**
    Specifies options for creating GraphViews.
**/
class GraphViewOptions extends FieldViewOptionsAbstract<GraphViewOptions> {
    public inline function new() { super(); }

    /**
        Plots a function that defines X for a given Y.
    **/
    public function plotFunctionForX(f : Float->Float) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._plotFunctionForX(setOnceI, this, f);
    }

    /**
        Plots a function that defines Y for a given X.
    **/
    public function plotFunctionForY(f : Float->Float) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._plotFunctionForY(setOnceI, this, f);
    }

    /**
        Plots a function that defines X for a given Y.
    **/
    public function plotFunctionsForX(f : Array<Float->Float>) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._plotFunctionsForX(setOnceI, this, f);
    }

    /**
        Plots a function that defines Y for a given X.
    **/
    public function plotFunctionsForY(f : Array<Float->Float>) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._plotFunctionsForY(setOnceI, this, f);
    }

    /**
        Only plot values that have a positive Y.
    **/
    public function positiveOnlyY() : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._positiveOnlyY(setOnceI, this);
    }

    /**
        Only plot values that have a negative Y.
    **/
    public function negativeOnlyY() : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._negativeOnlyY(setOnceI, this);
    }

    /**
        Plot values for both negative and positive Y.
    **/
    public function positiveAndNegativeY() : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._positiveAndNegativeY(setOnceI, this);
    }

    /**
        Only plot values that have a positive X.
    **/
    public function positiveOnlyX() : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._positiveOnlyX(setOnceI, this);
    }

    /**
        Only plot values that have a negative X.
    **/
    public function negativeOnlyX() : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._negativeOnlyX(setOnceI, this);
    }

    /**
        Plot values for both negative and positive X.
    **/
    public function positiveAndNegativeX() : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._positiveAndNegativeX(setOnceI, this);
    }

    /**
        Plots data on a graph.
    **/    
    public function plotDataByColumnNameForY(r : com.sdtk.table.DataTableRowReader, x : String, y : String, ?group : String = null) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._plotDataByColumnNameForY(setOnceI, this, r, x, y, group);
    }

    /**
        Plots data on a graph.
    **/    
    public function plotDataByColumnNameForX(r : com.sdtk.table.DataTableRowReader, x : String, y : String, ?group : String = null) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._plotDataByColumnNameForX(setOnceI, this, r, x, y, group);
    }

    /**
        Plots data on a graph.
    **/    
    public function plotDataByColumnIndexForY(r : com.sdtk.table.DataTableRowReader, x : String, y : String, ?group : String = null) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._plotDataByColumnIndexForY(setOnceI, this, r, x, y, group);
    }

    /**
        Plots data on a graph.
    **/    
    public function plotDataByColumnIndexForX(r : com.sdtk.table.DataTableRowReader, x : String, y : String, ?group : String = null) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._plotDataByColumnIndexForX(setOnceI, this, r, x, y, group);
    }

    /**
        Set width to match the data
    **/
    public function matchWidth() : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._matchWidth(setOnceI, this);
    }

    /**
        Set height to match the data
    **/
    public function matchHeight() : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._matchHeight(setOnceI, this);
    }

    /**
        Set width of plot
    **/
    public function width(w : Float) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._width(setOnceI, this, w);
    }

    /**
        Set height of plot
    **/
    public function height(h : Float) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._height(setOnceI, this, h);
    }

    public function colors(colors : Array<String>) : GraphViewOptions {
        return cast com.sdtk.graphs.GrapherOptions._colors(setOnceI, this, colors);
    }

    /**
        Create a GraphView using the specified options.
    **/
    public function execute() : GraphView {
        return GraphView.create(this);
    }    

    private static function setOnceI(o : Dynamic, key : String, value : Any) : Dynamic {
        var o2 : GraphViewOptions = cast o;
        o2.setOnce(key, value);
        return o;
    }
}
#end