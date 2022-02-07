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

@:expose
@:nativeGen
/**
    Additional functions for use with "standard" FieldViews.
**/
interface FieldViewFullInterface extends com.field.navigator.NavigatorInterface {
    /**
        Get the SpriteView for the specified Sprite.
    **/
    function findViewForSprite(s : SpriteInterface<Dynamic, Dynamic>) : SpriteView;

    /**
        Specifies that the Sprite was recently added/manipulated and may not be detected by the FieldView.
    **/
    function needToAdd(s : SpriteInterface<Dynamic, Dynamic>) : Void;

    /**
        Get or set the Field displayed by the FieldView.
    **/
    function field(?fNew : Null<FieldInterface<Dynamic, Dynamic>>) : FieldInterface<Dynamic, Dynamic>;

    /**
        Sets the Sprite which is the "main character".  This is the sprite that we use for reference for scrolling.
    **/
    function setMainSprite(s : SpriteInterface<Dynamic, Dynamic>) : Void;
}
