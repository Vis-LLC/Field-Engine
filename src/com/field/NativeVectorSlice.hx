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
    An Adapter class that allows all native vectors to be used easily.
**/
class NativeVectorSlice<V> {
    private var _v : NativeVector<V>;
    private var _start : Int;
    private var _end : Int;

    public function new(v : NativeVector<V>, start : Int, end : Int) {
        _v = v;
        _start = start;
        _end = end;
    }

    public function set(k : Int, v : Null<V>) : Void {
        _v.set(k + _start, v);
    }

    public function get(k : Int) : Null<V> {
        return _v.get(k + _start);
    }

    public function length() : Int {
        return _end - _start;
    }
}