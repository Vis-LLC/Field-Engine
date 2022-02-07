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
    Represents a collection of Directions that represent how to navigate a Field.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
interface NavigatorCoreInterface {
    /**
        The number of available directions.
    **/
    function directionCount() : Int;

    /**
        The collection of directions for this Navigator.
    **/
    function directions() : NativeVector<DirectionInterface>;

    /**
        The Navigator/Directions that are diagonal to the current Navigator/Directions.
    **/
    function diagonal() : NavigatorCoreInterface;

    /**
        The Navigator/Directions that include the current Navigator/Directions and it's diagonals.
    **/
    function allDirections() : NavigatorCoreInterface;

    /**
        The "standard" Navigator/Directions for the coordinate system for the Field.
    **/
    function standard() : NavigatorCoreInterface;    

    /**
        Move a Sprite in a given Direction.
    **/
    function navigate(sprite : SpriteSystemInterface, direction : DirectionInterface, distance : Int) : Bool;

    /**
        Move a Sprite in a given Direction.
    **/    
    function navigateInDegrees(sprite : SpriteSystemInterface, direction : Float, distance : Int) : Bool;

    /**
        Move a Sprite in a given Direction.
    **/    
    function navigateInRadians(sprite : SpriteSystemInterface, direction : Float, distance : Int) : Bool;

    /**
        Move a Sprite in a given Direction.
    **/    
    function navigateInClock(sprite : SpriteSystemInterface, direction : Float, distance : Int) : Bool;

    /**
        Move a Sprite in a given Direction.
    **/    
    function navigateInXY(sprite : SpriteSystemInterface, x : Int, y : Int) : Bool;

    /**
        Get a Direction given a specified degrees.
    **/
    function directionForDegrees(direction : Float) : DirectionInterface;

    /**
        The collection of directions for an Accessor.
    **/
    function directionsForAccessor() : NativeVector<Coordinate>;
}