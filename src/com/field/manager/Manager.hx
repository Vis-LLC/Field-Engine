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
    Defines an interface for Strategies for allocating parts of a Field in memory.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
interface Manager<T, L, S> {
    /**
        Called to preallocate the data structures for a field.
    **/
    function preallocate(allocator : Allocator<T>, fField : FieldInterface<L, S>, x : Int, y : Int) : Pool<T>;

    /**
        Called to preallocate the data structure to keep track of "discarded" Field data.
    **/
    function allocateDiscard(allocator : Allocator<T>) : Pool<T>;

    /**
        Access an object (Location/Sprite) in a Field.  Includes initialization.
    **/
    function startWith(allocator : Allocator<T>, fField : FieldInterface<L, S>, pool : Pool<T>, discard : Pool<T>, x : Int, y : Int) : T;

    /**
        Access an object (Location/Sprite) in a Field.  Does not include initialization.
    **/
    function simpleStart(allocator : Allocator<T>, pool : Pool<T>, discard : Pool<T>) : T;

    /**
        Finish using an object (Location/Sprite)
    **/
    function doneWith(o : T, pool : Pool<T>, discard : Pool<T>) : Void;

    /**
        Object allocation is permanent.
    **/
    function isPermanent() : Bool;
}