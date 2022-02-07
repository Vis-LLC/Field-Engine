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
    Defines a partially complete Concrete Strategy for how to manipulate a Field internally, where the field is defined by a one dimensional array in shared memory.
**/
class AccessorFlatArrays implements AccessorInterface {
    public static var PREDEFINED : Int = 0;
    public static var RAW : Int = 1;
    public static var FLOAT : Int = 2;
    public static var CALCULATED : Int = 3;

    @:allow(FieldAbstract.largeOperation)
    @:internal
    public var _data : Null<AccessorFlatArraysData>;

    private function new(data : Null<AccessorFlatArraysData>) {
        _data = data;
    }

    public static function wrap(data : AccessorFlatArraysData) : AccessorInterface {
        if (data.width == 1) {
            if (data.locationAttributes.count == 1) {
                return AccessorFlatArraysW1L1.wrap(data);
            } else {
                return AccessorFlatArraysW1.wrap(data);
            }
        } else if (data.height == 1) {
            if (data.locationAttributes.count == 1) {
                return AccessorFlatArraysH1L1.wrap(data);
            } else {
                return AccessorFlatArraysH1.wrap(data);
            }
        } else if (data.locationAttributes.count == 1) {
            return AccessorFlatArraysL1.wrap(data);
        } else {
            return AccessorFlatArraysGeneric.wrap(data);
        }
    }

    public function getRows() : Int {
        return _data.height;
    }

    public function getColumns() : Int {
        return _data.width;
    }

    public function getSpriteCount() : Int {
        return _data.maximumNumberOfSprites;
    }

    public function moveSprite(i : Int, j : Int) : Int {
        return i + j * _data.spriteAttributes.count;
    }

    public function getLocationAttributeCount() : Int {
        return _data.locationAttributes.count;
    }

    public function getSpriteAttributeCount() : Int {
        return _data.spriteAttributes.count;
    }

    public function directions() : NativeVector<Coordinate> {
        return _data.directions;
    }

    private inline static function gaa(i : Int, arr : NativeArray<NativeArray<String>>) : NativeArray<String> {
        #if js
            return cast js.Syntax.code("{0}[{1}]", arr, i);
        #else
            return arr[i];
        #end
    }

    private inline static function gfa(i : Int, arr : NativeArray<Float>) : Float {
        #if js
        return cast js.Syntax.code("{0}[{1}]", arr, i);
        #else
            return arr[i];
        #end
    }

    private inline static function gia(i : Int, arr : NativeArray<Int>) : Int {
        #if js
        return cast js.Syntax.code("{0}[{1}]", arr, i);
        #else
            return arr[i];
        #end
    }

    private inline static function gma(i : Int, arr : NativeArray<NativeStringMap<Int>>) : NativeStringMap<Int> {
        #if js
        return cast js.Syntax.code("{0}[{1}]", arr, i);
        #else
            return arr[i];
        #end
    }

    private inline static function gim(i : String, arr : NativeStringMap<Int>) : Int {
        #if js
            return cast js.Syntax.code("{0}[{1}]", arr, i);
        #else
            return arr.get(i);
        #end
    }

    private inline static function gsa(i : Int, arr : NativeArray<String>) : String {
        #if js
        return cast js.Syntax.code("{0}[{1}]", arr, i);
        #else
            return arr[i];
        #end
    }

    private inline static function sia(i : Int, arr : NativeArray<Int>, v : Int) : Void {
        #if js
            js.Syntax.code("{0}[{1}] = {2}", arr, i, v);
        #else
            arr[i] = i;
        #end
    }

    private inline static function ssa(i : Int, arr : NativeArray<String>, v : String) : Void {
        #if js
        js.Syntax.code("{0}[{1}] = {2}", arr, i, v);
        #else
            arr[i] = v;
        #end
    }

    public function getLocationAttributePosition(attribute : String) : Int {
        return gim(attribute, _data.locationAttributes.lookup);
    }

    public function getSpriteAttributePosition(attribute : String) : Int {
        return gim(attribute, _data.spriteAttributes.lookup);
    }    

    public function lookupLocationString(attribute : String, value : String) : Int {
        return lookupLocationStringDirect(getLocationAttributePosition(attribute), value);
    }

    public function lookupSpriteString(attribute : String, value : String) : Int {
        return lookupSpriteStringDirect(getSpriteAttributePosition(attribute), value);
    }

    public function lookupLocationStringDirect(attribute : Int, value : String) : Int {
        return gim(value, gma(attribute, _data.locationAttributes.valueLookup));
    }

    public function lookupSpriteStringDirect(attribute : Int, value : String) : Int {
        return gim(value, gma(attribute, _data.spriteAttributes.valueLookup));
    }

    public function reverseLocationString(attribute : String, value : Int) : String {
        return reverseLocationStringDirect(getLocationAttributePosition(attribute), value);
    }

    public function reverseSpriteString(attribute : String, value : Int) : String {
        return reverseSpriteStringDirect(getSpriteAttributePosition(attribute), value);
    }

    public function reverseLocationStringDirect(attribute : Int, value : Int) : String {
        return gsa(value, gaa(attribute, _data.locationAttributes.valueReverse));
    }

    public function reverseSpriteStringDirect(attribute : Int, value : Int) : String {
        return gsa(value, gaa(attribute, _data.spriteAttributes.valueReverse));
    }

    public function setLocationString(i : Int, attribute : String, value : String) : Void {
        setLocationStringDirect(i, getLocationAttributePosition(attribute), value);
    }

    public function setSpriteString(i : Int, attribute : String, value : String) : Void {
        setSpriteStringDirect(i, getSpriteAttributePosition(attribute), value);
    }

    public function setLocationStringDirect(i : Int, attribute : Int, value : String) : Void {
        setLocationIntegerDirect(i, attribute, lookupLocationStringDirect(attribute, value));
    }

    public function setSpriteStringDirect(i : Int, attribute : Int, value : String) : Void {
        setSpriteIntegerDirect(i, attribute, lookupSpriteStringDirect(attribute, value));
    }

    public function getLocationString(i : Int, attribute : String) : String {
        return getLocationStringDirect(i, getLocationAttributePosition(attribute));
    }

    public function getSpriteString(i : Int, attribute : String) : String {
        return getSpriteStringDirect(i, getSpriteAttributePosition(attribute));
    }

    public function getLocationStringDirect(i : Int, attribute : Int) : String {
        return reverseLocationStringDirect(attribute, getLocationIntegerDirect(i, attribute));
    }

    public function getSpriteStringDirect(i : Int, attribute : Int) : String {
        return reverseSpriteStringDirect(attribute, getSpriteIntegerDirect(i, attribute));
    }

    public function lookupLocationFloat(attribute : String, value : Float) : Int {
        return lookupLocationFloatDirect(getLocationAttributePosition(attribute), value);
    }

    public function lookupSpriteFloat(attribute : String, value : Float) : Int {
        return lookupSpriteFloatDirect(getSpriteAttributePosition(attribute), value);
    }

    public function lookupLocationFloatDirect(attribute : Int, value : Float) : Int {
        return Math.floor(value * gfa(attribute, _data.locationAttributes.divider));
    }

    public function lookupSpriteFloatDirect(attribute : Int, value : Float) : Int {
        return Math.floor(value * gfa(attribute, _data.spriteAttributes.divider));
    }

    public function reverseLocationFloat(attribute : String, value : Int) : Float {
        return reverseLocationFloatDirect(getLocationAttributePosition(attribute), value);
    }

    public function reverseSpriteFloat(attribute : String, value : Int) : Float {
        return reverseSpriteFloatDirect(getSpriteAttributePosition(attribute), value);
    }

    public function reverseLocationFloatDirect(attribute : Int, value : Int) : Float {
        return value / gfa(attribute, _data.locationAttributes.divider);
    }

    public function reverseSpriteFloatDirect(attribute : Int, value : Int) : Float {
        return value / gfa(attribute, _data.spriteAttributes.divider);
    }

    public function setLocationFloat(i : Int, attribute : String, value : Float) : Void {
        setLocationFloatDirect(i, getLocationAttributePosition(attribute), value);
    }

    public function setSpriteFloat(i : Int, attribute : String, value : Float) : Void {
        setSpriteFloatDirect(i, getSpriteAttributePosition(attribute), value);
    }

    public function setLocationFloatDirect(i : Int, attribute : Int, value : Float) : Void {
        setLocationIntegerDirect(i, attribute, lookupLocationFloatDirect(attribute, value));
    }

    public function setSpriteFloatDirect(i : Int, attribute : Int, value : Float) : Void {
        setSpriteIntegerDirect(i, attribute, lookupSpriteFloatDirect(attribute, value));
    }

    public function getLocationFloat(i : Int, attribute : String) : Float {
        return getLocationFloatDirect(i, getLocationAttributePosition(attribute));
    }

    public function getSpriteFloat(i : Int, attribute : String) : Float {
        return getSpriteFloatDirect(i, getSpriteAttributePosition(attribute));
    }

    public function getLocationFloatDirect(i : Int, attribute : Int) : Float {
        return reverseLocationFloatDirect(attribute, getLocationIntegerDirect(i, attribute));
    }

    public function getSpriteFloatDirect(i : Int, attribute : Int) : Float {
        return reverseSpriteFloatDirect(attribute, getSpriteIntegerDirect(i, attribute));
    }

    public function setLocationInteger(i : Int, attribute : String, value : Int) : Void {
        setLocationIntegerDirect(i, getLocationAttributePosition(attribute), value);
    }

    public function setSpriteInteger(i : Int, attribute : String, value : Int) : Void {
        setSpriteIntegerDirect(i, getSpriteAttributePosition(attribute), value);
    }

    public function setLocationIntegerDirect(i : Int, attribute : Int, value : Int) : Void {
        sia(i + attribute, _data.locationMemory, value);
    }

    public function setSpriteIntegerDirect(i : Int, attribute : Int, value : Int) : Void {
        sia(i + attribute, _data.spriteMemory, value);
    }

    public function getLocationInteger(i : Int, attribute : String) : Int {
        return getLocationIntegerDirect(i, getLocationAttributePosition(attribute));
    }

    public function getSpriteInteger(i : Int, attribute : String) : Int {
        return getSpriteIntegerDirect(i, getSpriteAttributePosition(attribute));
    }

    public function getLocationIntegerDirect(i : Int, attribute : Int) : Int {
        return gia(i + attribute, _data.locationMemory);
    }

    public function getSpriteIntegerDirect(i : Int, attribute : Int) : Int {
        return gia(i + attribute, _data.spriteMemory);
    }

    public function getLocationType(attribute : String) : Int {
        return getLocationTypeDirect(getLocationAttributePosition(attribute));
    }

    public function getSpriteType(attribute : String) : Int {
        return getSpriteTypeDirect(getSpriteAttributePosition(attribute));
    }

    public function getLocationTypeDirect(attribute : Int) : Int {
        return gia(attribute, _data.locationAttributes.type);
    }

    public function getSpriteTypeDirect(attribute : Int) : Int {
        return gia(attribute, _data.spriteAttributes.type);
    }

    public function getLocationAttribute(i : Int, attribute : String) : Any {
        return getLocationAttributeDirect(i, getLocationAttributePosition(attribute));
    }

    public function getLocationAttributeDirect(i : Int, attribute : Int) : Any {
        switch (getLocationTypeDirect(attribute)) {
            case 0:
                return getLocationStringDirect(i, attribute);
            case 1:
                return getLocationIntegerDirect(i, attribute);
            case 2:
                return getLocationFloatDirect(i, attribute);
            default:
                return null;
        }
    }

    public function getSpriteAttribute(i : Int, attribute : String) : Any {
        return getSpriteAttributeDirect(i, getSpriteAttributePosition(attribute));
    }

    public function getSpriteAttributeDirect(i : Int, attribute : Int) : Any {
        switch (getSpriteTypeDirect(attribute)) {
            case 0:
                return getSpriteStringDirect(i, attribute);
            case 1:
                return getSpriteIntegerDirect(i, attribute);
            case 2:
                return getSpriteFloatDirect(i, attribute);
            default:
                return null;
        }
    }

    public function setLocationAttribute(i : Int, attribute : String, value : Any) : Void {
        setLocationAttributeDirect(i, getLocationAttributePosition(attribute), value);
    }

    public function setLocationAttributeDirect(i : Int, attribute : Int, value : Any) : Void {
        switch (getLocationTypeDirect(attribute)) {
            case 0:
                setLocationStringDirect(i, attribute, value);
            case 1:
                setLocationIntegerDirect(i, attribute, value);
            case 2:
                setLocationFloatDirect(i, attribute, value);
        }
    }

    public function setSpriteAttribute(i : Int, attribute : String, value : Any) : Void {
        return setSpriteAttributeDirect(i, getSpriteAttributePosition(attribute), value);
    }

    public function setSpriteAttributeDirect(i : Int, attribute : Int, value : Any) : Void {
        switch (getSpriteTypeDirect(attribute)) {
            case 0:
                setSpriteStringDirect(i, attribute, value);
            case 1:
                setSpriteIntegerDirect(i, attribute, value);
            case 2:
                setSpriteFloatDirect(i, attribute, value);
        }
    }

    public function locationAttributesLookupCount() : Int {
        return _data.locationAttributes.count;
    }

    public function spriteAttributesLookupCount() : Int {
        return _data.spriteAttributes.count;
    }

    public function getSpriteLookupAttributes() : Iterator<String> {
        return _data.spriteAttributes.lookup.keys();
    }

    public function getLocationLookupAttributes() : Iterator<String> {
        return _data.locationAttributes.lookup.keys();
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

    public function getX(i : Int) : Int {
        return -1;
    }

    public function getY(i : Int) : Int {
        return -1;
    }

    public function moveRow(i : Int, y : Int) : Int {
        return -1;
    }

    public function moveColumn(i : Int, y : Int) : Int {
        return -1;
    }

    public function clearData() : Void {
        _data.data = null;
    }

    public function locationMemory() : Any {
        return _data.locationMemory;
    }

    public function spriteMemory() : Any {
        return _data.spriteMemory;
    }

    public function slice() : Int {
        return _data.slice;
    }

    public function sliceCount() : Int {
        return _data.sliceCount;
    }    

    public function locationMemoryLength() : Int {
        #if js
            return cast js.Syntax.code("{0}.length", _data.locationMemory);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            return _data.locationMemory.length();
        #end
    }

    public function locationAttributesDivider(i : Int) : Float {
        return _data.locationAttributes.divider.get(i);
    }

    public function spriteAttributesDivider(i : Int) : Float {
        return _data.spriteAttributes.divider.get(i);
    }

    public function lookupLocationValue(attribute : String, value : Any) : Int {
        return lookupLocationValueDirect(getLocationAttributePosition(attribute), value);
    }

    public function lookupLocationValueDirect(attribute : Int, value : Any) : Int {
        switch (getLocationTypeDirect(attribute)) {
            case 0:
                return lookupLocationStringDirect(attribute, value);
            case 1:
                return cast value;
            case 2:
                return lookupLocationFloatDirect(attribute, value);
            default:
                return cast value;
        }
    }

    public function lookupSpriteValue(attribute : String, value : Any) : Int {
        return lookupSpriteValueDirect(getSpriteAttributePosition(attribute), value);
    }

    public function lookupSpriteValueDirect(attribute : Int, value : Any) : Int {
        switch (getSpriteTypeDirect(attribute)) {
            case 0:
                return lookupSpriteStringDirect(attribute, value);
            case 1:
                return cast value;
            case 2:
                return lookupSpriteFloatDirect(attribute, value);
            default:
                return cast value;
        }
    }    
}