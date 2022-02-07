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

package com.field.navigator;

@:expose
@:nativeGen
/**
    Represents a direction that can be moved in on a Field.
**/
interface DirectionInterface {
    /**
        The name of the direction.
    **/
    function name() : String;

    /**
        The Direction next to the current one in a Clockwise direction.
    **/
    function clockwise() : DirectionInterface;

    /**
        The Direction next to the current one in a Counterclockwise direction.
    **/    
    function counterClockwise() : DirectionInterface;

    /**
        The Direction directly opposite that can be accessed.
    **/
    function opposite() : Null<DirectionInterface>;

    /**
        The Direction directly opposite, even if it is normally inaccessible.
    **/
    function oppositeAny() : DirectionInterface;

    /**
        Can move in this direction.
    **/
    function movable() : Bool;

    /**
        The direction represented in degrees.
    **/
    function degrees() : Float;

    /**
        The direction represented in radians.
    **/    
    function radians() : Float;

    /**
        The direction represented in hours.
    **/    
    function clock() : Float;

    /**
        The direction represented as XY coordinates.
    **/    
    function xy() : NativeVector<Float>;

    /**
        The X multiplier for the direction.
    **/
    function distanceMultiplierX() : Float;

    /**
        The Y multiplier for the direction.
    **/
    function distanceMultiplierY() : Float;

    /**
        The X shift for the direction.
    **/
    function shiftX() : Float;

    /**
        The Y shift for the direction.
    **/
    function shiftY() : Float;
}