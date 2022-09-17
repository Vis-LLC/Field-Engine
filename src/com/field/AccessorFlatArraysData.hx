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
    An Accessor Momento.  This contains all the data that an Accessor Strategy needs to work.
**/
class AccessorFlatArraysData {
    public inline function new(slice : Int, sliceCount : Int, notShared : Bool) {
        this.slice = slice;
        this.sliceCount = sliceCount;
    }

    public var raw : Null<NativeVector<Int>>;
    public var locationMemory : Null<NativeVector<Int>>;
    public var spriteMemory : Null<NativeVector<Int>>;
    public var directions : Null<NativeVector<Coordinate>>;
    public var locationAttributes : Null<AccessorFlatArraysAttributes>;
    public var spriteAttributes : Null<AccessorFlatArraysAttributes>;
    public var locationSize : Int;
    public var locationSigned : Bool;
    public var spriteSize : Int;
    public var spriteSigned : Bool;
    public var slice : Int;
    public var sliceCount : Int;
    public var data : Any;
    public var height : Int;
    public var width : Int;
    public var maximumNumberOfSprites : Int;
}