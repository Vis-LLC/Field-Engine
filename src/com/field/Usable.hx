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

@:nativeGen
/**
    A base interface that is used to indicate that the object is managed by an Allocator.
**/
interface Usable<F, T> {
    /**
        This object is no longer in use.  Generally this means it can now be disposed off.
    **/
    function notInUse() : Int;

    /**
        This object is now in use.
    **/
    function nowInUse() : Int;

    /**
        The current number of processes using the object.
    **/
    function useCount() : Int;

    /**
        Initializse the object.
    **/
    function init(newField : F, newX : Int, newY : Int) : T;
}