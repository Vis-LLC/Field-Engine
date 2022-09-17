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

import com.field.navigator.NavigatorCoreInterface;

@:nativeGen
/**
    These methods are not generally accessed directly and are considered "system only".  All Fields should support these operations.
**/
interface FieldSystemInterface<L, S> {
    /**

    **/
    function getSpritesAtLocation() : NativeIntMap<NativeIntMap<Int>>;

    /**
        Convert the Field into a FieldSub of the specified Field.
    **/
    function convertToSubfield(parent : FieldInterface<L, S>, startX : Int, startY : Int) : FieldInterface<L, S>;

    /**
        Get the Field that is being wrapped.
    **/
    function getWrappedField() : FieldInterface<L, S>;

    /**
        Get the list of the FieldSub for the Field.
    **/
    function getSubfields() : Null<NativeArray<FieldInterface<L, S>>>;

    /**
        Get the raw memory block for the Attributes for all Locations in the Field.
    **/
    function getLocationMemory() : NativeVector<Int>;

    /**
        Get the raw memory block for the Attributes for all Sprites in the Field.
    **/
    function getSpriteMemory() : NativeVector<Int>;

    /**
        Get the number of Attributes for Locations.
    **/
    function getLocationAttributeCount() : Int;

    /**
        Get the number of Attributes for Sprites.
    **/
    function getSpriteAttributeCount() : Int;

    /**
        Get the maximum number of possible Sprites for this Field.
    **/
    function getMaximumNumberOfSprites() : Int;

    #if !EXCLUDE_RENDERING
    /**
        Check to see if the Field has any listeners for the given Event.
    **/
    function hasListeners(e : Event) : Bool;
    #end

    /**
        Represents a collection of Directions that represent how to navigate a Field.
    **/
    function navigator() : NavigatorCoreInterface;
}