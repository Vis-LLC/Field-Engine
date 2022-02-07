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
**/
interface NavigatorInterface {
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
    function diagonal() : NavigatorInterface;

    /**
        The Navigator/Directions that include the current Navigator/Directions and it's diagonals.
    **/
    function allDirections() : NavigatorInterface;

    /**
        The "standard" Navigator/Directions for the coordinate system for the Field.
    **/
    function standard() : NavigatorInterface;    

    /**
        Move in a given Direction.
    **/
    function navigate(direction : DirectionInterface, distance : Int) : Bool;

    /**
        Move in a given Direction.
    **/    
    function navigateInDegrees(direction : Float, distance : Int) : Bool;

    /**
        Move in a given Direction.
    **/    
    function navigateInRadians(direction : Float, distance : Int) : Bool;

    /**
        Move in a given Direction.
    **/    
    function navigateInClock(direction : Float, distance : Int) : Bool;

    /**
        Move in a given Direction.
    **/    
    function navigateInXY(x : Int, y : Int) : Bool;
}