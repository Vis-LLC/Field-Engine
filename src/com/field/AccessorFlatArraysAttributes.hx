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
    An Accessor Momento.  This contains all the data that an Accessor Strategy needs to manipulate the attributes for Locations or Sprites.
**/
class AccessorFlatArraysAttributes {
    public inline function new() { }

    public var count : Int;
    public var type : NativeArray<Int>;
    public var size : Int;
    public var lookup : Null<NativeStringMap<Int>>;
    public var reverse : Null<NativeArray<String>>;
    public var divider : Null<NativeArray<Float>>;
    public var valueLookup : Null<NativeArray<NativeStringMap<Int>>>;
    public var valueReverse : Null<NativeArray<NativeArray<String>>>;
}