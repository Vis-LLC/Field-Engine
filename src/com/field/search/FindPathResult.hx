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


package com.field.search;

import com.field.NativeStringMap;

@:expose
@:nativeGen
/**
    The result of a FindPath execution.
**/
class FindPathResult {
    public inline function new(start : Coordinate, end : Coordinate, value : Int, path : NativeVector<Coordinate>) {
        this.start = start;
        this.end = end;
        this.value = value;
        this.path = path;
    }

    /**
        The starting coordinate.
    **/
    public var start : Coordinate;

    /**
        The ending coordinate.
    **/
    public var end : Coordinate;

    /**
        How "expensive" the path is.
    **/
    public var value : Int;

    /**
        The path from start to end in coordinates.
    **/
    public var path : NativeVector<Coordinate>;
}