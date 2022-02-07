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
        setOnce("plotFunction", f);
        return setOnce("plotType", 1);
    }

    /**
        Plots a function that defines Y for a given X.
    **/
    public function plotFunctionForY(f : Float->Float) : GraphViewOptions {
        setOnce("plotFunction", f);
        return setOnce("plotType", 2);
    }

    /**
        Only plot values that have a positive Y.
    **/
    public function positiveOnlyY() : GraphViewOptions {
        return setOnce("centerOfY", 1);
    }

    /**
        Only plot values that have a negative Y.
    **/
    public function negativeOnlyY() : GraphViewOptions {
        return setOnce("centerOfY", -1);
    }

    /**
        Plot values for both negative and positive Y.
    **/
    public function positiveAndNegativeY() : GraphViewOptions {
        return setOnce("centerOfY", 0);
    }

    /**
        Only plot values that have a positive X.
    **/
    public function positiveOnlyX() : GraphViewOptions {
        return setOnce("centerOfX", 1);
    }

    /**
        Only plot values that have a negative X.
    **/
    public function negativeOnlyX() : GraphViewOptions {
        return setOnce("centerOfX", -1);
    }

    /**
        Plot values for both negative and positive X.
    **/
    public function positiveAndNegativeX() : GraphViewOptions {
        return setOnce("centerOfX", 0);
    }

    /**
        Create a GraphView using the specified options.
    **/
    public function execute() : GraphView {
        return GraphView.create(this);
    }    
}