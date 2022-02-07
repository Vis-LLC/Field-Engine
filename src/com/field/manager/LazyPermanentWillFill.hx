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
    A Concrete Strategy for allocating parts of a Field in memory in a "lazy manner" and we want the object last indefinitely, additionally we intend to allocate every possible object.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
class LazyPermanentWillFill<T, F, L, S> implements Manager<T, L, S> {
    public function new() { }

    public function preallocate(allocator : Allocator<T>, fField : FieldInterface<L, S>, x : Int, y : Int) : Pool<T> {
        return allocator.recommendedArray(x, y, false);
    }

    public function allocateDiscard(allocator : Allocator<T>) : Pool<T> {
        return allocator.nullPool();
    }

    public function startWith(allocator : Allocator<T>, fField : FieldInterface<L, S>, pool : Pool<T>, discard : Pool<T>, x : Int, y : Int) : T {
        #if js
            return cast (cast pool.get(x, y, true, discard)).init(fField, x, y);
        #else
            return cast cast(pool.get(x, y, true, discard), Usable<Dynamic, Dynamic>).init(fField, x, y);
        #end
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