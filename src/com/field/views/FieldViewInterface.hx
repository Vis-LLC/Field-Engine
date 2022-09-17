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
import com.field.navigator.DirectionInterface;
import com.field.renderers.Element;
import com.field.renderers.Style;

// TODO - Put dInnerDiv.style.zIndex = 0; in style
// TODO - Put dInnerDiv2.style.zIndex = -1; in style
// TODO - Put dInnerDiv3.style.zIndex = -2; in style

@:expose
@:nativeGen
/**
    The functions used by all FieldViews.
**/
interface FieldViewInterface extends com.field.navigator.NavigatorInterface {
    /**

    **/
    function getOriginalStyle(e : Element) : Style;

    /**
        Get element that represents the View.
    **/
    function toElement() : Element;


    /**
        Get element that represents the Overlay.
    **/
    function getOverlay() : Element;

    /**
        Get the Width of the FieldView in tiles.
    **/
    function width() : Float;

    /**
        Get the Height of the FieldView in tiles.
    **/
    function height() : Float;

    /**
        Clear the FieldView and redo the layout.
    **/
    function fullRefresh() : Void;

    /**
        Clear the Overlay.
    **/
    function clearOverlay() : Void;

    /**
        Get the LocationView for the specified Location.
    **/
    function findViewForLocation(l : LocationInterface<Dynamic, Dynamic>) : LocationView;

    /**
        The origin of the FieldView in tiles for the X axis.
    **/
    function originX(?x : Float = null) : Float;

    /**
        The origin of the FieldView in tiles for the Y axis.
    **/
    function originY(?y : Float = null) : Float;

    /**
        Set the FieldView to take up the whole screen.
    **/
    function fullScreen() : Void;

    /**
        Recalculate the styles for the FieldView.
    **/
    function updateStyles() : Void;

    /**
        Scroll the FieldView by the specified amounts.
    **/
    function scrollView(x : Float, y : Float) : Void;

    /**
        Zoom the FieldView by the specified amount.
    **/
    function zoom(t : Float) : Void;

    /**
        Rotate the FieldView by the specified amount.
    **/
    function rotate(d : Float) : Void;

    /**
        Show the FieldView.
    **/
    function show() : Void;

    /**
        Hide the FieldView.
    **/
    function hide() : Void;

    /**
        Update the layout of the FieldView to incorporate the latest changes.
    **/
    function update() : Void;

    /**
        Get the options for the standard FieldView listeners.
    **/
    function startDefaultListenersOptions() : DefaultListenersOptions;

    /**
        Start the standard FieldView listeners using the specified options.
    **/
    function startDefaultListeners(options : DefaultListenersOptions) : Void;
}
#end