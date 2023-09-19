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
    Defines an interface for Strategies for how to manipulate a Field internally.  For most purposes, the details of this are abstracted away with the Field, Location, and Sprite classes.
    This can be useful though when trying to access the Field in a manner that requires high performance.
**/
interface AccessorInterface {
    function getRows() : Int;
    function getColumns() : Int;
    function getSpriteCount() : Int;
    function moveSprite(i : Int, j : Int) : Int;
    function getLocationAttributeCount() : Int;
    function getSpriteAttributeCount() : Int;
    function getLocationAttributePosition(attribute : String) : Int;
    function getSpriteAttributePosition(attribute : String) : Int;
    function lookupLocationValue(attribute : String, value : Any) : Null<Int>;
    function lookupLocationValueDirect(attribute : Int, value : Any) : Null<Int>;
    function lookupSpriteValue(attribute : String, value : Any) : Null<Int>;
    function lookupSpriteValueDirect(attribute : Int, value : Any) : Null<Int>;    
    function lookupLocationString(attribute : String, value : String) : Int;
    function lookupSpriteString(attribute : String, value : String) : Int;
    function lookupLocationStringDirect(attribute : Int, value : String) : Int;
    function lookupSpriteStringDirect(attribute : Int, value : String) : Int;
    function reverseLocationString(attribute : String, value : Int) : String;
    function reverseSpriteString(attribute : String, value : Int) : String;
    function reverseLocationStringDirect(attribute : Int, value : Int) : String;
    function reverseSpriteStringDirect(attribute : Int, value : Int) : String;
    function setLocationString(i : Int, attribute : String, value : String) : Void;
    function setSpriteString(i : Int, attribute : String, value : String) : Void;
    function setLocationStringDirect(i : Int, attribute : Int, value : String) : Void;
    function setSpriteStringDirect(i : Int, attribute : Int, value : String) : Void;
    function getLocationString(i : Int, attribute : String) : String;
    function getSpriteString(i : Int, attribute : String) : String;
    function getLocationStringDirect(i : Int, attribute : Int) : String;
    function getSpriteStringDirect(i : Int, attribute : Int) : String;
    function lookupLocationFloat(attribute : String, value : Float) : Int;
    function lookupSpriteFloat(attribute : String, value : Float) : Int;
    function lookupLocationFloatDirect(attribute : Int, value : Float) : Int;
    function lookupSpriteFloatDirect(attribute : Int, value : Float) : Int;
    function reverseLocationFloat(attribute : String, value : Int) : Float;
    function reverseSpriteFloat(attribute : String, value : Int) : Float;
    function reverseLocationFloatDirect(attribute : Int, value : Int) : Float;
    function reverseSpriteFloatDirect(attribute : Int, value : Int) : Float;
    function setLocationFloat(i : Int, attribute : String, value : Float) : Void;
    function setSpriteFloat(i : Int, attribute : String, value : Float) : Void;
    function setLocationFloatDirect(i : Int, attribute : Int, value : Float) : Void;
    function setSpriteFloatDirect(i : Int, attribute : Int, value : Float) : Void;
    function getLocationFloat(i : Int, attribute : String) : Float;
    function getSpriteFloat(i : Int, attribute : String) : Float;
    function getLocationFloatDirect(i : Int, attribute : Int) : Float;
    function getSpriteFloatDirect(i : Int, attribute : Int) : Float;
    function setLocationInteger(i : Int, attribute : String, value : Int) : Void;
    function setSpriteInteger(i : Int, attribute : String, value : Int) : Void;
    function setLocationIntegerDirect(i : Int, attribute : Int, value : Int) : Void;
    function setSpriteIntegerDirect(i : Int, attribute : Int, value : Int) : Void;
    function getLocationInteger(i : Int, attribute : String) : Int;
    function getSpriteInteger(i : Int, attribute : String) : Int;
    function getLocationIntegerDirect(i : Int, attribute : Int) : Int;
    function getSpriteIntegerDirect(i : Int, attribute : Int) : Int;
    function getLocationType(attribute : String) : Int;
    function getSpriteType(attribute : String) : Int;
    function getLocationTypeDirect(attribute : Int) : Int;
    function getSpriteTypeDirect(attribute : Int) : Int;
    function getLocationAttribute(i : Int, attribute : String) : Any;
    function getSpriteAttribute(i : Int, attribute : String) : Any;
    function getLocationAttributeDirect(i : Int, attribute : Int) : Any;
    function getSpriteAttributeDirect(i : Int, attribute : Int) : Any;
    function setLocationAttribute(i : Int, attribute : String, value : Any) : Void;
    function setSpriteAttribute(i : Int, attribute : String, value : Any) : Void;
    function setLocationAttributeDirect(i : Int, attribute : Int, value : Any) : Void;
    function setSpriteAttributeDirect(i : Int, attribute : Int, value : Any) : Void;
    function locationAttributesLookupCount() : Int;
    function spriteAttributesLookupCount() : Int;
    function getSpriteLookupAttributes() : Iterator<String>;
    function getLocationLookupAttributes() : Iterator<String>;
    function getX(i : Int) : Int;
    function getY(i : Int) : Int;
    function moveRow(i : Int, y : Int) : Int;
    function moveColumn(i : Int, y : Int) : Int;
    function data(?data : Any) : Any;
    function clearData() : Void;
    function locationMemory() : Any;
    function spriteMemory() : Any;
    function slice() : Int;
    function sliceCount() : Int;
    function locationMemoryLength() : Int;
    function locationAttributesDivider(i : Int) : Float;
    function spriteAttributesDivider(i : Int) : Float;
    function directions() : NativeVector<Coordinate>;
}