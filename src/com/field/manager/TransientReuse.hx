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
    A Concrete Strategy for allocating parts of a Field in memory where each use is expected to be very temporary, but we reuse the objects.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
class TransientReuse<T, F, L, S> implements Manager<T, L, S> {
    public function new() { }

    public function preallocate(allocator : Allocator<T>, fField : FieldInterface<L, S>, x : Int, y : Int) : Pool<T> {
        return allocator.nullPool();
    }

    public function allocateDiscard(allocator : Allocator<T>) : Pool<T> {
        return allocator.simpleArray(-1, -1, true);
    }

    public function startWith(allocator : Allocator<T>, fField : FieldInterface<L, S>, pool : Pool<T>, discard : Pool<T>, x : Int, y : Int) : T {
        var o : T = simpleStart(allocator, pool, discard);
        var u : Usable<F, T> = cast o;
        u.init(cast fField, x, y);
        return o;
    }

    public function simpleStart(allocator : Allocator<T>, pool : Pool<T>, discard : Pool<T>) : T {
        var o : T;
        var u : Usable<F, T>;
        if (discard.count() > 0) {
            o = discard.pop();
        } else {
            o = allocator.allocate();
        }
        u = cast o;
        u.nowInUse();
        return o;
    }

    public function doneWith(o : T, pool : Pool<T>, discard : Pool<T>) : Void {
        if (
            #if js
                (cast o).notInUse()
            #else
                cast(o, Usable<Dynamic, Dynamic>).notInUse()
            #end
        == 0) {
            discard.add(o);
        }
    }

    public function isPermanent() : Bool {
        return false;
    }
}