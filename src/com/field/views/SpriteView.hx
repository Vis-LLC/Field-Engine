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
    Displays a Sprite in an Element.
**/
class SpriteView extends SpriteViewAbstract<Dynamic, SpriteView> {
    public static var FIELD_SPRITE_STYLE : Style = SpriteViewAbstract.FIELD_SPRITE_STYLE;
    public static var FIELD_TILE_STYLE : Style = SpriteViewAbstract.FIELD_TILE_STYLE;
    public static var FIELD_EFFECT_STYLE : Style = SpriteViewAbstract.FIELD_EFFECT_STYLE;
    public static var FIELD_SELECT_STYLE : Style = SpriteViewAbstract.FIELD_SELECT_STYLE;
    public static var FIELD_SHELL_STYLE : Style = SpriteViewAbstract.FIELD_SHELL_STYLE;

    public function new() {
        super();
    }

    private static var _allocator : SpriteViewAllocator = new SpriteViewAllocator();

    /**
        Used to create SpriteViews.
        This function is not meant to be used externally, only internally to the FieldEngine library.   
    **/
    public static function getAllocator() : com.field.manager.AllocatorSprite<SpriteView> {
        return _allocator;
    }    

    public static function toSpriteView(o : Any) : SpriteView {
        return cast SpriteViewAbstract.toSpriteView(o);
    }

    public static function get(sSprite : SpriteInterface<Dynamic, Dynamic>, settings : CommonSettings<SpriteView>, field : FieldViewAbstract) : SpriteView {
        #if cs
            var s : Any = cast settings;
            return cast SpriteViewAbstract.getI(sSprite, cast s, field);
        #else
            return cast SpriteViewAbstract.getI(sSprite, cast settings, field);
        #end
    }
}

@:nativeGen
/**
    Used to create SpriteViews.
    This function is not meant to be used externally, only internally to the FieldEngine library.   
**/
class SpriteViewAllocator extends com.field.manager.AllocatorSprite<SpriteView> {
    public function new() { }

    public override function allocate() : SpriteView {
        return new SpriteView();
    }
}
#end