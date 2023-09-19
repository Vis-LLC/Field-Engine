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
import com.field.renderers.Element;
import com.field.manager.Pool;

@:expose
@:native
/**
    Settings that are common to both LocationView and SpriteView, but can be modified separately.
**/
class CommonSettings<T> {
    /**
        Don't hide the LocationView when adding it to the FieldView.
    **/
    public var noHideShow : Bool;

    /**
        Have the tile layer in LocationViews/SpriteViews.
    **/
    public var tileElement : Bool;

    /**
        Have the effect layer in LocationViews/SpriteViews.
    **/    
    public var effectElement : Bool;

    /**
        Have the select layer in LocationViews/SpriteViews.
    **/    
    public var selectElement : Bool;

    /**
        Additional components/divs to customize the appearance so it fits in the FieldView.
    **/
    public var shellElements : Int;

    /**
        Fire event when mouse is over LocationView/SpriteView.
    **/
    public var setOnMouseOver : Bool;

    // TODO - Use these

    /**
        The base style for the LocationView/SpriteView.
    **/
    public var style : Any;

    /**
        The base style for the tile layer.
    **/
    public var tileStyle : Any;

    /**
        The base style for the effect layer.
    **/
    public var effectStyle : Any;

    /**
        The base style for the select layer.
    **/
    public var selectStyle : Any;

    /**
        Set the area xy values in the style of the LocationView/SpriteView.
    **/
    public var noAreaXY : Bool;

    /**
         Move element focus when moving.
    **/
    public var triggerFocusOnElement : Null<Bool>;

    /**
        The memory manager to use to manage the LocationView/SpriteView instances.
    **/
    public var manager : com.field.manager.Manager<T, Dynamic, Dynamic>;

    /**
        The memory allocator to use to manage the LocationView/SpriteView instances.
    **/
    public var allocator : com.field.manager.Allocator<T>;

    /**
        The object pool to use to keep track of the discarded LocationView/SpriteView instances.
    **/
    public var discarded : Pool<T>;

    /**
        The object pool to use to keep track of the LocationView/SpriteView instances.
    **/
    public var views : Pool<T>;   
    
    public var tabIndex : Bool;
    public var calculatedAttributes : Bool;
    public var click : Bool;
    public var willChange : Bool;
    public var rawText : Bool;
    public var draggable : Bool;
    public var resizable : Bool;

    public inline function new() { }
}
#end