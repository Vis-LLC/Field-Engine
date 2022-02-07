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
    Options for converting a Field to JSON.
**/
class ToJSONOptions extends OptionsAbstract<ToJSONOptions> {
    private var _field : Null<FieldInterface<Dynamic, Dynamic>>;

    public inline function new(?field : Null<FieldInterface<Dynamic, Dynamic>>) {
        super();
        _field = field;
    }

    /**
        Export the raw memory block for the Sprite Attributes.
    **/
    public function spriteArray(export : Bool) : ToJSONOptions {
        return set("spriteArray", export);
    }

    /**
        Export the raw memory block for the Location Attributes.
    **/
    public function locationArray(export : Bool) : ToJSONOptions {
        return set("locationArray", export);
    }

    /**
        Compress the raw memory block for the Sprite Attributes.
    **/
    public function compressSpriteArray(compress : Bool) : ToJSONOptions {
        return set("compressSpriteArray", compress);
    }

    /**
        Compress the raw memory block for the Location Attributes.
    **/
    public function compressLocationArray(compress : Bool) : ToJSONOptions {
        return set("compressLocationArray", compress);
    }

    /**
        Compress the JSON.
    **/
    public function compressJSON(compress : Bool) : ToJSONOptions {
        return set("compressJSON", compress);
    }

    /**
        Convert the misc data to JSON.
    **/
    public function miscInfo(export : Bool) : ToJSONOptions {
        return set("miscInfo", export);
    }

    /**
        Convert the size data to JSON.
    **/
    public function sizeInfo(export : Bool) : ToJSONOptions {
        return set("sizeInfo", export);
    }

    /**
        Export the FieldSubs to the JSON.
    **/
    public function subFields(export : Bool) : ToJSONOptions {
        return set("subFields", export);
    }    

    /**
        Export the attributes to JSON.
    **/
    public function attributes(export : Bool) : ToJSONOptions {
        return set("attributes", export);
    }

    /**
        Export the custom data to the JSON.
    **/
    public function customData(export : Bool) : ToJSONOptions {
        return set("customData", export);
    }    

    /**
        Convert the whole Field to JSON.
    **/
    public function full() : ToJSONOptions {
        spriteArray(true);
        locationArray(true);
        miscInfo(true);
        sizeInfo(true);
        subFields(true);
        attributes(true);
        customData(true);
        return this;
    }

    /**
        The function to call and pass the JSON to when conversion is completed.
    **/
    public function callback(f : String->Void) : ToJSONOptions {
        return set("callback", f);
    }

    /**
        Convert the Field to JSON using the specified options.
    **/
    public function execute() : Void {
        return _field.toJSON(this);
    }
}