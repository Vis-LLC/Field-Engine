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
    The standard functions for a Field.  A Field is a map that consists of Locations and Sprites, structured, roughly, like some kind of table.
**/
interface FieldInterface<L, S> extends HasAccessor extends FrameOfReference {
    /**
        Get the Location at the given XY coordinate.
    **/
    function get(x : Int, y : Int) : L;

    /**
        Indicate that we have completed using an object that is part of the Field.  Such as a Location or a Sprite.
    **/
    function doneWith(o : Usable<L, S>) : Void;

    /**
        Get all the Location Attributes that are calculated based on other Attributes.
    **/
    function getLocationCalculatedAttributes() : NativeStringMap<L->Any>;

    /**
        Get all the Sprite Attributes that are calculated based on other Attributes.
    **/
    function getSpriteCalculatedAttributes() : NativeStringMap<S->Any>;

    /**
        Get the Location for a specified Sprite, the Sprite is specified by it's index.
        Note: Call doneWith on the Location when done.
    **/
    function findLocationForSpriteIndex(i : Int) : L;

    /**
        Get the Location for a specified Sprite.
        Note: Call doneWith on the Location when done.
    **/
    function findLocationForSprite(s : S) : L;

    /**
        Find all Sprites in an area in the Field.
        Note: Call doneWith on the Sprites when done.
    **/
    function findSprites(x1 : Int, y1 : Int, x2 : Int, y2 : Int) : NativeVector<S>;

    /**
        Find all Sprites in a specified Location.
        Note: Call doneWith on the Sprites when done.
    **/
    function findSpritesForLocation(l : L) : NativeVector<S>;

    /**
        Get the map connecting Location index to the list of Sprites.
    **/
    function getSpritesAtLocation() : NativeIntMap<NativeIntMap<Int>>;

    /**
        Refresh the mapping of Locations to Sprites based on the Sprite Attributes.
    **/
    function refreshSpriteLocations(callback : Void -> Void) : Void;

    /**
        Get the Sprite for a given Sprite Index.
        Note: Call doneWith on the Sprite when done.
    **/
    function getSprite(i : Int) : S;

    /**
        Get the Subfields that are located at the specified Location.
    **/
    function getSubfieldsForLocation(l : L) : NativeVector<FieldInterface<L, S>>;

    /**
        Get the specified Subfield that is located at the specified Location and has the specified index (or is the very first one).
    **/
    function getSubfieldForLocation(l : L, ?i : Int = 0) : FieldInterface<L, S>;

    /**
        Get the Subfields that are located at the specified Sprite.
    **/
    function getSubfieldsForSprite(s : S) : NativeVector<FieldInterface<L, S>>;

    /**
        Get the specified Subfield that is located at the specified Sprite and has the specified index (or is the very first one).
    **/
    function getSubfieldForSprite(s : S, ?i : Int = 0) : FieldInterface<L, S>;

    /**
        Convert the Field to a String.
    **/
    function toString() : String;

    /**
        Gets the X coordinate of the Field in it's parent.
    **/
    function getX() : Int;

    /**
        Gets the Y coordinate of the Field in it's parent.
    **/
    function getY() : Int;

    /**
        Gets the width of the Field in Locations.
    **/
    function width() : Int;

    /**
        Gets the height of the Field in Locations.
    **/
    function height() : Int;

    /**
        Fill in the specified Attribute with the given value for all Locations.
    **/
    function attributeFill(attribute : String, data : Any, callback : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void) : Void;

    /**
        Check the specified XY coordinate and return the actual XY coordinate.
    **/
    function getLoop(x : Int, y : Int) : Coordinate;

    /**
        Check to see if we should reset the XY coordinate at his point.
    **/
    function loopReset(x : Int, y : Int) : Bool;

    /**
        Call the custom refresh method to update the Field.
    **/
    function refresh(callback : Void->Void) : Void;

    /**
        Add a Listener for the given Event on this Field.
    **/
    function addEventListenerFor(event : Event, listener : EventInfo<Dynamic, Dynamic, Dynamic>->Void) : Void;

    /**
        Get the standard Field interface for the Field.
    **/
    function field() : FieldInterface<L, S>;

    /**
        Check to see if this Field equals another specified Field.
    **/
    function equals(f : FieldInterface<L, S>) : Bool;

    /**
        Add a SubField to this Field at the given XY coordinate.
    **/
    function addSubField(f : FieldInterface<L, S>, x : Int, y : Int) : Void;

    /**
        Get the ID of the Field.
    **/
    function id() : String;

    /**
        Load the data from the specified JSON file.
    **/
    function fromJSON(options : FromJSONOptions) : Void;

    /**
        Options for converting JSON to a Field.
    **/
    function fromJSONOptions() : FromJSONOptions;

    /**
        Save the data in the Field to a JSON string.
    **/
    function toJSON(options : ToJSONOptions) : Void;

    /**
        Options for converting a Field to JSON.
    **/
    function toJSONOptions() : ToJSONOptions;

    /**
        Create a SubField in this Field with the given ID at the specified XY coordinate and of the specified size.
    **/
    function createSubField(id : String, x : Int, y : Int, width : Int, height : Int) : FieldInterface<L, S>;

    /**
        Get the field that is the Parent of this Field.
    **/
    function getParentField() : FieldInterface<L, S>;

    /**
        Gets a value that represents a value that can be used to determine if the Field has been updated recently.
    **/
    function lastMajorChange() : Dynamic;

    /**
        Provides access to the "advanced" Field functions.
    **/
    function advanced() : FieldAdvancedInterface;
}