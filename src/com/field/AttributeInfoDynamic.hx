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
    The details of a given attribute for a FieldDynamic Location or Sprite.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class AttributeInfoDynamic {
    public inline function new() { }

    /**
        The name of the attribute.
    **/
    public var name : String;

    /**
        The type of the attribute.
        0: String
        1: Int
        2: Float
    **/
    public var type : Int;

    /**
        The position in the list of Attributes for a Location/Sprite.
    **/
    public var index : Int;

    /**
        Used to convert to/from a float.
    **/
    public var divider : Float;

    /**
        The maximum possible value (externally) for the Attribute.
    **/
    public var maximum : Int;

    /**
        The minimum possible value (externally) for the Attribute.
    **/
    public var minimum : Int;

    /**
        The list of possible String values.  Used to lookup the String value for a given Int/Index value.
    **/
    public var values : NativeStringMap<Int>;

    /**
        The map of possible String values.  Used to find the Int/Index value for a given string.
    **/
    public var reverse : NativeArray<String>;

    /**
        Position in the set of attributes.
    **/
    public var position : Int;
}