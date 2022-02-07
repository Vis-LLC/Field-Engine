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
    Defines an interface for Strategies for how blocks of objects are handled.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
interface Pool<T> {
    /**
        Add an object (Sprite/Location) to the pool.
    **/
    function add(o : T) : Void;

    /**
        Get an object (Sprite/Location) from the pool.
    **/
    function get(x : Int, y : Int, create : Bool, getFrom : Pool<T>) : T;

    /**
        The number of objects in the pool.
    **/
    function count() : Int;

    /**
        Pop an object out of the pool.
    **/
    function pop() : T;

    /**
        Remove an object from the pool.
    **/
    function remove(o : T) : Void;

    /**
        Iterate over the whole pool.
    **/
    function forEach(f : Int->Int->T->Void) : Void;
}