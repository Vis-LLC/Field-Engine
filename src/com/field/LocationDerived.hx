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
    This defines a Location that wraps/decorates other Locations.
**/
class LocationDerived extends LocationDerivedAbstract<Dynamic, LocationDerived, Dynamic> {
    public function new() {
        super();
    }
    private static var _allocator : LocationDerivedAllocator = new LocationDerivedAllocator();

    public static function getAllocator() : com.field.manager.AllocatorLocation<LocationDerived> {
        return _allocator;
    }
}

@:nativeGen
/**
    Used to create LocationDeriveds.
    This function is not meant to be used externally, only internally to the FieldEngine library.   
**/
class LocationDerivedAllocator extends com.field.manager.AllocatorLocation<LocationDerived> {
    public function new() { }

    public override function allocate() : LocationDerived {
        return new LocationDerived();
    }
}