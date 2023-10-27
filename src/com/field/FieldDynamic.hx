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

// TODO Next - Create superclass containing identical and near identical code
// TODO - Add compile (or whatever) function to convert to a standard field

@:expose
@:nativeGen
/**
    An implementation of a dynamic Field.  Dynamic Fields are likely to be slower and consume more memory than standard Fields, so it's recommended to call compact() after the Field has been built.
**/
class FieldDynamic extends FieldDynamicAbstract<LocationDynamic, SpriteDynamic> {
    private function new(options : FieldOptions<LocationDynamic, SpriteDynamic>) {
        super(options);
    }

    private override function initAllocators() : Void {
        if (_locationAllocator == null) {
            _locationAllocator = LocationDynamic.getAllocator();
        }

        if (_spriteAllocator == null) {
            _spriteAllocator = SpriteDynamic.getAllocator();
        }
    }

    private override function initManagers() : Void {
    }

    /**
        Create a dynamic Field with the given options.
    **/
    public static function create(options : FieldOptions<LocationDynamic, SpriteDynamic>) : FieldInterface<LocationDynamic, SpriteDynamic> {
        return new FieldWrapper<LocationDynamic, SpriteDynamic>(new FieldDynamic(options));
    }

    /**
        Options for creating a dynamic Field.
    **/
    public static function options() : FieldOptions<LocationDynamic, SpriteDynamic> {
        return new FieldDynamicOptions();
    }

    /**
        Create a default blank Dynamic Field.
    **/
    public override function newBlank() : FieldDynamicAbstract<LocationDynamic, SpriteDynamic> {
        return new FieldDynamic(null);
    }
}


@:nativeGen
class FieldDynamicOptions extends FieldOptions<LocationDynamic, SpriteDynamic> {
    public override function execute() : FieldInterface<LocationDynamic, SpriteDynamic> {
        return cast FieldDynamic.create(cast this);
    }    
}