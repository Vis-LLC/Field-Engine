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

import com.field.navigator.NavigatorCoreInterface;

@:nativeGen
/**
    Wraps a Field.  This can be used to either perform operations on a Field automatically or to hide the actual implementation of the Field at runtime so that it can freely change.  It is recommended that a FieldWrapper be used for
    holding the actual Fields so that the implementation can in fact change if needed.
**/
class FieldWrapper<L, S> implements FieldInterface<L, S> implements FieldAdvancedInterface implements FieldSystemInterface<L, S> implements FieldDynamicInterface<L, S> {
    private var _field : FieldInterface<L, S>;

    public function new(field : FieldInterface<L, S>) {
        _field = field;
    }

    public function getX() : Int {
        return _field.getX();
    }

    public function getY() {
        return _field.getY();
    }

    public function transformX(x : Float, y : Float) : Float {
        return _field.transformX(x, y);
    }

    public function transformY(x : Float, y : Float) : Float {
        return _field.transformY(x, y);
    }    

    public function get(x : Int, y : Int) : L {
        return _field.get(x, y);
    }

    public function doneWith(o : Usable<L, S>) : Void {
        _field.doneWith(o);
    }

    public function findSprites(x1 : Int, y1 : Int, x2 : Int, y2 : Int) : NativeVector<S> {
        return _field.findSprites(x1, y1, x2, y2);
    }
    
    public function findLocationForSprite(s : S) {
        return _field.findLocationForSprite(s);
    }
    
    public function getSpritesAtLocation() : NativeIntMap<NativeIntMap<Int>> {
        return _field.getSpritesAtLocation();
    }

    public function refreshSpriteLocations(callback : Void -> Void) : Void {
        _field.refreshSpriteLocations(callback);
    }

    public function getSprite(i : Int) : S {
        return _field.getSprite(i);
    }

    public function toString() : String {
        return _field.toString();
    }

    public function getSubfieldsForLocation(l : L) : NativeVector<FieldInterface<L, S>> {
        return _field.getSubfieldsForLocation(l);
    }

    public function getSubfieldForLocation(l : L, ?i : Int = 0) : FieldInterface<L, S> {
        return _field.getSubfieldForLocation(l, i);
    }    

    public function getSubfieldsForSprite(s : S) : NativeVector<FieldInterface<L, S>>  {
        return _field.getSubfieldsForSprite(s);
    }

    public function getSubfieldForSprite(s : S, ?i : Int = 0) : FieldInterface<L, S> {
        return _field.getSubfieldForSprite(s, i);
    }

    public function convertToSubfield(parent : FieldInterface<L, S>, startX : Int, startY : Int) : FieldInterface<L, S> {
        var field : FieldSystemInterface<L, S> = cast _field;
        _field = field.convertToSubfield(parent, startX, startY);
        return this;
    }

    public function getLocationCalculatedAttributes() : NativeStringMap<L->Any> {
        return _field.getLocationCalculatedAttributes();
    }

    public function getSpriteCalculatedAttributes() : NativeStringMap<S->Any> {
        return _field.getSpriteCalculatedAttributes();
    }

    public function findLocationForSpriteIndex(i : Int) : L {
        return _field.findLocationForSpriteIndex(i);
    }

    public function getWrappedField() : FieldInterface<L, S> {
        var field : FieldSystemInterface<L, S> = cast _field;
        return field.getWrappedField();
    }

    public function getDefaultAccessor() : AccessorInterface {
        return _field.getDefaultAccessor();
    }

    public function width() : Int {
        return _field.width();
    }

    public function height() : Int {
        return _field.height();
    }

    public function getSubfields() : Null<NativeArray<FieldInterface<L, S>>> {
        var field : FieldSystemInterface<L, S> = cast _field;
        return field.getSubfields();
    }

    public function attributeFill(attribute : String, data : Any, callback : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void) : Void {
        _field.attributeFill(attribute, data, callback);
    }

    public function scheduleOperation(f : AccessorInterface->Any, options : ScheduleOperationOptions<Dynamic>) : Void {
        _field.advanced().scheduleOperation(f, options);
    }

    public function smallOperation(f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, cleanDivide : Int) : Void {
        _field.advanced().smallOperation(f, callback, whenDone, data, cleanDivide);
    }

    public function largeOperation(f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, cleanDivide : Int) : Void {
        _field.advanced().largeOperation(f, callback, whenDone, data, cleanDivide);
    }

    public function registerClass(t : String) : Void {
        _field.advanced().registerClass(t);
    }

    public function registerFunction(f : String) : Void {
        _field.advanced().registerFunction(f);
    }

    public function advanced() : FieldAdvancedInterface {
        return cast this;
    }

    public function findSpritesForLocation(l : L) : NativeVector<S> {
        return _field.findSpritesForLocation(l);
    }

    public function getLoop(x : Int, y : Int) : Coordinate {
        return _field.getLoop(x, y);
    }

    public function loopReset(x : Int, y : Int) : Bool {
        return _field.loopReset(x, y);
    }

    public function getMaximumNumberOfSprites() : Int {
        var field : FieldSystemInterface<L, S> = cast _field;
        return field.getMaximumNumberOfSprites();
    }

    public function getLocationMemory() : NativeVector<Int> {
        var field : FieldSystemInterface<L, S> = cast _field;
        return field.getLocationMemory();
    }

    public function getSpriteMemory() : NativeVector<Int> {
        var field : FieldSystemInterface<L, S> = cast _field;
        return field.getSpriteMemory();
    }

    public function getLocationAttributeCount() : Int {
        var field : FieldSystemInterface<L, S> = cast _field;
        return field.getLocationAttributeCount();
    }

    public function getSpriteAttributeCount() : Int {
        var field : FieldSystemInterface<L, S> = cast _field;
        return field.getSpriteAttributeCount();
    }  

    public function setRefresh(refresh : Dynamic->Void) : Void {
        _field.advanced().setRefresh(refresh);
    }

    public function refresh(callback : Void->Void) : Void {
        _field.refresh(callback);
    }

    #if !EXCLUDE_RENDERING
    public function addEventListenerFor(event : Event, listener : EventInfo<Dynamic, Dynamic, Dynamic>->Void) : Void {
        _field.addEventListenerFor(event, listener);
    }
    #end

    #if !EXCLUDE_RENDERING
    public function hasListeners(e : Event) : Bool {
        var field : FieldSystemInterface<L, S> = cast _field;
        return field.hasListeners(e);
    }
    #end

    public function field() : FieldInterface<L, S> {
        return _field.field();
    }

    public function equals(f : FieldInterface<L, S>) : Bool {
        return this.field() == f.field();
    }

    public function doneWithWorkers() : Void {
        _field.advanced().doneWithWorkers();
    }

    public function addSubField(f : FieldInterface<L, S>, x : Int, y : Int) : Void {
        _field.addSubField(f, x, y);
    }

    public function fromJSON(options : FromJSONOptions) : Void {
        _field.fromJSON(options);
    }

    public function toJSON(options : ToJSONOptions) : Void {
        _field.toJSON(options);
    }

    public function toJSONOptions() : ToJSONOptions {
        return _field.toJSONOptions();
    }    

    public function fromJSONOptions() : FromJSONOptions {
        return _field.fromJSONOptions();
    }    

    public function id() : String {
        return _field.id();
    }

    public function createSubField(id : String, x : Int, y : Int, width : Int, height : Int) : FieldInterface<L, S> {
        return _field.createSubField(id, x, y, width, height);
    }

    public function getParentField() : FieldInterface<L, S> {
        return _field.getParentField();
    }

    public function navigator() : NavigatorCoreInterface {
        var field : FieldSystemInterface<L, S> = cast _field;
        return field.navigator();
    }

    public function lastMajorChange() : Dynamic {
        return _field.lastMajorChange();
    }

    public function getSpriteDirect(i : Int) : S {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.getSpriteDirect(i);
    }

    public function getLocationDirect(i : Int) : L {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.getLocationDirect(i);
    }

    public function locationAttributeCount() : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.locationAttributeCount();
    }

    public function spriteAttributeCount() : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.spriteAttributeCount();
    }

    public function locationAttributePredefinedCount() : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.locationAttributePredefinedCount();
    }

    public function spriteAttributePredefinedCount() : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.spriteAttributePredefinedCount();
    }

    public function getSpriteLookupAttributes() : Iterator<String> {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.getSpriteLookupAttributes();
    }

    public function getLocationLookupAttributes() : Iterator<String> {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.getLocationLookupAttributes();
    }

    public function newLocationAttribute(name : String) : AttributeInfoDynamic {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.newLocationAttribute(name);
    }

    public function newSpriteAttribute(name : String) : AttributeInfoDynamic {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.newSpriteAttribute(name);
    }

    public function getLocationAttributeDirect(attribute : Int) : AttributeInfoDynamic {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.getLocationAttributeDirect(attribute);
    }

    public function getSpriteAttributeDirect(attribute : Int) : AttributeInfoDynamic {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.getSpriteAttributeDirect(attribute);
    }

    public function getLocationAttribute(attribute : String) : AttributeInfoDynamic {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.getLocationAttribute(attribute);
    }

    public function getSpriteAttribute(attribute : String) : AttributeInfoDynamic {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.getSpriteAttribute(attribute);
    }

    public function spriteAttributeWithString(name : String, value : String) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.spriteAttributeWithString(name, value);
    }

    public function spriteAttributeWithInt(name : String, value : Int) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.spriteAttributeWithInt(name, value);
    }

    public function spriteAttributeWithFloat(name : String, value : Float) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.spriteAttributeWithFloat(name, value);
    }

    public function spriteAttribute(name : String, value : Dynamic) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.spriteAttribute(name, value);
    }

    public function spriteAttributeDirect(attribute : Int, value : Dynamic) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.spriteAttributeDirect(attribute, value);
    }
    
    public function locationAttributeWithString(name : String, value : String) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.locationAttributeWithString(name, value);
    }

    public function locationAttributeWithInt(name : String, value : Int) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.locationAttributeWithInt(name, value);
    }

    public function locationAttributeWithFloat(name : String, value : Float) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.locationAttributeWithFloat(name, value);
    }

    public function locationAttribute(name : String, value : Dynamic) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.locationAttribute(name, value);
    }

    public function locationAttributeDirect(attribute : Int, value : Dynamic) : Int {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        return fd.locationAttributeDirect(attribute, value);
    }

    public function decrementHeight() : Void {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        fd.decrementHeight();
    }

    public function decrementWidth() : Void {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        fd.decrementWidth();
    }

    public function incrementHeight() : Void {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        fd.incrementHeight();
    }
    
    public function incrementWidth() : Void {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        fd.incrementWidth();
    }

    public function compact(callback : FieldInterface<L, S>->Void) : Void {
        var fd : FieldDynamicInterface<L, S> = cast _field;
        fd.compact(function (f : FieldInterface<L, S>) {
            _field = f;
            if (callback != null) {
                callback(this);
            }
        });
    }
}