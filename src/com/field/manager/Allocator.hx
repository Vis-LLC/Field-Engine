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

package com.field.manager;

/**
    Defines an interface for Factories for allocating parts of a Field in memory.
    Used to allocate Locations and Sprites.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
interface Allocator<T> {
    /**
        Allocate an object for use with a Field.
    **/
    function allocate() : T;

    /**
        Allocate an array for use with a Field.
    **/
    function recommendedArray(x : Int, y : Int, fill : Bool) : Pool<T>;

    /**
        Allocate a map for use with a Field.
    **/
    function recommendedMap(x : Int, y : Int, fill : Bool) : Pool<T>;
    
    /**
        Allocate a "null" Pool/a "fake" Pool.
    **/
    function nullPool() : Pool<T>;

    /**
        Allocate a simple array Pool.
    **/
    function simpleArray(x : Int, y : Int, fill : Bool) : Pool<T>;

    /**
        Get the X coordinate for an Object.
    **/
    function getX(o : T) : Int;

    /**
        Get the Y coordinate for an Object.
    **/
    function getY(o : T) : Int;
}