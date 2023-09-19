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

import com.field.navigator.NavigatorInterface;

/**
    A Facade and Strategy that makes manipulation of an individual Sprite in a Field available in a simple object oriented manner.
**/
@:expose
@:nativeGen
interface SpriteInterface<F, S> extends Usable<F, S> extends HasAttributes {
    /**
        Gets all the Attributes as a string.
    **/
    function attributes() : String;

    // TODO
    //function State(lsNew : Null<LocationState>) : LocationState;

    /**
        Clear all data from the Sprite.
    **/
    function clearFieldData() : Void;

    /**
        Get the ID of the Sprite.
    **/
    function id() : String;

    /**
        Convert the Sprite into a String.
    **/
    function toString() : String;

    /**
        Indicates that we are done with the Sprite.
    **/
    function doneWith() : Void;

    /**
        Gets the index for the Sprite.
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
        Hide the Sprite in the Field.  This is effectively removes the Sprite.
    **/
    function hide() : Void;

    /**
        Checks to see if the Sprite is hidden.
    **/
    function isHidden() : Bool;

    /**
        Moves the Sprite to the given XY coordinates.
    **/
    function set(x : Null<Int>, y : Null<Int>) : Void;

    /**
        Get the Field this Sprite belongs to.
    **/
    function field() : F;

    /**
        Checks to see if the Sprite has recently changed.
    **/
    function changed() : Bool;

    /**
        Checks to see if the Sprite can enter the specified location.
    **/
    function canEnter(accessor : Any, ?x : Any = null, ?y : Any = null, ?name : Any = null) : Bool;

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
        Copy attributes from an object to this Sprite.
    **/
    function copyAttributesFrom(o : Any) : Void;

    /**
        Represents a collection of Directions that represent how to navigate a Field.
    **/
    function navigator() : NavigatorInterface;

    /**
        Represents a collection of Directions that represent how to navigate a Field.  This version is unlocked and does not restrict to directions that match the grid perfectly.
    **/
    function unlockedNavigator() : NavigatorInterface;

    /**
        Checks to see if the Sprite has a Value associated with it.
    **/
    function hasValue() : Bool;

    /**
        Checks to see if the Sprite has a Name associated with it.
    **/
    // TODO
    //function hasName() : Bool;

    /**
        Checks to see if the Sprite is actually Dynamic.
    **/
    function isDynamic() : Bool;

    /**
        Checks to see if the Sprite has an "Actual Value" associated with it.
    **/
    function hasActualValue() : Bool;

    /**
        Checks to see if the Sprite has a "Data Source" associated with it.
    **/
    function hasDataSource() : Bool;


    function getField() : F;
}
/*
TODO
            type: function ()
            {
            },
        };
    },
    */