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

@:expose
@:nativeGen
/**
    An implementation of a dynamic Sprite.
**/
class SpriteDynamic extends SpriteDynamicAbstract<FieldDynamic, LocationDynamic, SpriteDynamic> {
    private static var _allocator = new SpriteDynamicAllocator();

    public function new() {
        super();
    }

    public static function getAllocator() : com.field.manager.AllocatorSprite<SpriteDynamic> {
        return _allocator;
    }
}

@:nativeGen
/**
    Used to create SpriteDynamics.
    This function is not meant to be used externally, only internally to the FieldEngine library.   
**/
class SpriteDynamicAllocator extends com.field.manager.AllocatorSprite<SpriteDynamic> {
    public function new() { }

    public override function allocate() : SpriteDynamic {
        return new SpriteDynamic();
    }
}