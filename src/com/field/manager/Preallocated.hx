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
    A Concrete Strategy for allocating parts of a Field in memory in an upfront manner, where all objects will be allocated at once and will remain in memory "permanently".
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
class Preallocated<T, F, L, S> implements Manager<T, L, S> {
    public function new() { }

    public function preallocate(allocator : Allocator<T>, fField : FieldInterface<L, S>, x : Int, y : Int) : Pool<T> {
        var pool : Pool<T> = allocator.recommendedArray(x, y, true);
        var nullPool : Pool<T> = allocator.nullPool();

        var i : Int = 0;
        while (i < x) {
            var j : Int = 0;
            while (j < y) {
                var u :  Usable<Dynamic, Dynamic> = cast pool.get(i, j, true, nullPool);
                u.init(fField, i, j);
                j++;
            }
            i++;
        }       
        return pool;
    }

    public function allocateDiscard(allocator : Allocator<T>) : Pool<T> {
        return allocator.nullPool();
    }

    public function startWith(allocator : Allocator<T>, fField : FieldInterface<L, S>, pool : Pool<T>, discard : Pool<T>, x : Int, y : Int) : T {
        return pool.get(x, y, false, discard);
    }

    public function simpleStart(allocator : Allocator<T>, pool : Pool<T>, discard : Pool<T>) : T {
        return null; // TODO
    }    

    public function doneWith(o : T, pool : Pool<T>, discard : Pool<T>) : Void {
        #if js
            (cast o).notInUse();
        #else
            cast(o, Usable<Dynamic, Dynamic>).notInUse();
        #end
    }

    public function isPermanent() : Bool {
        return true;
    }
}