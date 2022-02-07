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
    An implementation of a dynamic Location.
**/
class LocationDynamic extends LocationDynamicAbstract<FieldDynamic, LocationDynamic, SpriteDynamic> {
    private static var _allocator = new LocationDynamicAllocator();

    public function new() { }

    public static function getAllocator() : com.field.manager.AllocatorLocation<LocationDynamic> {
        return _allocator;
    }
}

@:nativeGen
/**
    Used to create LocationDynamics.
    This function is not meant to be used externally, only internally to the FieldEngine library.   
**/
class LocationDynamicAllocator extends com.field.manager.AllocatorLocation<LocationDynamic> {
    public function new() { }

    public override function allocate() : LocationDynamic {
        return new LocationDynamic();
    }
}