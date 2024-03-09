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

// TODO - LocationEquationValue
// TODO - LocationRawDataSource
@:expose
@:nativeGen
/**
    Defines a Sprite that can also contain a text value.
**/
class SpriteTextValue extends SpriteAbstract<FieldStandard, SpriteTextValue, Dynamic> implements SpriteExtendedInterface {
    public function new() {
        super();
    }

    public function value(?oNew : Any = null) : Any {
        return attribute("value", oNew);
    }

    public function name(?oNew : Any = null) : Any {
        return attribute("name", oNew);
    }    

    public function actualValue(?oNew : Any = null) : Any {
        return value(oNew);
    }

    public function dataSource(?oNew : Any) : Any {
        return null;
    }

    public override function id() : String {
        return cast value();
    }

    public override function clearFieldData() : Void {
        super.clearFieldData();
    }

    private static var _allocator : SpriteTextValueAllocator = new SpriteTextValueAllocator();

    public static function getAllocator() : com.field.manager.AllocatorSprite<SpriteTextValue> {
        return _allocator;
    }
}

@:nativeGen
/**
    Used to create SpriteTextValue.
    This function is not meant to be used externally, only internally to the FieldEngine library.   
**/
class SpriteTextValueAllocator extends com.field.manager.AllocatorSprite<SpriteTextValue> {
    public function new() { }

    public override function allocate() : SpriteTextValue {
        return new SpriteTextValue();
    }
}