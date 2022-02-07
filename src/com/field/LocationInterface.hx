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

package com.field;

@:expose
@:nativeGen
/**
    A Facade and Strategy that makes manipulation of an individual Location in a Field available in a simple object oriented manner.
**/
interface LocationInterface<F, L> extends Usable<F, L> extends HasAttributes {
    /**
        Gets all the Attributes as a string.
    **/
    function attributes() : String;
    // TODO
    //function State(lsNew : Null<LocationState>) : LocationState;

    /**
        Clear all data from the Location.
    **/
    function clearFieldData() : Void;

    /**
        Get the ID of the Location.
    **/
    function id() : String;

    /**
        Convert the Location into a String.
    **/
    function toString() : String;

    /**

    **/
    function neighbor(i : Int, j : Int, ?f : Null<L->Any>) : L;

    /**
        Indicates that we are done with the Location.
    **/
    function doneWith() : Void;

    /**
        Gets the index for the Location.
    **/
    function getI() : Int;

    /**
        Gets the X coordinate for the Sprite given the frame of reference.  Uses the parent field as the frame of reference if none is provided.
    **/
    function getX(for1 : FrameOfReference) : Int;

    /**
        Gets the Y coordinate for the Sprite given the frame of reference.  Uses the parent field as the frame of reference if none is provided.
    **/
    function getY(for1 : FrameOfReference) : Int;

    /**
        Get the Field this Location belongs to.
    **/
    function field() : F;

    /**
        Checks to see if the Location has recently changed.
    **/
    function changed() : Bool;

    /**
        Get or set the value of the specified Attribute.
    **/
    function attribute(sName : String, ?oValue : Any = null) : Any;

    /**
        Get or set the value of the specified Data.
    **/
    function data(sName : String, ?oValue : Any = null) : Any;

    /**
        Gets the custom Attribute keys.
    **/
    function myCustomAttributeKeys() : Iterator<String>;

    /**
        Gets the custom Data keys.
    **/
    function myCustomDataKeys() : Iterator<String>;

    /**
        Checks to see if the Location has a Value associated with it.
    **/
    function hasValue() : Bool;

    /**
        Checks to see if the Location has a Name associated with it.
    **/
    function hasName() : Bool;

    /**
        Checks to see if the Location is actually Dynamic.
    **/
    function isDynamic() : Bool;

    /**
        Checks to see if the Location has an "Actual Value" associated with it.
    **/
    function hasActualValue() : Bool;

    /**
        Checks to see if the Location has a "Data Source" associated with it.
    **/
    function hasDataSource() : Bool;
}