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
    A Concrete Strategy for allocating blocks of objects as 2D Arrays.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
class PoolArray<T> implements Pool<T> {
    private var _data : NativeArray<Null<T>>;
    private var _allocator : Allocator<T>;

    public function new(allocator : Allocator<T>) {
        _data = new NativeArray<T>();
        _allocator = allocator;
    }

    public function add(o : T) : Void {
        _data.push(o);
    }

    public function get(x : Int, y : Int, create : Bool, getFrom : Pool<T>) : T {
        var o : Null<T> = _data.get(x);
        if (o == null) {
            if (create) {
                if (getFrom.count() > 0) {
                    o = getFrom.pop();
                } else {
                    o = _allocator.allocate();
                }
                _data.set(x, o);
            }
        }
        return o;
    }

    public function count() : Int {
        return _data.length();
    }

    public function pop() : T {
        return _data.pop();
    }

    public function remove(o : T) : Void { }

    public function forEach(f : Int->Int->T->Void) : Void {
        var i : Int = 0;
        while (i < _data.length()) {
            f(i, 0, _data.get(i));
            i++;
        }
    }
}