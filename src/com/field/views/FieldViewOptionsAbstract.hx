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
    Specifies options for creating all types of FieldViews.
**/
class FieldViewOptionsAbstract<T> extends OptionsAbstract<T> {
    public inline function new() { super(); }

    public function onScroll(f : FieldViewAbstract -> Float -> Float -> Void) : T {
        return set("onScroll", f);
    }

    /**
        The style to assign to LocationViews.
    **/
    public function locationStyle(style : Any) : T {
        return set("locationStyle", style);
    }

    /**
        The style to assign to the tile layer.
    **/
    public function tileStyle(style : Any) : T {
        return set("tileStyle", style);
    }
    
    /**
        The style to assign to the effect layer.
    **/
    public function effectStyle(style : Any) : T {
        return set("effectStyle", style);
    }
    
    /**
        The style to assign to the select layer.
    **/
    public function selectStyle(style : Any) : T {
        return set("selectStyle", style);
    }

    /**
        The Field to display in the view.
    **/
    public function field(field : FieldInterface<Dynamic, Dynamic>) : T {
        return set("field", field);
    }

    /**
        Set the number of locations wide the view is.
    **/
    public function tileWidth(tileWidth : Int) : T {
        return set("tileWidth", tileWidth);
    }

    /**
        Set the number of locations high the view is.
    **/
    public function tileHeight(tileHeight : Int) : T {
        return set("tileHeight", tileHeight);
    }

    /**
        How much of a buffer, in locations, to have on all sides.
    **/ 
    public function tileBuffer(tileBuffer : Int) : T {
        return set("tileBuffer", tileBuffer);
    }

    /**
        The parent element for the view.
    **/
    public function parent(parent : Any) : T {
        return set("parent", parent);
    }

    /**
        Show the FieldView on creation or not.  Default is false.
    **/    
    public function show(show : Bool) : T {
        return set("show", show);
    }

    /**
        Id assigned to the FieldView.
    **/
    public function id(id : String) : T {
        return set("id", id);
    }

    /**
        Whether to have an overlay or not.  Default is false.
    **/
    public function addOverlay(?addOverlay : Bool = true) : T {
        return set("addOverlay", addOverlay);
    }

    /**
        Style to assign to the FieldView.
    **/
    public function style(style : Any) : T {
        return set("style", style);
    }

    /**
        Have the tile layer in LocationViews.  Default is true.
    **/
    public function locationTileElement(locationTileElement : Bool) : T {
        return set("locationTileElement", locationTileElement);
    }

    /**
        Have the effect layer in LocationViews.  Default is true.
    **/
    public function locationEffectElement(locationEffectElement : Bool) : T {
        return set("locationEffectElement", locationEffectElement);
    }

    /**
        Have the select layer in LocationViews.  Default is true.
    **/
    public function locationSelectElement(locationSelectElement : Bool) : T {
        return set("locationSelectElement", locationSelectElement);
    }

    /**
        Don't hide the LocationView when adding it to the FieldView.
    **/
    public function locationNoHideShow(locationNoHideShow : Bool) : T {
        return set("locationNoHideShow", locationNoHideShow);
    }

    /**
        Fire event when mouse is over LocationView.
    **/
    public function locationSetOnMouseOver(locationSetOnMouseOver : Bool) : T {
        return set("locationSetOnMouseOver", locationSetOnMouseOver);
    }    

    /**
        Add XY coordinates to style for LocationView.
    **/
    public function noAreaXY(noAreaXY : Bool) : T {
        return set("noAreaXY", noAreaXY);
    }

    /**
        Automatically update the FieldView during scrolling and zooming.
    **/
    public function autoUpdate(?autoUpdate : Bool = true) : T {
        return set("autoUpdate", autoUpdate);
    }

    /**
        Move element focus when moving.
    **/ 
    public function triggerFocusOnElement(triggerFocusOnElement : Bool) : T {
        return set("triggerFocusOnElement", triggerFocusOnElement);
    }

    /**
        Scroll FieldView when moving.
    **/ 
    public function scrollOnMove(scrollOnMove : Bool) : T {
        return set("scrollOnMove", scrollOnMove);
    }

    /**
        Do a select when moving.
    **/ 
    public function selectOnMove(selectOnMove : Bool) : T {
        return set("selectOnMove", selectOnMove);
    }

    /**
        Do a select when pressing a key.
    **/ 
    public function selectOnPress(selectOnPress : Bool) : T {
        return set("selectOnPress", selectOnPress);
    }

    /**
        Display Virtual Gamepad on touch use.
    **/    
    public function gamepadOnTouch(gamepadOnTouch : Bool) : T {
        return set("gamepadOnTouch", gamepadOnTouch);
    }

    /**
        Display Virtual Gamepad on mouse use.
    **/
    public function gamepadOnMouse(gamepadOnMouse : Bool) : T {
        return set("gamepadOnMouse", gamepadOnMouse);
    }

    /**
        Scroll FieldView on wheel turn
    **/
    public function scrollOnWheel(scrollOnWheel : Bool) : T {
        return set("scrollOnWheel", scrollOnWheel);
    }

    /**
        Keep a pool of LocationViews and reuse allocated ones.
    **/
    public function reuseLocationViews(reuseLocationViews : Bool) : T {
        return set("reuseLocationViews", reuseLocationViews);
    }

    /**
        Keep a pool of Elements and reuse allocated ones.
    **/
    public function reuseElements(reuseElements : Bool) : T {
        return set("reuseElements", reuseElements);
    }

    /**
        Clear out all elements when hiding and restore when showing.
    **/    
    public function clearOnHide(clearOnHide : Bool) : T {
        return set("clearOnHide", clearOnHide);
    }

    /**
        Call this method when moving a sprite.
    **/ 
    public function onMove(f : DirectionInterface->Int->FieldInterface<Dynamic, Dynamic>->FieldInterface<Dynamic, Dynamic>->FieldInterface<Dynamic, Dynamic>->Void) : T {
        return setOnce("onMove", f);
    }

    /**
        Only allow movement into locations that are "valid"
    **/
    public function movementForValidOnly() : T {
        return setOnce("canMove", FieldViewAbstract.movementForValidOnly);
    }

    /**
        Function to call when wrapping up update.
    **/
    public function onEndOfUpdate(f : Void->Void) : T {
        return set("onEndOfUpdate", f);
    }

    /**
        Turns off features like "neighbor", "tabIndex", and "click"
    **/
    public function simpleView() : T {
        set("calculatedAttributes", false);
        return set("tabIndex", false);
    }

    public function noClick() : T {
        return set("click", false);
    }

    /**
        Turns off features that allow for quick changing of elements.
    **/
    public function primarilyStatic() : T{
        return set("willChange", false);
    }

    public function shiftXLimit(limit : Int) : T {
        return set("shiftXLimit", limit);
    }

    public function shiftYLimit(limit : Int) : T {
        return set("shiftYLimit", limit);
    }    

    public function noExtraFrame(noExtraFrame : Bool) : T {
        return set("noExtraFrame", noExtraFrame);
    }

    public function noBackground(noBackground : Bool) : T {
        return set("noBackground", noBackground);
    }    

    public function fixedGrid(fixedGrid : Bool) : T {
        return set("fixedGrid", fixedGrid);
    }
}
#end