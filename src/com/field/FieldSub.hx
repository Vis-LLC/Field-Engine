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
    A Field that is contained within another Field.
**/
class FieldSub<L, S> implements FieldInterface<L, S> implements FieldAdvancedInterface implements FieldSystemInterface<L, S> {
    private var _parent : FieldInterface<L, S>;
    private var _startX : Int;
    private var _startY : Int;
    private var _width : Int;
    private var _height: Int;
    private var _id : String;

    public function new(parent : FieldInterface<L, S>, startX : Int, startY : Int, width : Int, height : Int, id : String) {
        _parent = parent;
        _startX = startX;
        _startY = startY;
        _width = width;
        _height = height;
        _id = id;
    }

    public function transformX(x : Float, y : Float) : Float {
        return _parent.transformX(x, y);
    }

    public function transformY(x : Float, y : Float) : Float {
        return _parent.transformY(x, y);
    }

    private function clip(x, y) : Bool {
        return (x < 0 || y < 0 || x >= _width || y >= _height);
    }

    public function getX() : Int {
        return _startX;
    }

    public function getY() : Int{
        return _startY;
    }

    public function get(x : Int, y : Int) : L {
        if (clip(x, y)) {
            return null;
        } else {
            return _parent.get(_startX + x, _startY + y);
        }
    }

    public function doneWith(o : Usable<L, S>) : Void {
        _parent.doneWith(o);
    }

    public function findSprites(x1 : Int, y1 : Int, x2 : Int, y2 : Int) : NativeVector<S> {
        if (clip(x1, y1) || clip(x2, y2)) {
            return null;
        } else {
            return _parent.findSprites(x1 + _startX, y1 + _startY, x2 + _startX, y2 + _startY);
        }
    }
    
    public function findLocationForSprite(s : S) {
        var l : L = _parent.findLocationForSprite(s);
        var l2 : LocationInterface<Dynamic, L> = cast l;        
        if (clip(l2.getX(this), l2.getY(this))) {
            l2.doneWith();
            return null;
        } else {
            return l;
        }
    }
    
    public function getSpritesAtLocation() : NativeIntMap<NativeIntMap<Int>> {
        // TODO
        return _parent.getSpritesAtLocation();
    }

    public function refreshSpriteLocations(callback : Void -> Void) : Void {
        return _parent.refreshSpriteLocations(callback);
    }

    public function getSprite(i : Int) : S {
        return _parent.getSprite(i);
    }

    public function toString() : String {
        return null;
    }

    public function getSubfieldsForLocation(l : L) : NativeVector<FieldInterface<L, S>>  {
        return _parent.getSubfieldsForLocation(l);
    }

    public function getSubfieldForLocation(l : L, ?i : Int = 0) : FieldInterface<L, S> {
        return _parent.getSubfieldForLocation(l, i);
    }

    public function getSubfieldsForSprite(s : S) : NativeVector<FieldInterface<L, S>>  {
        return _parent.getSubfieldsForSprite(s);
    }

    public function getSubfieldForSprite(s : S, ?i : Int = 0) : FieldInterface<L, S> {
        return _parent.getSubfieldForSprite(s, i);
    }

    public function getLocationCalculatedAttributes() : NativeStringMap<L->Any> {
        return _parent.getLocationCalculatedAttributes();
    }

    public function getSpriteCalculatedAttributes() : NativeStringMap<S->Any> {
        return _parent.getSpriteCalculatedAttributes();
    }

    public function findLocationForSpriteIndex(i : Int) : L {
        var l : L = _parent.findLocationForSpriteIndex(i);
        var l2 : LocationInterface<Dynamic, L> = cast l;

        if (clip(l2.getX(this), l2.getY(this))) {
            l2.doneWith();
            return null;
        } else {
            return l;
        }
    }

    public function getDefaultAccessor() : AccessorInterface {
        return _parent.getDefaultAccessor();
    }

    public function convertToSubfield(parent : FieldInterface<L, S>, startX : Int, startY : Int) : FieldInterface<L, S> {
        return new FieldSub<L, S>(parent, startX, startY, _width, _height, _id);
    }

    public function getWrappedField() : FieldInterface<L, S> {
        return this;
    }

    public function width() : Int {
        return _width;
    }

    public function height() : Int {
        return _height;
    }

    public function getSubfields() : Null<NativeArray<FieldInterface<L, S>>> {
        // TODO
        var field : FieldSystemInterface<L, S> = cast _parent;
        return field.getSubfields();
    }    

    public function attributeFill(attribute : String, data : Any, callback : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void) : Void {
        // TODO
        _parent.attributeFill(attribute, data, callback);
    }    

    public function scheduleOperation(f : AccessorInterface->Any, options : ScheduleOperationOptions<Dynamic>) : Void {
        // TODO
        _parent.advanced().scheduleOperation(f, options);
    }

    public function smallOperation(f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, cleanDivide : Int) : Void {
        _parent.advanced().smallOperation(f, callback, whenDone, data, cleanDivide);
    }

    public function largeOperation(f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, cleanDivide : Int) : Void {
        _parent.advanced().largeOperation(f, callback, whenDone, data, cleanDivide);
    }

    public function registerClass(t : String) : Void {
        _parent.advanced().registerClass(t);
    }

    public function registerFunction(f : String) : Void {
        _parent.advanced().registerFunction(f);
    }

    public function advanced() : FieldAdvancedInterface {
        return cast this;
    }

    public function findSpritesForLocation(l : L) : NativeVector<S> {
        return _parent.findSpritesForLocation(l);
    }

    public function getLoop(x : Int, y : Int) : Coordinate {
        return _parent.getLoop(x, y);
    }

    public function loopReset(x : Int, y : Int) : Bool {
        return _parent.loopReset(x, y);
    }    

    public function getMaximumNumberOfSprites() : Int {
        var field : FieldSystemInterface<L, S> = cast _parent;
        return field.getMaximumNumberOfSprites();
    }

    public function getLocationMemory() : NativeVector<Int> {
        var field : FieldSystemInterface<L, S> = cast _parent;
        return field.getLocationMemory();
    }

    public function getSpriteMemory() : NativeVector<Int> {
        var field : FieldSystemInterface<L, S> = cast _parent;
        return field.getSpriteMemory();
    }

    public function getLocationAttributeCount() : Int {
        var field : FieldSystemInterface<L, S> = cast _parent;
        return field.getLocationAttributeCount();
    }

    public function getSpriteAttributeCount() : Int {
        var field : FieldSystemInterface<L, S> = cast _parent;
        return field.getSpriteAttributeCount();
    }  

    public function setRefresh(refresh : Dynamic->Void) : Void {
        _parent.advanced().setRefresh(refresh);
    }

    public function refresh(callback : Void->Void) : Void {
        _parent.refresh(callback);
    }

    public function addEventListenerFor(event : Event, listener : EventInfo<Dynamic, Dynamic, Dynamic>->Void) : Void {
        _parent.addEventListenerFor(event, listener);
    }    

    public function hasListeners(e : Event) : Bool {
        var field : FieldSystemInterface<L, S> = cast _parent;
        return field.hasListeners(e);
    }

    public function field() : FieldInterface<L, S> {
        return this;
    }

    public function equals(f : FieldInterface<L, S>) : Bool {
        return this == f.field();
    }

    public function doneWithWorkers() : Void {
    }

    public function addSubField(f : FieldInterface<L, S>, x : Int, y : Int) : Void {
        // TODO
        _parent.addSubField(f, x, y);
    }

    public function fromJSON(options : FromJSONOptions) : Void {
        // TODO
    }

    public function toJSON(options : ToJSONOptions) : Void {
        // TODO;
    }

    public function toJSONOptions() : ToJSONOptions {
        return _parent.toJSONOptions();
    }

    public function fromJSONOptions() : FromJSONOptions {
        return _parent.fromJSONOptions();
    }

    public function id() : String {
        return _id;
    }    

    public function createSubField(id : String, x : Int, y : Int, width : Int, height : Int) : FieldInterface<L, S> {
        return _parent.createSubField(id, x, y, width, height);
    }    

    public function getParentField() : FieldInterface<L, S> {
        return _parent;
    }    

    public function navigator() : NavigatorCoreInterface {
        var field : FieldSystemInterface<L, S> = cast _parent;
        return field.navigator();
    }

    public function lastMajorChange() : Dynamic {
        return null;
    }    
}