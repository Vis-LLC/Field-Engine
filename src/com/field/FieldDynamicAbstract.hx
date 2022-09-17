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

// TODO Next - Create superclass containing identical and near identical code
// TODO - Add write functions
// TODO - Add compile (or whatever) function to convert to a standard field


import com.field.LocationStandard;
import com.field.navigator.NavigatorCoreInterface;
import com.field.navigator.NavigatorGrid;

@:expose
@:nativeGen
/**
    Defines most of the functionality for the dynamic Field.
**/
class FieldDynamicAbstract<L, S> implements FieldInterface<L, S> implements FieldAdvancedInterface implements FieldSystemInterface<L, S> implements FieldDynamicInterface<L, S> {
    private static var _laterCount : Int = 0;
    private static var _laterSize : Int = 0;
    private static var _later : Int = 0;
    private static var _laters : NativeArray<Void->Void> = new NativeArray<Void->Void>();
    private static var _laterTimer : Null<haxe.Timer> = null;

    private var _id : String;
    #if !EXCLUDE_RENDERING
    private var _listeners : NativeObjectMap<NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void>> = new NativeObjectMap<NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void>>();
    #end
    private var _width : Int = 0;
    private var _height : Int = 0;
    private var _locations : NativeArray<NativeArray<L>> = null;
    private var _sprites : NativeArray<S> = null;
    private var _locationAttributeCount : Int = 0;
    private var _spriteAttributeCount : Int = 0;
    private var _locationAttributePredefinedCount : Int = 0;
    private var _locationAttributeNumericalCount : Int = 0;
    private var _spriteAttributePredefinedCount : Int = 0;
    private var _spriteAttributeNumericalCount : Int = 0;
    private var _maximumNumberOfSprites : Int = 0;
    private var _spritesAtLocation : Null<NativeIntMap<NativeIntMap<Int>>>;
    private var _getLoop : Int -> Int -> Coordinate;
    private var _loopReset : Int -> Int -> Bool;
    private var _defaultAccessor : AccessorInterface;
    private var _refresh : Null<Dynamic->Void> = null;
    private var _emptySpriteVector : NativeVector<S> = new NativeVector<S>(0);
    private var _lastMajorChange : Dynamic = null;

    private var _locationAllocator : com.field.manager.Allocator<L>;
    private var _spriteAllocator : com.field.manager.Allocator<S>;

    private var _locationAttributes : NativeStringMap<AttributeInfoDynamic> = new NativeStringMap<AttributeInfoDynamic>();
    private var _spriteAttributes : NativeStringMap<AttributeInfoDynamic> = new NativeStringMap<AttributeInfoDynamic>();
    private var _locationAttributeList : NativeArray<AttributeInfoDynamic> = new NativeArray<AttributeInfoDynamic>();
    private var _spriteAttributeList : NativeArray<AttributeInfoDynamic> = new NativeArray<AttributeInfoDynamic>();
    private var _locationLookupKeys : NativeArray<String> = new NativeArray<String>();
    private var _spriteLookupKeys : NativeArray<String> = new NativeArray<String>();

    private var _locationAttributesPredefinedList : NativeArray<AttributeInfoDynamic> = new NativeArray<AttributeInfoDynamic>();
    private var _locationAttributesNumericalList : NativeArray<AttributeInfoDynamic> = new NativeArray<AttributeInfoDynamic>();
    private var _spriteAttributesPredefinedList : NativeArray<AttributeInfoDynamic> = new NativeArray<AttributeInfoDynamic>();
    private var _spriteAttributesNumericalList : NativeArray<AttributeInfoDynamic> = new NativeArray<AttributeInfoDynamic>();

    private var _locationAttributesLookupList : NativeArray<AttributeInfoDynamic>;
    private var _spriteAttributesLookupList : NativeArray<AttributeInfoDynamic>;
    
    private var _locationAttributesListChanged : Bool = true;
    private var _spriteAttributesListChanged : Bool = true;

    private function new(options : FieldOptions<LocationDynamic, SpriteDynamic>) {
        initAllocators();
        var accessorData = new AccessorDynamicData(0, 0, false);
        accessorData.field = cast this;
        accessorData.fd = cast this;
        accessorData.sliceCount = 1;
        _defaultAccessor = AccessorDynamic.wrap(accessorData);
        _getLoop = getLoopDefault;
        _loopReset = loopResetDefault;

        // TODO - Add options.
        _navigator = NavigatorGrid.instance();        
    }

    public function getDefaultAccessor() : AccessorInterface {
        return _defaultAccessor;
    }

    public function transformX(x : Float, y : Float) : Float {
        return x;
    }

    public function transformY(x : Float, y : Float) : Float {
        return y;
    }

    public function getSpriteDirect(i : Int) : S {
        return _sprites.get(i);
    }

    public function getLocationDirect(i : Int) : L {
        return _locations.get(Math.floor(i / _width)).get(i % _width);
    }

    public function get(x : Int, y : Int) : L {
        var l : Null<L>;
        if (y < 0 || y >= _height || x < 0 || x >= _width) {
            l = null;
        } else {
            l = _locations.get(y).get(x);
        }
        if (l != null) {
            var u : Usable<L, Dynamic> = cast l;
            u.nowInUse();
        }
        return l;
    }

    public function getLocationCalculatedAttributes() : NativeStringMap<L->Any> {
        return null; // TODO - Add ability to make calculated attributes
    }

    public function getSpriteCalculatedAttributes() : NativeStringMap<S->Any> {
        return null; // TODO - Add ability to make calculated attributes
    }

    public function locationAttributeCount() : Int {
        return _locationAttributeCount;
    }
    
    public function spriteAttributeCount() : Int {
        return _spriteAttributeCount;
    }

    public function newLocationAttribute(name : String) : AttributeInfoDynamic {
        var attribute : AttributeInfoDynamic = new AttributeInfoDynamic();
        attribute.name = name;
        attribute.index = _locationAttributeCount;
        _locationAttributes.set(name, attribute);
        _locationAttributeList.push(attribute);
        _locationAttributeCount++;
        _locationAttributesListChanged = true;
        return attribute;
    }

    public function newSpriteAttribute(name : String) : AttributeInfoDynamic {
        var attribute : AttributeInfoDynamic = new AttributeInfoDynamic();
        attribute.name = name;
        attribute.index = _spriteAttributeCount;
        _spriteAttributes.set(name, attribute);
        _spriteAttributeList.push(attribute);
        _spriteAttributeCount++;
        _spriteAttributesListChanged = true;
        return attribute;
    }    

    public function getLocationAttributeDirect(attribute : Int) : AttributeInfoDynamic {
        if (_locationAttributesListChanged) {
            _locationAttributesLookupList = new NativeArray<AttributeInfoDynamic>();
            _locationAttributesLookupList = _locationAttributesLookupList.concat(_locationAttributesPredefinedList);
            _locationAttributesLookupList = _locationAttributesLookupList.concat(_locationAttributesNumericalList);
            _locationAttributesListChanged = false;
        }
        return _locationAttributesLookupList.get(attribute);
    }

    public function getSpriteAttributeDirect(attribute : Int) : AttributeInfoDynamic {
        if (_spriteAttributesListChanged) {
            _spriteAttributesLookupList = new NativeArray<AttributeInfoDynamic>();
            _spriteAttributesLookupList = _spriteAttributesLookupList.concat(_spriteAttributesPredefinedList);
            _spriteAttributesLookupList = _spriteAttributesLookupList.concat(_spriteAttributesNumericalList);
            _spriteAttributesListChanged = false;
        }        
        return _spriteAttributesLookupList.get(attribute);
    }

    public function getLocationAttribute(attribute : String) : AttributeInfoDynamic {
        return _locationAttributes.get(attribute);
    }

    public function getSpriteAttribute(attribute : String) : AttributeInfoDynamic {
        return _spriteAttributes.get(attribute);
    }

    public function spriteAttributeWithString(name : String, value : String) : Int {
        var info : Null<AttributeInfoDynamic> = _spriteAttributes.get(name);

        if (info == null) {
            info = newSpriteAttribute(name);
            info.type = 0;
            info.position = _spriteAttributePredefinedCount;
            info.minimum = 0;
            info.maximum = -1;
            info.values = new NativeStringMap<Int>();
            info.reverse = new NativeArray<String>();
            _spriteAttributePredefinedCount++;
            _spriteLookupKeys.push(name);
            _spriteAttributesPredefinedList.push(info);
        }

        var valueInt : Null<Int> = info.values.get(value);
        if (valueInt == null) {
            info.maximum++;
            info.values.set(value, info.maximum);
            info.reverse.push(value);
            valueInt = info.maximum;
        }

        return valueInt;
    }

    public function spriteAttributeWithInt(name : String, value : Int) : Int {
        var info : Null<AttributeInfoDynamic> = _spriteAttributes.get(name);

        if (info == null) {
            info = newSpriteAttribute(name);
            info.type = 1;
            info.position = _spriteAttributeNumericalCount;
            _spriteAttributeNumericalCount++;
            _spriteLookupKeys.push(name);
            _spriteAttributesNumericalList.push(info);
        }
        
        if (value > info.maximum) {
            info.maximum = value;
        }

        if (value < info.minimum) {
            info.minimum = value;
        }

        return value;
    }

    public function spriteAttributeWithFloat(name : String, value : Float) : Int {
        // TODO
        return -1;
    }

    public function spriteAttribute(name : String, value : Dynamic) : Int {
        var info : Null<AttributeInfoDynamic> = _spriteAttributes.get(name);

        if (info != null) {
            switch (info.type) {
                case 0:
                    return spriteAttributeWithString(name, cast value);
                case 1:
                    return spriteAttributeWithInt(name, cast value);
                case 2:
                    return spriteAttributeWithFloat(name, cast value);
                default:
                    return null;
            }
        } else {
            var sValue = Std.string(value);
            #if js
                if (js.Syntax.code("{0} === {1}", sValue, value)) {
            #else
                if (sValue == value) {
            #end
                return spriteAttributeWithString(name, cast value);
            } else {
                if (sValue.indexOf(".") < 0) {
                    return spriteAttributeWithInt(name, cast value);
                } else {
                    return spriteAttributeWithFloat(name, cast value);
                }
            }
        }
    }

    public function spriteAttributeDirect(attribute : Int, value : Dynamic) : Int {
        return spriteAttribute(_spriteAttributeList.get(attribute).name, value);
    }

    public function locationAttributeWithString(name : String, value : String) : Int {
        var info : Null<AttributeInfoDynamic> = _locationAttributes.get(name);

        if (info == null) {
            info = newLocationAttribute(name);
            info.type = 0;
            info.position = _locationAttributePredefinedCount;
            info.minimum = 0;
            info.maximum = -1;
            info.values = new NativeStringMap<Int>();
            info.reverse = new NativeArray<String>();
            _locationAttributePredefinedCount++;
            _locationLookupKeys.push(name);
            _locationAttributesPredefinedList.push(info);
        }

        var valueInt : Null<Int> = info.values.get(value);
        if (valueInt == null) {
            info.maximum++;
            info.values.set(value, info.maximum);
            info.reverse.push(value);
            valueInt = info.maximum;
        }
        
        return valueInt;
    }

    public function locationAttributeWithInt(name : String, value : Int) : Int {
        var info : Null<AttributeInfoDynamic> = _locationAttributes.get(name);

        if (info == null) {
            info = newLocationAttribute(name);
            info.type = 1;
            info.position = _locationAttributeNumericalCount;
            _locationAttributeNumericalCount++;
            _locationLookupKeys.push(name);
            info.maximum = value;
            info.minimum = value;
            _locationAttributesNumericalList.push(info);
        } else {
            if (value > info.maximum) {
                info.maximum = value;
            }
    
            if (value < info.minimum) {
                info.minimum = value;
            }
        }

        return value;
    }

    public function locationAttributeWithFloat(name : String, value : Float) : Int {
        // TODO
        return -1;
    }

    public function locationAttribute(name : String, value : Dynamic) : Int {
        var info : Null<AttributeInfoDynamic> = _locationAttributes.get(name);

        if (info != null) {
            switch (info.type) {
                case 0:
                    return locationAttributeWithString(name, cast value);
                case 1:
                    return locationAttributeWithInt(name, cast value);
                case 2:
                    return locationAttributeWithFloat(name, cast value);
                default:
                    return null;
            }
        } else {
            var sValue = Std.string(value);
            #if js
                if (js.Syntax.code("{0} === {1}", sValue, value)) {
            #else
                if (sValue == value) {
            #end
                return locationAttributeWithString(name, cast value);
            } else {
                if (sValue.indexOf(".") < 0) {
                    return locationAttributeWithInt(name, cast value);
                } else {
                    return locationAttributeWithFloat(name, cast value);
                }
            }
        }
    }

    public function locationAttributeDirect(attribute : Int, value : Dynamic) : Int {
        return locationAttribute(_locationAttributeList.get(attribute).name, value);
    }

    public function findLocationForSpriteIndex(i : Int) : L {
        var s : S = getSprite(i);
        var l : L = findLocationForSprite(s);
        doneWith(cast s);
        return l;
    }

    private static function later(f : Void -> Void, ?wu : WaitUntil = null) : Void {
        if (wu != null) {
            later(function () {
                f();
                wu.done();
            });
        } else {
            if (_later >= _laters.length()) {
                _laters.push(f);
                _later++;
            } else {
                _laters.set(_later++, f);
            }
        }
        if (_laterTimer == null) {
            _laterTimer = new haxe.Timer(0);
            _laterTimer.run = function () {
                _laterTimer.stop();
                _laterTimer = null;
                if (_later > 0) {
                    var fNow : NativeArray<Void->Void> = _laters;
                    _laterSize += _later;
                    _laterCount++;
                    _laters = new NativeArray<Void->Void>();
                    // TODO - Swap between just two?
                    _laters.preallocate(Math.ceil(_laterSize / _laterCount));
                    _later = 0;
                    for (f in fNow) {
                        if (f != null) {
                            f();
                        }
                    }
                }
            };
        }
    }

    public function findSprites(x1 : Int, y1 : Int, x2 : Int, y2 : Int) : NativeVector<S> {
        if (_sprites.length() <= 0) {
            return _emptySpriteVector;
        } else {
            var sFound : NativeArray<S> = new NativeArray<S>();
            var y : Int = y1;

            while (y <= y2)
            {
                var x : Int = x1;
                while (x <= x2)
                {
                    var l : L = get(x, y);
                    sFound = sFound.concat(findSpritesForLocation(l).toArray());
                    doneWith(cast l);
                    x++;
                }
                y++;
            }

            return sFound.toVector();
        }
    }

    public function findSpritesForLocation(l : L) : NativeVector<S> {
        var l1 : LocationInterface<Dynamic, L> = cast l;
        var found : NativeArray<S> = new NativeArray<S>();
        var set : Null<NativeIntMap<Int>> = _spritesAtLocation.get(l1.getI());
        if (set != null) {
            var keys : Iterator<Int> = cast set.keys();
            for (i in keys) {
                found.push(getSprite(i));
            }
        }
        return found.toVector();
    }

    public function findSpritesForLocations(l : NativeArray<L>) : NativeVector<S> {
        if (_sprites.length() <= 0) {
            return _emptySpriteVector;
        } else {
            var sFound = new NativeArray<S>();
            var i : Int = 0;

            while (i < l.length())
            {
                sFound = sFound.concat(findSpritesForLocation(l.get(i)).toArray());
                i++;
            }

            return sFound.toVector();
        }
    }

    public function findLocationForSprite(s : S) : L {
        var s2 : SpriteInterface<Dynamic, L> = cast s;
        var l : Int = _defaultAccessor.getSpriteInteger(_defaultAccessor.moveSprite(0, s2.getI()), "location");
        if (l == 0) {
            return null;
        } else {
            l--;
        }
        return get(l % _width, Math.floor(l / _width));
    }

    public function refreshSpriteLocations(callback : Void->Void) : Void {
        later(callback);
    }

    public function getSprite(i : Int) : S {
        var s : S = _sprites.get(i);
        var u : Usable<L, Dynamic> = cast s;
        u.nowInUse();
        return s;
    }

    public function getSubfieldsForLocation(l : L) : NativeVector<FieldInterface<L, S>> {
        // TODO
        return null;
    }

    public function getSubfieldForLocation(l : L, ?i : Int = 0) : FieldInterface<L, S> {
        // TODO
        return null;
    }

    public function getSubfieldsForSprite(s : S) : NativeVector<FieldInterface<L, S>> {
        // TODO
        return null;
    }

    public function getSubfieldForSprite(s : S, ?i : Int = 0) : FieldInterface<L, S> {
        // TODO
        return null;
    }

    public function toString() : String {
        // TODO - REWRITE
        return "";
    }

    public function getX() : Int {
        return 0;
    }

    public function getY() : Int {
        return 0;
    }

    public function width() : Int {
        return _width;
    }

    public function height() : Int {
        return _height;
    }

    public function decrementHeight() : Void {
        setHeight(_height - 1);
    }

    public function decrementWidth() : Void {
        setWidth(_width - 1);
    }

    public function incrementHeight() : Void {
        setHeight(_height + 1);
    }

    public function incrementWidth() : Void {
        setWidth(_width + 1);
    }

    private function setWidthI(row : NativeArray<L>, width : Int, rowI : Int) {
        var i : Int = row.length();
        while (width > row.length()) {
            var l : L = _locationAllocator.allocate();
            var u : Usable<Dynamic, L> = cast l;
            u.init(this, i, rowI);
            row.push(l);
            i = row.length();
            if (rowI == 0) {
                _width++;
            }
        }
    }

    public function setHeight(height : Int) : Void {
        if (_locations == null) {
            _locations = new NativeArray<NativeArray<L>>();
        }
        while (height > _locations.length()) {
            var row : NativeArray<L> = new NativeArray<L>();
            setWidthI(row, _width, _locations.length());
            _locations.push(row);
            _height++;
        }
        while (height < _locations.length()) {
            _locations.pop();
            _height--;
        }
    }

    public function setWidth(width : Int) : Void {
        var i : Int = 0;
        while (i < _locations.length()) {
            var row : NativeArray<L> = _locations.get(i);
            while (width < row.length()) {
                row.pop();
                _width--;
            }
            setWidthI(row, width, i);
            i++;
        }
    }

    public function setSize(width : Int, height : Int) : Void {
        setWidth(width);
        setHeight(height);
    }

    public function attributeFill(attribute : String, data : Any, callback : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void) : Void {
        smallOperation(function (local : AccessorInterface) {
            for (row in _locations) {
                for (l in row) {
                    var l1 : LocationInterface<Dynamic, L> = cast l;
                    l1.attribute(attribute, data);
                }
            }
            return null;
        }, null, callback, null, 1);
    }

    public function getLoop(x : Int, y : Int) : Coordinate {
        return _getLoop(x, y);
    }
    public function loopReset(x : Int, y : Int) : Bool {
        return _loopReset(x, y);
    }

    public function refresh(callback : Void->Void) : Void {
        if (_refresh != null) {
            _refresh(callback);
        }
    }

    #if !EXCLUDE_RENDERING
    public function addEventListenerFor(event : Event, listener : EventInfo<Dynamic, Dynamic, Dynamic>->Void) : Void {
        event.markHasListeners();
        var specific : Null<NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void>> = _listeners.get(event);
        if (specific == null) {
            specific = new NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void>();
            _listeners.set(event, specific);
        }
        specific.push(listener);
    }
    #end

    public function field() : FieldInterface<L, S> {
        return this;
    }

    public function equals(f : FieldInterface<L, S>) : Bool {
        return this == f.field();
    }

    public function addSubField(f : FieldInterface<L, S>, x : Int, y : Int) : Void {
        // TODO
    }

    public function id() : String {
        return _id;
    }

    public function fromJSON(options : FromJSONOptions) : Void {
        // TODO
    }

    public function toJSON(options : ToJSONOptions) : Void {
        // TODO
    }

    public function toJSONOptions() : ToJSONOptions {
        return new ToJSONOptions(this);
    }

    public function fromJSONOptions() : FromJSONOptions {
        return new FromJSONOptions(this);
    }    

    public function createSubField(id : String, x : Int, y : Int, width : Int, height : Int) : FieldInterface<L, S> {
        return null; // TODO
    }
    
    public function getParentField() : FieldInterface<L, S> {
        return this;
    }

    public function advanced() : FieldAdvancedInterface {
        return cast this;
    }

    public function smallOperation(f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, cleanDivide : Int) : Void {
        var start : Date = Date.now();
        var r : Any = null;
        var err : Any = null;
        try {
            _defaultAccessor.data(data);
            r = f(_defaultAccessor);
            _defaultAccessor.clearData();
        } catch (ex : Any) {
            err = ex;
        }
        later(function () {
            if (callback != null) {
                callback(r, err, 0, 1);
            }
            var end : Date = Date.now();
            var duration : Int = Math.floor(end.getTime() - start.getTime());
            var s : String = "Task Done Duration: " + duration;
            #if js
                js.html.Console.log(s);
            #elseif php
                php.Syntax.code("error_log({0})", s);
            #else
                // TODO
                throw "Not supported";
            #end
            if (whenDone != null) {
                var vectorResult = new NativeVector<Any>(1);
                var vectorError = new NativeVector<Any>(1);
                var vectorSlice = new NativeVector<Int>(1);
                vectorResult.set(0, r);
                vectorError.set(0, err);
                vectorSlice.set(0, 0);
                whenDone(vectorResult, vectorError, vectorSlice, 1);
            }
        });
    }
    
    public function scheduleOperation(f : AccessorInterface->Any, options : ScheduleOperationOptions<Dynamic>) : Void {
        later(function () {
            var o : NativeStringMap<Any> = options.toMap();
            options = null;
            var callback : Any->Any->Int->Int->Void = cast o.get("callback");
            var whenDone : Void->Void = o.get("whenDone");
            o.set("callback", null);
            o.set("whenDone", null);
            var field : FieldInterface<Dynamic, Dynamic> = cast o.get("field");
            o.set("field", null);
            var accessor : AccessorInterface = field.getDefaultAccessor();
            var o2 : NativeArray<NativeStringMap<Any>> = new NativeArray<NativeStringMap<Any>>();
            o2.push(o);
            accessor.data(o2.toVector());
            o2 = null;
            o = null;
            callback(f(accessor), null, 1, 0);
            accessor.clearData();
            if (whenDone != null) {
                whenDone();
            }
        });
    }

    public function setRefresh(f : Dynamic->Void) : Void {
        _refresh = refresh;
    }

    public function getSpritesAtLocation() : NativeIntMap<NativeIntMap<Int>> {
        return _spritesAtLocation;
    }
    
    public function convertToSubfield(parent : FieldInterface<L, S>, startX : Int, startY : Int) : FieldInterface<L, S> {
        return null; // TODO
    }

    public function getWrappedField() : FieldInterface<L, S> {
        return this;
    }

    public function getSubfields() : Null<NativeArray<FieldInterface<L, S>>> {
        return null; // TODO
    }

    public function getLocationAttributeCount() : Int {
        return _locationAttributeCount;
    }

    public function getSpriteAttributeCount() : Int {
        return _spriteAttributeCount;
    }

    public function getSpriteLookupAttributes() : Iterator<String> {
        return _locationLookupKeys.iterator();
    }
    
    public function getLocationLookupAttributes() : Iterator<String> {
        return _spriteLookupKeys.iterator();
    }

    public function locationAttributePredefinedCount() : Int {
        return _locationAttributePredefinedCount;
    }

    public function spriteAttributePredefinedCount() : Int {
        return _spriteAttributePredefinedCount;
    }

    public function getMaximumNumberOfSprites() : Int {
        return _maximumNumberOfSprites;
    }
    
    #if !EXCLUDE_RENDERING
    public function hasListeners(e : Event) : Bool {
        var listeners : Null<NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void>> = _listeners.get(e);
        return listeners != null && listeners.length() > 0;
    }
    #end

    private var _navigator : NavigatorCoreInterface;

    public function navigator() : NavigatorCoreInterface {
        return _navigator;
    }

    // Not useful for this version of a field
    public function registerClass(t : String) : Void { }
    public function registerFunction(f : String) : Void { }
    public function doneWithWorkers() : Void { }

    public function largeOperation(f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, cleanDivide : Int) : Void {
        smallOperation(f, callback, whenDone, data, cleanDivide);
    }

    public function getLocationMemory() : NativeVector<Int> {
        return null;
    }

    public function getSpriteMemory() : NativeVector<Int> {
        return null;
    }

    public function doneWith(o : Usable<L, S>) : Void {
        o.notInUse();
    }   

    public function lastMajorChange() : Dynamic {
        return _lastMajorChange;
    }    

    public function compact(callback : FieldInterface<L, S>->Void) : Void {
        var hasValue : Bool;
        var hasName : Bool;
        {
            var l : LocationDynamicAbstract<Dynamic, L, S> = cast this.get(0, 0);
            hasValue = l.hasValue();
            hasName = l.hasName();
            l.doneWith();
            if (hasValue || hasName) {
                var y : Int = 0;

                while (y < height()) {
                    var x : Int = 0;

                    while (x < width()) {
                        var l : LocationDynamicAbstract<Dynamic, L, S> = cast this.get(x, y);
                        if (hasValue) {
                            locationAttribute("value", l.value());
                        }
                        if (hasName) {
                            locationAttribute("name", l.name());
                        }
                        l.doneWith();
                        x++;
                    }
                    y++;
                }
            }
        }

        var fo : FieldOptions<Dynamic, Dynamic>;
        if (!hasValue) {
            fo = FieldStandard.options().width(_locations.get(0).length()).height(_locations.length());
        } else {
            fo = FieldTextValue.options().width(_locations.get(0).length()).height(_locations.length());
        }
        
        if (_sprites != null) {
            fo.maximumNumberOfSprites(_sprites.length());
        }

        {
            var stringAttr : NativeStringMap<NativeArray<String>> = new NativeStringMap<NativeArray<String>>();
            var numericAttr : NativeStringMap<Numerical> = new NativeStringMap<Numerical>();
            var i : Int = 0;
            while (i < _locationAttributeList.length()) {
                var attr : AttributeInfoDynamic = _locationAttributeList.get(i);
                switch (attr.type) {
                    case 0:
                        stringAttr.set(attr.name, attr.reverse);
                    case 1:
                        {
                            var n : NumericalOptions = new NumericalOptions();
                            n.max(attr.maximum);
                            numericAttr.set(attr.name, n.toNumerical());
                        }
                    case 2:
                        {
                            var n : NumericalOptions = new NumericalOptions();
                            n.max(attr.maximum);
                            n.digitsAfterDecimal(Math.floor(Math.pow(10, 1/attr.divider)));
                            numericAttr.set(attr.name, n.toNumerical());
                        }
                }
                i++;
            }

            fo.locationPredefinedAttributes(stringAttr);
            fo.locationNumericalAttributes(numericAttr);
        }

        {
            var field : FieldInterface<Dynamic, Dynamic>;
            if (!hasValue) {
                field = FieldStandard.create(cast fo);
            } else {
                field = FieldTextValue.create(cast fo);
            }
            fo = null;
            largeOperation(function (local : AccessorInterface) {
                var locationAttributeCount : Int = local.getLocationAttributeCount();
                var spriteAttributeCount : Int = local.getSpriteAttributeCount();
                var locationSliceSize : Int = Math.floor(local.getRows() * local.getColumns() / local.sliceCount());
                var locationSliceStart : Int = locationSliceSize * local.slice();
                var locationSliceEnd : Int = locationSliceStart + locationSliceSize;
                var spriteSliceSize : Int = Math.floor(local.getSpriteCount() / local.sliceCount());
                var spriteSliceStart : Int = spriteSliceSize * local.slice();
                var spriteSliceEnd : Int = spriteSliceStart + spriteSliceSize;
                var dest : AccessorInterface = cast local.data();
                var destI : Int = 0;
                var localI : Int = 0;
                var i : Int = 0;

                while (i < locationSliceEnd) {
                    var attribute : Int = 0;
                    while (attribute < locationAttributeCount) {
                        dest.setLocationAttributeDirect(destI, attribute, local.getLocationAttributeDirect(localI, attribute));
                        attribute++;
                    }
                    destI = dest.moveColumn(destI, 1);
                    localI = local.moveColumn(localI, 1);
                    i++;
                }

                i = 0;
                destI = 0;
                localI = 0;
                while (i < spriteSliceEnd) {
                    var attribute : Int = 0;
                    while (attribute < spriteAttributeCount) {
                        dest.setSpriteAttributeDirect(destI, attribute, local.getSpriteAttributeDirect(localI, attribute));
                        attribute++;
                    }
                    destI = dest.moveSprite(destI, 1);
                    localI = local.moveSprite(localI, 1);
                    i++;
                }

                return null;
            }, null, function (a : NativeVector<Any>, b : NativeVector<Any>, c : NativeVector<Int>, d : Int) : Void {
                callback(cast field);
            }, field.getDefaultAccessor(), null);                
        }
    }

    private function initAllocators() : Void {
        throw "Not implemented";
    }

    private function initManagers() : Void {
        throw "Not implemented";
    }

    public function newBlank() : FieldDynamicAbstract<L,S> {
        return null;
    }

    private function getLoopDefault(x : Int, y : Int) : Coordinate {
        return new Coordinate(x, y);
    }

    private function loopResetDefault(x : Int, y : Int) : Bool {
        return false;
    }
}