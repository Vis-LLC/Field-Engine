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
    An implementation of a standard Field.
**/
class FieldStandard extends FieldAbstract<LocationStandard, SpriteStandard> {
    private function new(options : FieldOptions<LocationStandard, SpriteStandard>) {
        super(options);
    }

    private override function initAllocators() : Void {
        if (_locationAllocator == null) {
            _locationAllocator = LocationStandard.getAllocator();
        }

        if (_spriteAllocator == null) {
            _spriteAllocator = SpriteStandard.getAllocator();
        }
    }

    private override function initManagers() : Void {
        if (_locationManager == null) {
            _locationManager = new com.field.manager.TransientReuse<LocationStandard, FieldStandard, LocationStandard, SpriteStandard>();
        }

        if (_spriteManager == null) {
            _spriteManager = new com.field.manager.TransientReuse<SpriteStandard, FieldStandard, LocationStandard, SpriteStandard>();
        }
    }

    /**
        Create a standard Field with the given options.
    **/
    public static function create(options : FieldOptions<LocationStandard, SpriteStandard>) : FieldInterface<LocationStandard, SpriteStandard> {
        return new FieldWrapper<LocationStandard, SpriteStandard>(new FieldStandard(options));
    }

    /**
        Options for creating a standard Field.
    **/
    public static function options() : FieldOptions<LocationStandard, SpriteStandard> {
        return new FieldOptions<LocationStandard, SpriteStandard>();
    }

    /**
        Create a default blank standard Field.
    **/
    public override function newBlank() : FieldAbstract<LocationStandard, SpriteStandard> {
        return new FieldStandard(null);
    }    
}