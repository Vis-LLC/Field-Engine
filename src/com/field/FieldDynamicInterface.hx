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
    Additional functions for dynamic Fields.
**/
interface FieldDynamicInterface<L, S> {
    /**
        Get a Sprite with the Sprite Index.
    **/
    function getSpriteDirect(i : Int) : S;

    /**
        Get a Location with the Location Index.
    **/
    function getLocationDirect(i : Int) : L;

    /**
        Get the number of Attributes for Locations.
    **/
    function locationAttributeCount() : Int;    

    /**
        Get the number of Attributes for Sprites.
    **/
    function spriteAttributeCount() : Int;

    /**
        Get the number of Attributes for Locations that have a Definition.
    **/
    function locationAttributePredefinedCount() : Int;    

    /**
        Get the number of Attributes for Sprites that have a Definition.
    **/
    function spriteAttributePredefinedCount() : Int;

    /**
        Get all the predefined Sprite Attributes.
    **/
    function getSpriteLookupAttributes() : Iterator<String>;

    /**
        Get all the predefined Location Attributes.
    **/
    function getLocationLookupAttributes() : Iterator<String>;

    /**
        Create a new Location Attribute.
    **/
    function newLocationAttribute(name : String) : AttributeInfoDynamic;

    /**
        Create a new Sprite Attribute.
    **/
    function newSpriteAttribute(name : String) : AttributeInfoDynamic;

    /**
        Get the Attribute info for the given Location Attribute.
    **/
    function getLocationAttributeDirect(attribute : Int) : AttributeInfoDynamic;

    /**
        Get the Attribute info for the given Sprite Attribute.
    **/
    function getSpriteAttributeDirect(attribute : Int) : AttributeInfoDynamic;

    /**
        Get the Attribute info for the given Location Attribute.
    **/
    function getLocationAttribute(attribute : String) : AttributeInfoDynamic;

    /**
        Get the Attribute info for the given Sprite Attribute.
    **/
    function getSpriteAttribute(attribute : String) : AttributeInfoDynamic;

    /**
        Update Sprite Attribute definition to include the specified value.
    **/
    function spriteAttributeWithString(name : String, value : String) : Int;

    /**
        Update Sprite Attribute definition to include the specified value.
    **/
    function spriteAttributeWithInt(name : String, value : Int) : Int;

    /**
        Update Sprite Attribute definition to include the specified value.
    **/
    function spriteAttributeWithFloat(name : String, value : Float) : Int;

    /**
        Update Sprite Attribute definition to include the specified value.
    **/
    function spriteAttribute(name : String, value : Dynamic) : Int;

    /**
        Update Sprite Attribute definition to include the specified value.
    **/
    function spriteAttributeDirect(attribute : Int, value : Dynamic) : Int;

    /**
        Update Location Attribute definition to include the specified value.
    **/
    function locationAttributeWithString(name : String, value : String) : Int;

    /**
        Update Location Attribute definition to include the specified value.
    **/
    function locationAttributeWithInt(name : String, value : Int) : Int;

    /**
        Update Location Attribute definition to include the specified value.
    **/
    function locationAttributeWithFloat(name : String, value : Float) : Int;

    /**
        Update Location Attribute definition to include the specified value.
    **/
    function locationAttribute(name : String, value : Dynamic) : Int;

    /**
        Update Location Attribute definition to include the specified value.
    **/
    function locationAttributeDirect(attribute : Int, value : Dynamic) : Int;

    /**
        Decrease the height in Locations by 1.
    **/
    function decrementHeight() : Void;

    /**
        Decrease the width in Locations by 1.
    **/
    function decrementWidth() : Void;

    /**
        Increase the height in Locations by 1.
    **/
    function incrementHeight() : Void;

    /**
        Increase the width in Locations by 1.
    **/
    function incrementWidth() : Void;

    /**
        Convert a dynamic Field to a standard Field.
    **/
    function compact(callback : FieldInterface<L, S>->Void) : Void;
}