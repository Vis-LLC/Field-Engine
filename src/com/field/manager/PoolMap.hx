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

import com.field.manager.Allocator;

/**
    A Concrete Strategy for allocating blocks of objects as Maps.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
class PoolMap<T> implements Pool<T> {
    private var _data : NativeIntMap<T>;
    private var _allocator : Allocator<T>;
    private var _count = 0;

    public function new(allocator : Allocator<T>) {
        _data = new NativeIntMap<T>();
        _allocator = allocator;
    }

    public function add(o : T) : Void {
        _data.set(_count++, o);
    }

    public function get(x : Int, y : Int, create : Bool, getFrom : Pool<T>) : T {
        var o : Null<T> = _data.get(x);
        if (o == null) {
            if (create) {
                o = _allocator.allocate();
                _data.set(x, o);
            }
        }
        return o;
    }

    public function count() : Int {
        return _count;
    }

    public function pop() : T {
        _count--;
        var o = _data.get(_count);
        _data.set(_count, null);
        return o;
    }

    public function remove(o : T) : Void {
        _data.remove(_allocator.getX(o));
    }

    public function forEach(f : Int->Int->T->Void) : Void {
        var keys : Iterator<Int> = cast _data.keys();
        for (i in keys) {
            f(i, 0, _data.get(i));
        }
    }
}