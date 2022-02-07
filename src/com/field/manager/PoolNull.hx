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
    A Concrete Strategy for not allocating blocks of objects.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
class PoolNull<T> implements Pool<T> {
    public function new() { }

    public function add(o : T) : Void { }

    public function get(x : Int, y : Int, create : Bool, getFrom : Pool<T>) : T {
        return null;
    }

    public function count() : Int {
        return 0;
    }

    public function pop() : T {
        return null;
    }

    public function remove(o : T) : Void { }

    public function forEach(f : Int->Int->T->Void) : Void { }
}