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
    Options for converting JSON to a Field.
**/
class FromJSONOptions extends OptionsAbstract<FromJSONOptions> {
    private var _field : Null<FieldInterface<Dynamic, Dynamic>>;

    public inline function new(?field : Null<FieldInterface<Dynamic, Dynamic>>) {
        super();
        _field = field;
    }

    /**
        Create a new Field based on the specs of the original Field.
    **/
    public function generateNew(generateNew : Bool) : FromJSONOptions {
        return set("generateNew", generateNew);
    }

    /**
        The JSON data to convert.
    **/
    public function data(s : String) : FromJSONOptions {
        return set("data", s);
    }

    /**
        The function to callback with the resulting Field.
    **/
    public function callbackWithField(f : FieldInterface<Dynamic,Dynamic>->Void) : FromJSONOptions {
        return set("callbackWithField", f);
    }

    /**
        The function to callback with the resulting raw data.
    **/
    public function callbackWithData(f : FieldInterface<Dynamic,Dynamic>->NativeVector<LocationInterface<Dynamic,Dynamic>>->NativeVector<SpriteInterface<Dynamic,Dynamic>>->NativeVector<FieldInterface<Dynamic,Dynamic>>->Void) : FromJSONOptions {
        return set("callbackWithField", f);
    }    

    /**
        The function to call when defining Locations.
    **/
    public function locationVisitor(f : LocationInterface<Dynamic, Dynamic>->Void) : FromJSONOptions {
        return set("locationVisitor", f);
    }

    /**
        The function to call when defining Sprites.
    **/
    public function spriteVisitor(f : SpriteInterface<Dynamic, Dynamic>->Void) : FromJSONOptions {
        return set("spriteVisitor", f);
    }

    /**
        The function to call when defining Subfields.
    **/
    public function subfieldVisitor(f : FieldInterface<Dynamic, Dynamic>->Void) : FromJSONOptions {
        return set("subfieldVisitor", f);
    }

    /**
        The function to call when done.
    **/
    public function callback(f : Void->Void) : FromJSONOptions {
        return set("callback", f);
    }

    /**
        Convert the specified JSON into a Field.
    **/
    public function execute() : Void {
        return _field.fromJSON(this);
    }    
}