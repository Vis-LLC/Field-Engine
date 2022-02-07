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
    A Concrete Strategy for allocating blocks of objects as 2D Vectors.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
@:nativeGen
class PoolVector2D<T> implements Pool<T> {
    private var _data : haxe.ds.Vector<Null<haxe.ds.Vector<Null<T>>>>;
    private var _allocator : Allocator<T>;
    private var _count : Int = 0;
    private var _x : Int;

    public function new(allocator : Allocator<T>, x : Int, y : Int) {
        _data = new haxe.ds.Vector<Null<haxe.ds.Vector<Null<T>>>>(y);
        _allocator = allocator;
    }

    public function add(o : T) : Void { }

    public function get(x : Int, y : Int, create : Bool, getFrom : Pool<T>) : T {
        var row : Null<haxe.ds.Vector<Null<T>>>;
        
        if (y >= _data.length) {
            row = null;
        } else {
            row = _data[y];
        }

        if (row == null) {
            if (create) {
                row = new haxe.ds.Vector<Null<T>>(x);
                _data[y] = row;
            } else {
                return null;
            }
        }

        var o : Null<T>;
        
        if (x >= row.length) {
            o = null;
        } else {
            o = row[x];
        }
        
        if (o == null) {
            if (create) {
                if (getFrom.count() > 0) {
                    o = getFrom.pop();
                } else {
                    o = _allocator.allocate();
                }
                _count++;
                row[x] = o;
            } else {
                return null;
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

        var row : Null<haxe.ds.Vector<Null<T>>>;
        
        if (y >= _data.length) {
            row = null;
        } else {
            row = _data[y];
        }

        if (row != null) {
            var o;
            
            if (x >= row.length) {
                o = null;
            } else {
                o = row[x];
            }
            
            if (o != null) {
                row[x] = null;
                _count--;
            }
        }
    }

    public function forEach(f : Int->Int->T->Void) : Void {
        var j : Int = 0;
        while (j < _data.length) {
            var row : Null<haxe.ds.Vector<Null<T>>> = _data.get(j);
            if (row != null) {
                var i : Int = 0;
                while (i < row.length) {
                    f(i, j, row.get(i));
                    i++;
                }
            }
            j++;
        }
    }
}