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
import com.field.Logger;
import com.field.renderers.Element;
import com.field.renderers.EventInfoInterface;
import com.field.renderers.RendererMode;
import com.field.renderers.Style;

@:expose
@:nativeGen
/**
    Displays a Location in an Element.
**/
class LocationView extends LocationViewAbstract<LocationView, Dynamic> {
    public static var FIELD_LOCATION_STYLE : Style = LocationViewAbstract.FIELD_LOCATION_STYLE;
    public static var FIELD_TILE_STYLE : Style = LocationViewAbstract.FIELD_TILE_STYLE;
    public static var FIELD_EFFECT_STYLE : Style = LocationViewAbstract.FIELD_EFFECT_STYLE;
    public static var FIELD_SELECT_STYLE : Style = LocationViewAbstract.FIELD_SELECT_STYLE;
    public static var FIELD_SHELL_STYLE : Style = LocationViewAbstract.FIELD_SHELL_STYLE;

    private static var _allocator : LocationViewAllocator = new LocationViewAllocator();

    /**
        Used to create LocationViews.
        This function is not meant to be used externally, only internally to the FieldEngine library.   
    **/
    public static function getAllocator() : com.field.manager.AllocatorSprite<LocationView> {
        return _allocator;
    }    

    public static function get(lLocation : LocationInterface<Dynamic, Dynamic>, settings : CommonSettings<LocationView>, field : FieldViewAbstract, fixedElement : Element) : LocationView {
        #if cs
            var s : Any = cast settings;
            return cast LocationViewAbstract.getI(lLocation, cast s, field, fixedElement);
        #else
            return cast LocationViewAbstract.getI(lLocation, cast settings, field, fixedElement);
        #end        
    }

    /**
        Get the LocationView for a given Element.
    **/
    public static function toLocationView(o : Element) : LocationView {
        return cast LocationViewAbstract.toLocationView(o);
    }
}

@:nativeGen
/**
    Used to create LocationViews.
    This function is not meant to be used externally, only internally to the FieldEngine library.   
**/
class LocationViewAllocator extends com.field.manager.AllocatorSprite<LocationView> {
    public function new() { }

    public override function allocate() : LocationView {
        return new LocationView();
    }
}
#end