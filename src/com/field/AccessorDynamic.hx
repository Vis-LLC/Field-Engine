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
    Defines an interface for Strategies for how to manipulate a Field internally.  For most purposes, the details of this are abstracted away with the Field, Location, and Sprite classes.
    This can be useful though when trying to access the Field in a manner that requires high performance.
**/
class AccessorDynamic implements AccessorInterface {
    private var _data : AccessorDynamicData;

    private function new(data : Null<AccessorDynamicData>) {
        _data = data;
    }

    public function getRows() : Int {
        return _data.field.height();
    }

    public function getColumns() : Int {
        return _data.field.width();
    }

    public function getSpriteCount() : Int {
        var fs : FieldSystemInterface<Dynamic, Dynamic> = cast _data.field;
        return fs.getMaximumNumberOfSprites();
    }

    public function moveSprite(i : Int, j : Int) : Int {
        return i + j * getSpriteAttributeCount();
    }

    public function getLocationAttributeCount() : Int {
        return _data.fd.locationAttributeCount();
    }

    public function getSpriteAttributeCount() : Int {
        return _data.fd.spriteAttributeCount();
    }

    public function getLocationAttributePosition(attribute : String) : Int {
        return -1;
    }

    public function getSpriteAttributePosition(attribute : String) : Int {
        return -1;
    }
    
    public function lookupLocationValue(attribute : String, value : Any) : Null<Int> {
        var info : AttributeInfoDynamic = _data.fd.getLocationAttribute(attribute);
        switch (info.type) {
            case 0:
                return lookupLocationString(attribute, value);
            case 1:
                return cast value;
            case 2:
                var fValue : Float = cast value;
                return Math.floor(fValue * info.divider);
            default:
                return null;
        }
    }

    public function lookupLocationValueDirect(attribute : Int, value : Any) : Null<Int> {
        var info : AttributeInfoDynamic = _data.fd.getLocationAttributeDirect(attribute);
        switch (info.type) {
            case 0:
                return lookupLocationStringDirect(attribute, value);
            case 1:
                return cast value;
            case 2:
                var fValue : Float = cast value;
                return Math.floor(fValue * info.divider);
            default:
                return null;
        }
    }

    public function lookupSpriteValue(attribute : String, value : Any) : Null<Int> {
        var info : AttributeInfoDynamic = _data.fd.getSpriteAttribute(attribute);
        switch (info.type) {
            case 0:
                return lookupSpriteString(attribute, value);
            case 1:
                return cast value;
            case 2:
                var fValue : Float = cast value;
                return Math.floor(fValue * info.divider);
            default:
                return null;
        }
    }
    
    public function lookupSpriteValueDirect(attribute : Int, value : Any) : Null<Int> {
        var info : AttributeInfoDynamic = _data.fd.getSpriteAttributeDirect(attribute);
        switch (info.type) {
            case 0:
                return lookupSpriteStringDirect(attribute, cast value);
            case 1:
                return cast value;
            case 2:
                var fValue : Float = cast value;
                return Math.floor(fValue * info.divider);
            default:
                return null;
        }
    }

    public function lookupLocationString(attribute : String, value : String) : Int {
        return _data.fd.getLocationAttribute(attribute).values.get(value);
    }

    public function lookupSpriteString(attribute : String, value : String) : Int {
        return _data.fd.getSpriteAttribute(attribute).values.get(value);
    }

    public function lookupLocationStringDirect(attribute : Int, value : String) : Int {
        return _data.fd.getLocationAttributeDirect(attribute).values.get(value);
    }

    public function lookupSpriteStringDirect(attribute : Int, value : String) : Int {
        return _data.fd.getSpriteAttributeDirect(attribute).values.get(value);
    }

    public function reverseLocationString(attribute : String, value : Int) : String {
        return _data.fd.getLocationAttribute(attribute).reverse.get(value);
    }

    public function reverseSpriteString(attribute : String, value : Int) : String {
        return _data.fd.getSpriteAttribute(attribute).reverse.get(value);
    }

    public function reverseLocationStringDirect(attribute : Int, value : Int) : String {
        return _data.fd.getLocationAttributeDirect(attribute).reverse.get(value);
    }

    public function reverseSpriteStringDirect(attribute : Int, value : Int) : String {
        return _data.fd.getSpriteAttributeDirect(attribute).reverse.get(value);
    }

    public function setLocationString(i : Int, attribute : String, value : String) : Void {
        getLocationDirect(i).attribute(attribute, value);
    }

    private function getLocationDirect(i : Int) : com.field.LocationDynamic {
        if (getLocationAttributeCount() <= 0) {
            return _data.fd.getLocationDirect(i);
        } else {
            return _data.fd.getLocationDirect(cast i / getLocationAttributeCount());
        }
    }

    private function getSpriteDirect(i : Int) : com.field.SpriteDynamic {
        if (getSpriteAttributeCount() <= 0) {
            return _data.fd.getSpriteDirect(i);
        } else {
            return _data.fd.getSpriteDirect(cast i / getSpriteAttributeCount());
        }
    }

    public function setSpriteString(i : Int, attribute : String, value : String) : Void {
        getSpriteDirect(i).attribute(attribute, value);
    }

    public function setLocationStringDirect(i : Int, attribute : Int, value : String) : Void {
        getLocationDirect(i).attributeDirect(attribute, value);
    }

    public function setSpriteStringDirect(i : Int, attribute : Int, value : String) : Void {
        getSpriteDirect(i).attributeDirect(attribute, value);
    }

    public function getLocationString(i : Int, attribute : String) : String {
        return getLocationDirect(i).attribute(attribute);
    }

    public function getSpriteString(i : Int, attribute : String) : String {
        return getSpriteDirect(i).attribute(attribute);
    }

    public function getLocationStringDirect(i : Int, attribute : Int) : String {
        return getLocationDirect(i).attribute(_data.fd.getLocationAttributeDirect(attribute).name);
    }

    public function getSpriteStringDirect(i : Int, attribute : Int) : String {
        return getSpriteDirect(i).attribute(_data.fd.getSpriteAttributeDirect(attribute).name);
    }

    public function lookupLocationFloat(attribute : String, value : Float) : Int {
        var info : AttributeInfoDynamic = _data.fd.getLocationAttribute(attribute);
        var fValue : Float = cast value;
        return Math.floor(fValue * info.divider);
    }

    public function lookupSpriteFloat(attribute : String, value : Float) : Int {
        var info : AttributeInfoDynamic = _data.fd.getSpriteAttribute(attribute);
        var fValue : Float = cast value;
        return Math.floor(fValue * info.divider);
    }

    public function lookupLocationFloatDirect(attribute : Int, value : Float) : Int {
        var info : AttributeInfoDynamic = _data.fd.getLocationAttributeDirect(attribute);
        var fValue : Float = cast value;
        return Math.floor(fValue * info.divider);
    }

    public function lookupSpriteFloatDirect(attribute : Int, value : Float) : Int {
        var info : AttributeInfoDynamic = _data.fd.getSpriteAttributeDirect(attribute);
        var fValue : Float = cast value;
        return Math.floor(fValue * info.divider);
    }

    public function reverseLocationFloat(attribute : String, value : Int) : Float {
        return value * _data.fd.getLocationAttribute(attribute).divider;
    }
    
    public function reverseSpriteFloat(attribute : String, value : Int) : Float {
        return value * _data.fd.getSpriteAttribute(attribute).divider;
    }

    public function reverseLocationFloatDirect(attribute : Int, value : Int) : Float {
        return value * _data.fd.getLocationAttributeDirect(attribute).divider;
    }

    public function reverseSpriteFloatDirect(attribute : Int, value : Int) : Float {
        return value * _data.fd.getSpriteAttributeDirect(attribute).divider;
    }

    public function setLocationFloat(i : Int, attribute : String, value : Float) : Void {
        getLocationDirect(i).attribute(attribute, value);
    }

    public function setSpriteFloat(i : Int, attribute : String, value : Float) : Void {
        getSpriteDirect(i).attribute(attribute, value);
    }

    public function setLocationFloatDirect(i : Int, attribute : Int, value : Float) : Void {
        getLocationDirect(i).attributeDirect(attribute, value);
    }

    public function setSpriteFloatDirect(i : Int, attribute : Int, value : Float) : Void {
        getSpriteDirect(i).attributeDirect(attribute, value);
    }

    public function getLocationFloat(i : Int, attribute : String) : Float {
        return getLocationDirect(i).attribute(attribute);
    }

    public function getSpriteFloat(i : Int, attribute : String) : Float {
        return getSpriteDirect(i).attribute(attribute);
    }

    public function getLocationFloatDirect(i : Int, attribute : Int) : Float {
        return getLocationDirect(i).attributeDirect(attribute);
    }

    public function getSpriteFloatDirect(i : Int, attribute : Int) : Float {
        return getSpriteDirect(i).attributeDirect(attribute);
    }
    
    public function setLocationInteger(i : Int, attribute : String, value : Int) : Void {
        getLocationDirect(i).attribute(attribute, value);
    }

    public function setSpriteInteger(i : Int, attribute : String, value : Int) : Void {
        getSpriteDirect(i).attribute(attribute, value);
    }

    public function setLocationIntegerDirect(i : Int, attribute : Int, value : Int) : Void {
        getLocationDirect(i).attributeDirect(attribute, value);
    }

    public function setSpriteIntegerDirect(i : Int, attribute : Int, value : Int) : Void {
        getSpriteDirect(i).attributeDirect(attribute, value);
    }

    public function getLocationInteger(i : Int, attribute : String) : Int {
        return cast getLocationDirect(i).attribute(attribute);
    }

    public function getSpriteInteger(i : Int, attribute : String) : Int {
        return cast getSpriteDirect(i).attribute(attribute);
    }

    public function getLocationIntegerDirect(i : Int, attribute : Int) : Int {
        return cast getLocationDirect(i).attributeDirect(attribute);
    }

    public function getSpriteIntegerDirect(i : Int, attribute : Int) : Int {
        return cast getSpriteDirect(i).attributeDirect(attribute);
    }

    public function getLocationType(attribute : String) : Int {
        return _data.fd.getLocationAttribute(attribute).type;
    }

    public function getSpriteType(attribute : String) : Int {
        return _data.fd.getSpriteAttribute(attribute).type;
    }

    public function getLocationTypeDirect(attribute : Int) : Int {
        return _data.fd.getLocationAttributeDirect(attribute).type;
    }

    public function getSpriteTypeDirect(attribute : Int) : Int {
        return _data.fd.getSpriteAttributeDirect(attribute).type;
    }

    public function getLocationAttribute(i : Int, attribute : String) : Any {
        return getLocationDirect(i).attribute(attribute);
    }

    public function getSpriteAttribute(i : Int, attribute : String) : Any {
        return getSpriteDirect(i).attribute(attribute);
    }

    public function getLocationAttributeDirect(i : Int, attribute : Int) : Any {
        return getLocationDirect(i).attributeDirect(attribute);
    }

    public function getSpriteAttributeDirect(i : Int, attribute : Int) : Any {
        return getSpriteDirect(i).attributeDirect(attribute);
    }

    public function setLocationAttribute(i : Int, attribute : String, value : Any) : Void {
        getLocationDirect(i).attribute(attribute, value);
    }

    public function setSpriteAttribute(i : Int, attribute : String, value : Any) : Void {
        getSpriteDirect(i).attribute(attribute, value);
    }

    public function setLocationAttributeDirect(i : Int, attribute : Int, value : Any) : Void {
        getLocationDirect(i).attributeDirect(attribute, value);
    }

    public function setSpriteAttributeDirect(i : Int, attribute : Int, value : Any) : Void {
        getSpriteDirect(i).attributeDirect(attribute, value);
    }

    public function locationAttributesLookupCount() : Int {
        return _data.fd.locationAttributePredefinedCount();
    }
    
    public function spriteAttributesLookupCount() : Int {
        return _data.fd.spriteAttributePredefinedCount();
    }

    public function getSpriteLookupAttributes() : Iterator<String> {
        return _data.fd.getSpriteLookupAttributes();
    }

    public function getLocationLookupAttributes() : Iterator<String> {
        return _data.fd.getLocationLookupAttributes();
    }
    
    public function getX(i : Int) : Int {
        return i % getColumns();
    }

    public function getY(i : Int) : Int {
        return Math.floor(i / getColumns());
    }
    
    public function moveRow(i : Int, y : Int) : Int {
        return i + getColumns() * y;
    }

    public function moveColumn(i : Int, y : Int) : Int {
        return i + y;
    }
    
    public function data(?data : Any) : Any {
        if (data != null) {
            _data.data = data;
        }
        return _data.data;
    }

    public function setData(data : Any) {
        _data.data = data;
    }
    
    public function clearData() : Void {
        _data.data = null;
    }

    public function locationMemory() : Any {
        return null;
    }

    public function spriteMemory() : Any {
        return null;
    }
    
    public function slice() : Int {
        return _data.slice;
    }

    public function sliceCount() : Int {
        return _data.sliceCount;
    }

    public function locationMemoryLength() : Int {
        return 0;
    }

    public function locationAttributesDivider(i : Int) : Float {
        return _data.fd.getLocationAttributeDirect(i).divider;
    }

    public function spriteAttributesDivider(i : Int) : Float {
        return _data.fd.getSpriteAttributeDirect(i).divider;
    }
    
    public function directions() : NativeVector<Coordinate> {
        return _data.directions;
    }

    public static function wrap(data : AccessorDynamicData) : AccessorInterface {
        return new AccessorDynamic(data);
    }
}