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

package com.field.renderers;

#if !EXCLUDE_RENDERING
@:expose
@:nativeGen
/**
    A Bridge Interface for determining how event information is retrieved.
**/
interface EventInfoInterface {
    function preventDefault() : Void;

    /**
        Get the X coordinate for the event.
    **/
    function getX() : Int;

    /**
        Get the Y coordinate for the event.
    **/
    function getY() : Int;

    /**
        Get the Element for the event.
    **/
    function target() : Null<Element>;

    /**
        Get the key code for the event.
    **/
    function keyCode() : Int;

    /**
        Get the key for the event as a String.
    **/
    function key() : String;

    /**
        Get the buttons being pressed.
    **/
    function buttons() : Int;

    /**
        Get delta vector
    **/
    function wheelDelta() : NativeVector<Float>;
}
#end