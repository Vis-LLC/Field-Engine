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
class PoolArray2D<T> implements Pool<T> {
    private var _data : NativeArray<Null<NativeArray<Null<T>>>>;
    private var _allocator : Allocator<T>;
    private var _count : Int = 0;

    public function new(allocator : Allocator<T>) {
        _data = new NativeArray<Null<NativeArray<Null<T>>>>();
        _allocator = allocator;
    }

    public function add(o : T) : Void { }

    public function get(x : Int, y : Int, create : Bool, getFrom : Pool<T>) : T {
        var row : Null<NativeArray<Null<T>>>;
        
        if (y >= _data.length()) {
            row = null;
        } else {
            row = _data.get(y);
        }

        if (row == null) {
            if (create) {
                row = new NativeArray<Null<T>>();
                _data.set(y, row);
            } else {
                return null;
            }
        }

        var o : Null<T>;
        
        if (x >= row.length()) {
            o = null;
        } else {
            o = row.get(x);
        }
        
        if (o == null) {
            if (create) {
                if (getFrom.count() > 0) {
                    o = getFrom.pop();
                } else {
                    o = _allocator.allocate();
                }
                _count++;
                row.set(x, o);
            }
        }

        return o;
    }

    public function count() : Int {
        return _count;
    }

    public function pop() : T { 
        return null;
    }

    public function remove(o : T) : Void {
        var x : Int = _allocator.getX(o);
        var y : Int = _allocator.getY(o);

        var row : Null<NativeArray<Null<T>>>;
        
        if (y >= _data.length()) {
            row = null;
        } else {
            row = _data.get(y);
        }

        if (row != null) {
            var o;
            
            if (x >= row.length()) {
                o = null;
            } else {
                o = row.get(x);
            }
            
            if (o != null) {
                row.set(x, null);
                _count--;
            }
        }
    }

    public function forEach(f : Int->Int->T->Void) : Void {
        var j : Int = 0;
        while (j < _data.length()) {
            var row : Null<NativeArray<Null<T>>> = _data.get(j);
            if (row != null) {
                var i : Int = 0;
                while (i < row.length()) {
                    f(i, j, row.get(i));
                    i++;
                }
            }
            j++;
        }
    }    
}