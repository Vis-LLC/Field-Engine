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

import com.field.manager.Pool;
import com.field.navigator.NavigatorCoreInterface;
import com.field.navigator.NavigatorGrid;
import com.field.navigator.NavigatorHex;

@:expose
@:nativeGen
/**
    Implements most of the functionality for a standard Field.
**/
class FieldAbstract<L, S> implements FieldInterface<L, S> implements FieldAdvancedInterface implements FieldSystemInterface<L, S> {
    private static var _laterCount : Int = 0;
    private static var _laterSize : Int = 0;
    private static var _later : Int = 0;
    private static var _laters : NativeArray<Void->Void> = new NativeArray<Void->Void>();
    private static var _laterTimer : Null<haxe.Timer> = null;

    private var _scheduledOperations : Null<NativeArray<AccessorInterface->Any>>;
    private var _scheduledOptions : Null<NativeArray<ScheduleOperationOptions<Dynamic>>>;

    private var _id : String;
    private var _width : Int;
    private var _height : Int;
    private var _maximumNumberOfSprites : Int;
    
    private var _locationAllocator : com.field.manager.Allocator<L>;
    private var _spriteAllocator : com.field.manager.Allocator<S>;
    private var _locationManager : com.field.manager.Manager<L, L, S>;
    private var _spriteManager : com.field.manager.Manager<S, L, S>;    
    private var _locationCalculatedAttributes : Null<NativeStringMap<L->Any>>;
    private var _spriteCalculatedAttributes : Null<NativeStringMap<S->Any>>;
    private var _locationClass : Null<String>;
    private var _spriteClass : Null<String>;
    private var _locationPredefinedAttributes : Null<NativeStringMap<NativeVector<String>>>;
    private var _spritePredefinedAttributes : Null<NativeStringMap<NativeVector<String>>>;
    private var _locationNumericalAttributes : Null<NativeStringMap<Numerical>>;
    private var _spriteNumericalAttributes : Null<NativeStringMap<Numerical>>;
    private var _spritesAtLocation : Null<NativeIntMap<NativeIntMap<Int>>>;
    private var _locationAttributes = new AccessorFlatArraysAttributes();
    private var _spriteAttributes = new AccessorFlatArraysAttributes();

    private var _discardedLocations : Pool<L>;
    private var _locations : Pool<L>;
    private var _discardedSprites : Pool<S>;
    private var _sprites : Pool<S>;
    private var _defaultAccessor : AccessorInterface;
    // TODO - Use a shared pool and remove field's accessors when disposing
    // Subpool?
    // Keep track of recent accessors, initialize those?
    // Send ids with null values to remove?
    private static var _sharedPool : Null<com.field.workers.WorkerThreadPoolInterface> = null;
    private var _pool : Null<com.field.workers.WorkerThreadPoolInterface> = null;
    private var _subFields : Null<NativeArray<FieldInterface<L, S>>> = null;
    private var _emptySpriteVector : NativeVector<S> = new NativeVector<S>(0);
    private var _refresh : Null<Dynamic->Void> = null;
    #if !EXCLUDE_RENDERING
    private var _listeners : NativeObjectMap<NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void>> = new NativeObjectMap<NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void>>();
    #end

    private var _getLoop : Int -> Int -> Coordinate;
    private var _loopReset : Int -> Int -> Bool;

    // TODO - For different platforms - NativeVector<Int> is placeholder that works for JS
    private var _memoryBuffer : Null<NativeVector<Int>> = null;
    private var _isShared : Bool;
    private var _locationArrayView : Null<NativeVector<Int>> = null;
    private var _spriteArrayView : Null<NativeVector<Int>> = null;
    private var _gridType : Int;

    private static function withDefault(v : Any, d : Any) : Any {
        if (v == null) {
            return d;
        } else {
            return v;
        }
    }

    private function new(fo : FieldOptions<L, S>) {
        var fom : NativeStringMap<Any> = fo.toMap();
        fo = null;

        _width = cast fom.get("width");
        _height = cast fom.get("height");
        _maximumNumberOfSprites = cast fom.get("maximumNumberOfSprites");
        _spriteAllocator = cast fom.get("spriteAllocator");
        _locationAllocator = cast fom.get("locationAllocator");
        _spriteManager = cast fom.get("spriteManager");
        _locationManager = cast fom.get("locationManager");
        _spriteNumericalAttributes = cast fom.get("spriteNumericalAttributes");
        _locationCalculatedAttributes = cast fom.get("locationCalculatedAttributes");
        _spriteCalculatedAttributes = cast fom.get("spriteCalculatedAttributes");
        _locationClass = cast fom.get("locationClass");
        _spriteClass = cast fom.get("spriteClass");
        _locationPredefinedAttributes = cast fom.get("locationPredefinedAttributes");
        _spritePredefinedAttributes = cast fom.get("spritePredefinedAttributes");
        _locationNumericalAttributes = cast fom.get("locationNumericalAttributes");
        _spriteNumericalAttributes = cast fom.get("spriteNumericalAttributes");
        _gridType = cast withDefault(fom.get("gridType"), 1);

        _id = cast fom.get("id");
        if (_id == null) {
            _id = "1";
        }

        switch (cast fom.get("getLoop")) {
            case 0:
                _getLoop = getLoopDefault;
            case 1:
                _getLoop = verticalLoop;
            case 2:
                _getLoop = horizontalLoop;
            case 3:
                _getLoop = horizontalVerticalLoop;
            default:
                _getLoop = getLoopDefault;
        }

        switch (cast fom.get("loopReset")) {
            case 0:
                _loopReset = loopResetDefault;
            case 1:
                _loopReset = loopResetWhenDoubled;
            default:
                _loopReset = loopResetDefault;
        }

        fom = null;

        if (_maximumNumberOfSprites == null) {
            _maximumNumberOfSprites = 0;
        }

        if (_maximumNumberOfSprites > 0) {
            if (_spriteNumericalAttributes == null) {
                _spriteNumericalAttributes = new NativeStringMap<Numerical>();
            }
            {
                var location : String = "location";
                if (_spriteNumericalAttributes.get(location) == null) {
                    _spriteNumericalAttributes.set(location, new Numerical(_width * _height));
                }
            }
        }

        // TODO - Add additional options.
        switch (_gridType) {
            case 3:
                _navigator = NavigatorHex.instance();
            default:
                _navigator = NavigatorGrid.instance();
        }

        initAllocators();
        initManagers();
        reallocate();

        _locations = _locationManager.preallocate(_locationAllocator, this, _width, _height);
        _discardedLocations = _locationManager.allocateDiscard(_locationAllocator);
        _sprites = _spriteManager.preallocate(_spriteAllocator, this, _maximumNumberOfSprites, 1);
        _discardedSprites = _spriteManager.allocateDiscard(_spriteAllocator);
    }

    public function transformX(x : Float, y : Float) : Float {
        return x;
    }

    public function transformY(x : Float, y : Float) : Float {
        return y;
    }

    private function initAllocators() : Void {
        throw "Not implemented";
    }

    private function initManagers() : Void {
        throw "Not implemented";
    }

    private function reallocateI() : Void {
        var bUseSharedArrayBuffer : Bool = false;
        var bUseArrayBuffer : Bool = false;
        var locationSize : Int = 0;
        var spriteSize : Int = 0;
        var locationsSize : Int = 0;
        var spritesSize : Int = 0;
        var locationSigned : Bool = null;
        var spriteSigned : Bool = null;

        var defaultAccessorData : AccessorFlatArraysData;
        
        if (_defaultAccessor == null) {
            defaultAccessorData = new AccessorFlatArraysData(0, 1, false);
            defaultAccessorData.locationAttributes = _locationAttributes;
            defaultAccessorData.spriteAttributes = _spriteAttributes;
            defaultAccessorData.directions = navigator().directionsForAccessor();
        } else {
            defaultAccessorData = cast _defaultAccessor.data();
        }

        // TODO - Add additional array options for Java, C#, etc.
        #if js
            try {
                bUseSharedArrayBuffer = !!js.Lib.eval("SharedArrayBuffer");
            } catch (ex : Any) { }

            if (!bUseSharedArrayBuffer) {
                try {
                    bUseArrayBuffer = !!js.Lib.eval("ArrayBuffer");
                } catch (ex : Any) { }
            }

            if (bUseSharedArrayBuffer || bUseArrayBuffer) {
                var spriteViewType : Any = null;
                var locationViewType : Any = null;

                var i : Int = 0;
                while (i <= 1) {
                    var size : Int = 0;
                    var signed : Bool = false;
                    var viewType : Any = null;
                    var attr : AccessorFlatArraysAttributes = null;
                    switch (i) {
                        case 0:
                            attr = _locationAttributes;
                        case 1:
                            attr = _spriteAttributes;
                    }
                    switch (attr.size) {
                        case 7:
                            size = 1;
                            viewType = js.Syntax.code("Int8Array");
                            signed = true;
                        case 8:
                            size = 1;
                            viewType = js.Syntax.code("Uint8Array");
                            signed = false;
                        case 15:
                            size = 2;
                            viewType = js.Syntax.code("Int16Array");
                            signed = true;
                        case 16:
                            size = 2;
                            viewType = js.Syntax.code("Uint16Array");
                            signed = false;
                        case 31:
                            size = 4;
                            viewType = js.Syntax.code("Int32Array");
                            signed = true;
                        case 32:
                            size = 4;
                            viewType = js.Syntax.code("Uint32Array");
                            signed = false;
                        case 64:
                            size = 8;
                            viewType = js.Syntax.code("BigInt64Array");
                            signed = true;
                    }

                    switch (i) {
                        case 0:
                            locationSize = size;
                            locationSigned = signed;
                            locationViewType = viewType;
                        case 1:
                            spriteSize = size;
                            spriteSigned = signed;
                            spriteViewType = viewType;
                    }						

                    i++;
                }

                locationsSize = defaultAccessorData.locationAttributes.count * _width * _height;
                spritesSize = defaultAccessorData.spriteAttributes.count * _maximumNumberOfSprites;
                if (bUseSharedArrayBuffer) {
                    _memoryBuffer = js.Syntax.code("new SharedArrayBuffer(Math.ceil(({0}) / 8) * 8 + Math.ceil(({1}) / 8) * 8);", locationsSize * locationSize, spritesSize * spriteSize);
                    _isShared = true;
                } else {
                    _memoryBuffer = js.Syntax.code("new ArrayBuffer(Math.ceil(({0}) / 8) * 8 + Math.ceil(({1}) / 8) * 8);", locationsSize * locationSize, spritesSize * spriteSize);
                    _isShared = false;
                }
                
                _locationArrayView = js.Syntax.code("new {0}({1}, 0, {2});", locationViewType, _memoryBuffer, locationsSize);
                _spriteArrayView = js.Syntax.code("new {0}({1}, Math.ceil({2} / 8) * 8, {3});", spriteViewType, _memoryBuffer, locationsSize * locationSize, spritesSize);
            }
        #end

        if (!bUseSharedArrayBuffer && !bUseArrayBuffer) {
            _memoryBuffer = null;
            _locationArrayView = new NativeVector<Int>(defaultAccessorData.locationAttributes.count * _width * _height);
            _spriteArrayView = new NativeVector<Int>(defaultAccessorData.spriteAttributes.count * _maximumNumberOfSprites);
        }

        #if js
            js.Syntax.code("{0}.fill(0, 0, {0}.length)", _locationArrayView);
            js.Syntax.code("{0}.fill(0, 0, {0}.length)", _spriteArrayView);
        #elseif php
            var i : Int = 0;
            while (i < _locationArrayView.length()) {
                _locationArrayView.set(i, 0);
                i++;
            }
            i = 0;
            while (i < _spriteArrayView.length()) {
                _spriteArrayView.set(i, 0);
                i++;
            }
        #else
            // TODO
            throw "Not supported";
        #end

        _spritesAtLocation = new NativeIntMap<NativeIntMap<Int>>();

        defaultAccessorData.raw = _memoryBuffer;
        defaultAccessorData.locationMemory  = _locationArrayView;
        defaultAccessorData.spriteMemory  = _spriteArrayView;
        defaultAccessorData.locationSize = locationSize;
        defaultAccessorData.spriteSize = spriteSize;
        defaultAccessorData.locationSigned = locationSigned;
        defaultAccessorData.spriteSigned = spriteSigned;
        defaultAccessorData.data = null;
        defaultAccessorData.maximumNumberOfSprites = _maximumNumberOfSprites;
        defaultAccessorData.height = _height;
        defaultAccessorData.width = _width;
        _defaultAccessor = AccessorFlatArrays.wrap(defaultAccessorData);
    }

    private function reallocate() : Void {
        if (_width == 0 || _height == 0) {
            return;
        } else if (_width > 0 && _height > 0) {
            updateAttributeCount(_locationAttributes, _locationPredefinedAttributes, _locationNumericalAttributes, _locationCalculatedAttributes);
            updateAttributeCount(_spriteAttributes, _spritePredefinedAttributes, _spriteNumericalAttributes, _spriteCalculatedAttributes);
            reallocateI();
        }
    }

    function updateAttributeCount<T>(attr : AccessorFlatArraysAttributes, predefinedAttributes : Null<NativeStringMap<NativeVector<String>>>, numericalAttributes : Null<NativeStringMap<Numerical>>, calculatedAttributes : Null<NativeStringMap<T->Any>>) : Void {
        attr.count = 0;
        attr.lookup = new NativeStringMap<Int>();
        attr.size = 0;

        var attrReverse : NativeArray<String> = new NativeArray<String>();
        var attrType : NativeArray<Int> = new NativeArray<Int>();
        var attrDivider : NativeArray<Float> = new NativeArray<Float>();
        var attrValueLookup : NativeArray<NativeStringMap<Int>> = new NativeArray<NativeStringMap<Int>>();
        var attrValueReverse : NativeArray<NativeVector<String>> = new NativeArray<NativeVector<String>>();

        if (predefinedAttributes != null) {
            for (i in predefinedAttributes.keys()) {
                attr.lookup.set(i, attr.count);
                attrType.set(attr.count, 0);
                attrReverse.push(i);

                var values : NativeStringMap<Int> = new NativeStringMap<Int>();
                var reverse : NativeVector<String> = predefinedAttributes.get(i);
                attrValueLookup.push(values);
                attrValueReverse.push(reverse);
                var j : Int = 0;
                while (j < reverse.length()) {
                    values.set(reverse.get(j), j);
                    j++;
                }
                if (predefinedAttributes.get(i).length() > attr.size) {
                    attr.size = predefinedAttributes.get(i).length();
                }
                attr.count++;
            }
        }

        if (numericalAttributes != null) {
            for (i in numericalAttributes.keys()) {
                attr.lookup.set(i, attr.count);
                
                var o : Numerical = numericalAttributes.get(i);
                var max : Float;
                var digitsAfterDecimal : Int;

                max = o.max;
                digitsAfterDecimal = o.digitsAfterDecimal;

                if (digitsAfterDecimal != null && digitsAfterDecimal != 0) {
                    attrType.set(attr.count, 2);
                    var divider = Math.pow(10, digitsAfterDecimal);
                    attrDivider.set(attr.count, divider);
                    max *= divider;
                    if (max > attr.size) {
                        attr.size = Math.floor(max);
                    }
                } else {
                    attrType.set(attr.count, 1);
                    if (max > attr.size) {
                        attr.size = Math.floor(max);
                    }
                }

                attr.count++;
            }
        }

        if (calculatedAttributes != null) {
            for (i in calculatedAttributes.keys()) {
                attrType.set(attr.count, 3);
            }
        }

        if (attr.size <= 127) {
            attr.size = 7;
        } else if (attr.size <= 255) {
            attr.size = 8;
        } else if (attr.size <= 32767) {
            attr.size = 15;
        } else if (attr.size <= 65535) {
            attr.size = 16;
        } else if (attr.size <= 2147483647) {
            attr.size = 31;
        } else if (attr.size <= 4294967295) {
            attr.size = 32;
        } else {
            attr.size = 64;
        }

        attr.reverse = attrReverse.toVector();
        attr.type = attrType.toVector();
        attr.divider = attrDivider.toVector();
        attr.valueLookup = attrValueLookup.toVector();
        attr.valueReverse = attrValueReverse.toVector();
    }

    public function get(x : Int, y : Int) : L {
        var pos : Coordinate = this.getLoop(x, y);

        x = pos.x;
        y = pos.y;

        pos = null;

        if (x >= _width || x < 0 || y >= _height || y < 0) {
            return null;
        } else {
            return _locationManager.startWith(_locationAllocator, this, _locations, _discardedLocations, x, y);
        }
    }

    private static function isSprite(o : Any) : Bool {
        #if js
            return cast js.Syntax.code("!!(o.move)");
        #else
            return Std.is(o, SpriteInterface);
        #end
    }

    public function doneWith(o : Usable<L, S>) : Void {
        if (o == null) {
            // Intentionally left blank.
        } else if (isSprite(o)) {
            _spriteManager.doneWith(cast o, _sprites, _discardedSprites);
        } else {
            _locationManager.doneWith(cast o, _locations, _discardedLocations);
        }
    }

    public function doneWithWorkers() : Void {
        if (_pool != null) {
            _pool.dispose();
            _pool = null;
        }
    }

    public function convertToSubfield(parent : FieldInterface<L, S>, startX : Int, startY : Int) : FieldInterface<L, S> {
        doneWithWorkers();
        return new FieldSub<L, S>(parent, startX, startY, _width, _height, _id);
    }

    public function getWrappedField() : FieldInterface<L, S> {
        return this;
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

    public function largeOperation(f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, cleanDivide : Int) : Void {
        if (_memoryBuffer == null || !_isShared || !(com.field.workers.WorkerThread.isSupported())) {
            smallOperation(f, callback, whenDone, data, cleanDivide);
        } else {
            return getWorkerThreadPool().splitWork(com.field.workers.WorkerThread.getProcessors(), f, callback, whenDone, data, cleanDivide);
        }
    }

    private function arrayFillSupported() {
        #if js
            js.Syntax.code("return !!({0}[\"fill\"])", _locationArrayView);
        #elseif php
            return false;
        #end
        return false;
    }

    public function attributeFill(attribute : String, data : Any, callback : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void) : Void {
        if (_defaultAccessor.locationAttributesLookupCount() == 1 && arrayFillSupported()) {
            switch (_defaultAccessor.getLocationType(attribute)) {
                case 0:
                    data = _defaultAccessor.lookupLocationString(attribute, cast data);
                case 1:
                case 2:
                {
                    var f : Float = cast data;
                    data = f * _defaultAccessor.locationAttributesDivider(cast attribute);
                }
            }
            smallOperation(function (local : AccessorInterface) {
                var sliceSize : Int = Math.floor(local.locationMemoryLength() / local.sliceCount());
                var sliceStart : Int = sliceSize * local.slice();
                var memory : Any = local.locationMemory();
                var data : AttributeFillParams = cast local.data();
                #if js
                    js.Syntax.code("{0}.fill({1}, {2}, {3})", memory, data, sliceStart, sliceStart + sliceSize);
                #elseif php
                    // Array fill is not supported on php
                    throw "Not supported";
                #else
                    // TODO
                    throw "Not supported";
                #end
                return null;
            }, null, callback, data, null);
        } else {
            largeOperation(function (local : AccessorInterface) {
                var attributeCount : Int = local.getLocationAttributeCount();
                var sliceSize : Int = Math.floor(local.locationMemoryLength() / local.sliceCount());
                var sliceStart : Int = sliceSize * local.slice();
                var sliceEnd : Int = sliceStart + sliceSize;
                var params : AttributeFillParams = cast local.data();
                var attribute : Int = local.getLocationAttributePosition(params.attribute);
                var data : Int = local.lookupLocationValueDirect(attribute, params.value);
                var memory : Any = local.locationMemory();
                var i : Int = 0;

                while (i < sliceEnd) {
                    local.setLocationIntegerDirect(i, attribute, data);
                    i = local.moveColumn(i, 1);
                }

                return null;
            }, null, callback, new AttributeFillParams(attribute, data), null);
        }
    }

    public function addSubField(f : FieldInterface<L, S>, x : Int, y : Int) : Void {
        var subAccessor : AccessorInterface = f.getDefaultAccessor();
        var mainAccessor : AccessorInterface = getDefaultAccessor();
        var width : Int = subAccessor.getColumns();
        var spriteCount : Int = subAccessor.getSpriteCount();

        if (_subFields == null) {
            _subFields = new NativeArray<FieldInterface<L, S>>();
        }
        _subFields.push(f);

        var set : Null<Any->Any->Int->Void> = null;
        
        #if js
            set = js.Syntax.code("!!({0}[\"set\"])", mainAccessor.locationMemory())
            ? function (m : Any, o : Any, i : Int) {
                js.Syntax.code("{0}.set({1}, {2})", m, o, i);
            } : function (m : Any, o : Any, i : Int) {
                js.Syntax.code("for (var j = 0; j < {1}.length; j++, i++) { {0}[{2}] = {1}[j]; }", m, o, i);
            };
        #elseif php
            set = function (m : Any, o : Any, i : Int) : Void {
                var m1 : NativeVector<Int> = cast m;
                var o1 : NativeVectorSlice<Int> = cast o;
                var j : Int = 0;
                while (j < o1.length()) {
                    m1.set(i, o1.get(j));
                    i++;
                    j++;
                }
            };
        #else
            // TODO
            throw "Not supported";
        #end

        {
            var iMainIndex : Int = mainAccessor.moveColumn(mainAccessor.moveRow(0, y), x);
            var subMemory : Any = subAccessor.locationMemory();
            var subHeight : Int = subAccessor.getRows();
            var mainMemory : Any = mainAccessor.locationMemory();
            var increment : Int = width * mainAccessor.getLocationAttributeCount();
            var getSlice : Null<Int->Int->Dynamic> = null;

            #if js
                js.Syntax.code("{0} = ({1}[\"subarray\"]) ? function (i, j) { return {1}.subarray(i, j); } : function (i, j) { return {1}.slice(i, j); }", getSlice, subMemory);
            #elseif php
                getSlice = function (start : Int, end : Int) : Dynamic {
                    return new NativeVectorSlice<Int>(cast subMemory, start, end);
                };
            #else
                // TODO
            #end

            var i : Int = 0;
            var y : Int = 0;

            while (y < subHeight) {
                var memorySlice : Dynamic = getSlice(i, i + increment);
                set(mainMemory, memorySlice, iMainIndex);
                iMainIndex = mainAccessor.moveRow(iMainIndex, 1);
                i += increment;
                y++;
            }
        }
        if (spriteCount > 0) {
            var emptyIndex : Int = -1;
            var subMemory : Any = subAccessor.spriteMemory();
            var mainMemory : Any = mainAccessor.spriteMemory();
            var spriteCount : Int = mainAccessor.getSpriteCount();
            var attributeCount : Int = mainAccessor.getSpriteAttributeCount();
            var locationIndex : Int = mainAccessor.getSpriteAttributePosition("location");
            var mainWidth : Int = mainAccessor.getColumns();

            if (attributeCount == 1) {
                var arr : NativeArray<Int> = cast mainMemory;
                emptyIndex = arr.indexOf(0);
            } else {
                var i : Int = 0;
                var sprite : Int = 0;
                while (sprite < spriteCount) {
                    if (mainAccessor.getSpriteIntegerDirect(i, locationIndex) == 0) {
                        emptyIndex = i;
                        break;
                    }
                    i = mainAccessor.moveSprite(i, 1);
                    sprite++;
                }
                emptyIndex = i;
            }

            set(mainMemory, subMemory, emptyIndex);

            var iMainIndex : Int = emptyIndex;
            var iSubIndex : Int = 0;
            var subSpriteCount : Int = subAccessor.getSpriteCount();
            var sprite : Int = 0;

            while (sprite < subSpriteCount) {
                var l : Int = subAccessor.getSpriteIntegerDirect(iSubIndex, locationIndex);
                if (l != 0) {
                    l--;
                    var i : Int = l % width + x;
                    var j : Int = Math.floor(l / width) + y;
                    var l2 : Int = j * mainWidth + i;
                    mainAccessor.setSpriteIntegerDirect(iMainIndex, locationIndex, l2 + 1);
                    var atLocation : Null<NativeIntMap<Int>> = _spritesAtLocation.get(l2);
                    if (atLocation == null) {
                        atLocation = new NativeIntMap<Int>();
                        _spritesAtLocation.set(l2, atLocation);
                    }
                    var entry = Math.floor(iMainIndex / attributeCount);
                    atLocation.set(entry, entry);
                }
                iSubIndex = subAccessor.moveSprite(iSubIndex, 1);
                iMainIndex = mainAccessor.moveSprite(iMainIndex, 1);
                sprite++;
            }

            if (_spriteManager.isPermanent()) {
                var i : Int = Math.floor(emptyIndex / attributeCount);
                var j = 0;
                while (j < spriteCount) {
                    var sSprite1 : SpriteInterface<Dynamic, L> = cast getSprite(i);
                    var sSprite2 : SpriteInterface<Dynamic, L> = cast f.getSprite(j);

                    var custom : Iterator<String> = sSprite2.myCustomAttributeKeys();
                    for (k in custom) {
                        sSprite1.attribute(k, sSprite2.attribute(k));
                    }

                    custom = sSprite2.myCustomDataKeys();
                    for (k in custom) {
                        sSprite1.data(k, sSprite2.data(k));
                    }

                    i++;
                    j++;
                }
            }
        }

        var f2 : FieldSystemInterface<L, S> = cast f;
        var subs : Null<NativeArray<FieldInterface<L, S>>> = f2.getSubfields();
        if (subs != null) {
            for (sub in subs) {
                var sub2 : FieldSystemInterface<L, S> = cast sub;
                _subFields.push(sub2.convertToSubfield(this, x + sub.getX(), y + sub.getY()));
            }
        }

        f2.convertToSubfield(this, x, y);
    }

    public function findSprites(x1 : Int, y1 : Int, x2 : Int, y2 : Int) : NativeVector<S> {
        if (_sprites.count() <= 0) {
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
        if (_sprites.count() <= 0) {
            return _emptySpriteVector;
        } else {
            var l2 : LocationInterface<Dynamic, L> = cast l;
            var sSpritesFound : Null<NativeIntMap<Int>> = _spritesAtLocation.get(l2.getI());
            if (sSpritesFound != null) {
                var sFound : NativeArray<S> = new NativeArray<S>();
                var iterator : Iterator<Int> = cast sSpritesFound.keys();
                var j = 0;

                for (i in iterator)
                {
                    sFound.set(j, _spriteManager.startWith(_spriteAllocator, this, _sprites, _discardedSprites, i, 0));
                    j++;
                }

                return sFound.toVector();
            } else {
                return _emptySpriteVector;
            }
        }
    }

    public function findSpritesForLocations(l : NativeArray<L>) : NativeVector<S> {
        if (_sprites.count() <= 0) {
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

    public function findLocationForSpriteIndex(i : Int) : L {
        var s : S = getSprite(i);
        var l : L = findLocationForSprite(s);
        doneWith(cast s);
        return l;
    }

    public function getSubfieldsForLocation(l : L) : NativeVector<FieldInterface<L, S>> {
        if (_subFields == null) {
            return null;
        } else {
            var l2 : LocationInterface<Dynamic, L> = cast l;
            var f : NativeArray<FieldInterface<L, S>> = new NativeArray<FieldInterface<L, S>>();
            var x : Int = l2.getX(this);
            var y : Int = l2.getY(this);

            var j : Int = 0;

            while (j < _subFields.length()) {
                var subField = _subFields.get(j);
                if (x >= subField.getX() && y >= subField.getY() && x < (subField.getX() + subField.width()) && y < (subField.getY() + subField.height())) {
                    f.push(subField);
                }
                j++;
            }

            // Order based on size
            f.sort(function (a, b) {
                var sizeA = a.width() * a.height();
                var sizeB = b.width() * b.height();

                return sizeA - sizeB;
            });

            return f.toVector();
        }
    }

    public function getSubfieldForLocation(l : L, ?i : Int = 0) : FieldInterface<L, S> {
        return getSubfieldsForLocation(l).get(i);
    }

    public function getSubfieldsForSprite(s : S) : NativeVector<FieldInterface<L, S>> {
        var l : L = findLocationForSprite(s);
        if (l == null) {
            return null;
        } else {
            var l2 : LocationInterface<Dynamic, L> = cast l;
            var f : NativeVector<FieldInterface<L, S>> = getSubfieldsForLocation(l);
            l2.doneWith();
            return f;
        }
    }

    public function getSubfieldForSprite(s : S, ?i : Int = 0) : FieldInterface<L, S> {
        var a = getSubfieldsForSprite(s);
        if (a == null) {
            return null;
        } else {
            return a.get(i);
        }
    }

    public function getSubfields() : Null<NativeArray<FieldInterface<L, S>>> {
        return _subFields;
    }

    public function getSpritesAtLocation() : NativeIntMap<NativeIntMap<Int>> {
        return _spritesAtLocation;
    }

    public function refreshSpriteLocations(callback : Void->Void) : Void {
        later(function () {
            var locationIndex : Int = _spriteAttributes.lookup.get("location");
            var j : Int = 0;

            _spritesAtLocation = new NativeIntMap<NativeIntMap<Int>>();

            var i : Int = 0;

            while (i < _maximumNumberOfSprites) {
                var l : Int = _spriteArrayView.get(j);
                if (l != 0) {
                    var l2 : Int = cast (l - 1);
                    var location : Null<NativeIntMap<Int>> = _spritesAtLocation.get(l2);

                    if (location == null) {
                        location = new NativeIntMap<Int>();
                        _spritesAtLocation.set(l2, location);
                    }
                    location.set(i, i);
                }
                i++;
                j += _spriteAttributes.count;
            }

            later(callback);
        });
    }

    public function getSprite(i : Int) {
        return _spriteManager.startWith(_spriteAllocator, this, _sprites, _discardedSprites, i, 0);
    }

    public function getLoop(x : Int, y : Int) : Coordinate {
        return _getLoop(x, y);
    }

    private function getLoopDefault(x : Int, y : Int) : Coordinate {
        return new Coordinate(x, y);
    }

    private function verticalLoop(x : Int, y : Int) : Coordinate {
        return new Coordinate(x, ((y < 0) ? (_height + y) : y) % _height);
    }

    private function horizontalLoop(x : Int, y : Int) : Coordinate {
        return new Coordinate(((x < 0) ? (_width + x) : x) % _width, y);
    }

    private function horizontalVerticalLoop(x : Int, y : Int) : Coordinate {
        return new Coordinate(((x < 0) ? (_width + x) : x) % _width, ((y < 0) ? (_height + y) : y) % _height);
    }

    public function loopReset(x : Int, y : Int) : Bool {
        return _loopReset(x, y);
    }

    private function loopResetDefault(x : Int, y : Int) : Bool {
        return false;
    }

    private function loopResetWhenDoubled(x : Int, y : Int) : Bool {
        return Math.abs(x / _width) >= 2 || Math.abs(y / _height) >= 2;
    }

    public function getLocationCalculatedAttributes() : NativeStringMap<L->Any> {
        return _locationCalculatedAttributes;
    }

    public function getSpriteCalculatedAttributes() : NativeStringMap<S->Any> {
        return _spriteCalculatedAttributes;
    }

    public function id() : String {
        return _id;
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

    public function toString() : String {
        // TODO - REWRITE
        return "";
    }

    public function getDefaultAccessor() : AccessorInterface {
        return _defaultAccessor;
    }

    private function runOperations() : Void {
        var whenDones : NativeArray<Void->Void> = new NativeArray<Void->Void>();
        var myOperations : NativeArray<AccessorInterface->Any> = _scheduledOperations;
        var myOptions : NativeArray<ScheduleOperationOptions<Dynamic>> = _scheduledOptions;

        _scheduledOperations = new NativeArray<AccessorInterface->Any>();
        _scheduledOptions = new NativeArray<ScheduleOperationOptions<Dynamic>>();

        if (myOperations.length() <= 1) {
            var i : Int = 0;
            while (i < myOperations.length()) {
                var operation : AccessorInterface->Any = myOperations.get(0);
                myOperations.set(i, null);
                var options : ScheduleOperationOptions<Dynamic> = myOptions.get(0);
                myOptions.set(i, null);
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
                callback(operation(accessor), null, 1, 0);
                accessor.clearData();
                if (whenDone != null) {
                    if (whenDones.indexOf(whenDone) < 0) {
                        whenDones.push(whenDone);
                    }
                }
                i++;
            }
        } else {
            // Run in parallel
            var fields : NativeArray<FieldInterface<Dynamic, Dynamic>> = new NativeArray<FieldInterface<Dynamic, Dynamic>>();
            var operations : NativeArray<AccessorInterface->Any> = new NativeArray<AccessorInterface->Any>();
            var options : NativeArray<NativeStringMap<Any>> = new NativeArray<NativeStringMap<Any>>();

            var i : Int = 0;
            while (i < myOperations.length()) {
                var operation : AccessorInterface->Any = myOperations.get(i);
                //myOperations.set(i, null);
                var options : ScheduleOperationOptions<Dynamic> = myOptions.get(i);
                //myOptions.set(i, null);
                var o : NativeStringMap<Any> = options.toMap();
                options = null;
                var whenDone : Void->Void = cast o.get("whenDone");
                o.set("whenDone", null);
                var field : FieldInterface<Dynamic, Dynamic> = cast o.get("field");
                if (whenDone != null) {
                    if (whenDones.indexOf(whenDone) < 0) {
                        whenDones.push(whenDone);
                    }
                }
                if (fields.indexOf(field) < 0) {
                    fields.push(field);
                }
				if (operations.indexOf(operation) < 0) {
					operations.push(operation);
				}
                i++;
            }

            i = 0;
            while (i < fields.length()) {
                var field : FieldInterface<Dynamic, Dynamic> = fields.get(i);
                var j : Int = 0;
                while (j < operations.length()) {
                    var operation : AccessorInterface->Any = operations.get(j);
                    var callbacks : NativeStringMap<NativeArray<Any->Any->Int->Int->Void>> = new NativeStringMap<NativeArray<Any->Any->Int->Int->Void>>();
                    var data : NativeArray<NativeStringMap<Any>> = new NativeArray<NativeStringMap<Any>>();

                    var k : Int = 0;
                    while (k < myOperations.length()) {
                        var o2 : NativeStringMap<Any> = myOptions.get(k).toMap();
                        if (field.equals(cast o2.get("field")) && operation == myOperations.get(k)) {
                            o2.set("field", null);
                            o2.set("whenDone", null);
                            var id : String = cast o2.get("id");
                            var set : Null<NativeArray<Any->Any->Int->Int->Void>> = callbacks.get(id);
                            if (set == null) {
                                set = new NativeArray<Any->Any->Int->Int->Void>();
                                callbacks.set(id, set);
                            }
                            set.push(cast o2.get("callback"));
                            o2.set("callback", null);
                            if (set.length() <= 1) {
                                data.push(o2);
                            }
                        }
                        k++;
                    }

                    if (data.length() > 0) {
                        field.advanced().largeOperation(operation, function (result : Any, err : Any, i : Int, processors : Int) {
                            var resultData : NativeArray<NativeStringMap<Any>> = cast result;
							var sliceSize : Float = data.length() / processors;
							var baseIndex : Int = Math.floor(sliceSize * i);
                            var sliceEnd : Int = Math.floor(baseIndex + sliceSize);

                            var k : Int = 0;
                            while (k < resultData.length()) {
                                var id : String = cast data.get(k + baseIndex).get("id");
                                var set : Null<NativeArray<Any->Any->Int->Int->Void>> = callbacks.get(id);
                                var l : Int = 0;
                                while (l < set.length()) {
                                    set.get(l)(resultData.get(k), err, i, processors);
                                    l++;
                                }
                                k++;
                            }
                        }, null, data, data.length());
                    }

                    j++;
                }
                i++;
            }
        }

        {
            var i : Int = 0;
            while (i < whenDones.length()) {
                later(whenDones.get(i++));
            }
        }
    }

    public function scheduleOperation(f : AccessorInterface->Any, options : ScheduleOperationOptions<Dynamic>) : Void {
        if (_scheduledOperations == null) {
            _scheduledOperations = new NativeArray<AccessorInterface->Any>();
            _scheduledOptions = new NativeArray<ScheduleOperationOptions<Dynamic>>();
        }
        if (_scheduledOperations.length() <= 0) {
            later(runOperations);
        }
        _scheduledOperations.push(f);
        _scheduledOptions.push(options);
    }

    private function getWorkerThreadPool() : com.field.workers.WorkerThreadPoolInterface {
        if (_pool == null) {
            // TODO
            /*
            if (_sharedPool == null) {
                _sharedPool = new com.field.workers.WorkerThreadPool(null);
            }
            var defaultAccessor : AccessorFlatArrays = cast _defaultAccessor;
            _pool = new com.field.workers.WorkerThreadPoolWrapper(_sharedPool, defaultAccessor._data);
            */
            var defaultAccessor : AccessorFlatArrays = cast _defaultAccessor;
            _pool = new com.field.workers.WorkerThreadPool(defaultAccessor._data);
        }
        return _pool;
    }

    public function registerClass(n : String) : Void {
        #if js
            if (_memoryBuffer != null && com.field.workers.WorkerThread.isSupported()) {
                getWorkerThreadPool().registerObjectToGlobal(n);
            }
        #elseif php
            // Intentionally left empty, should be unnecessary
        #end
        /*
        js.Syntax.code("
        {0}({1}, {2}.toString());
        {0}({1} + \".__name__\", {2}.__name__);
        var proto = {2}.prototype;
        var send = \"{\\n\";
        for (var k in proto) {
            send += k + \": \" + proto[k].toString() + \",\\n\";
        }
        send += \"\\n}\";
        {0}({1} + \".prototype\", send);
        if (!!({2}.wrap)) {
            {0}({1} + \".wrap\", {2}.wrap.toString());
        }
        if (!!({2}.__super__)) {
            {0}({1} + \".__super__\", {2}.__super__.toString());
        }
        if ({2}.PREDEFINED != undefined) {
            {0}({1} + \".PREDEFINED\", {2}.PREDEFINED);
        }
        if ({2}.RAW != undefined) {
            {0}({1} + \".RAW\", {2}.RAW);
        }
        if ({2}.FLOAT != undefined) {
            {0}({1} + \".FLOAT\", {2}.FLOAT);
        }
        if ({2}.CALCULATED != undefined) {
            {0}({1} + \".CALCULATED\", {2}.CALCULATED);
        }
    ", setWorkerExport, n, c, convertObject);

        getWorkerThreadPool().addToCacheIfNotFound(f);
        */
    }

    public function getMaximumNumberOfSprites() : Int {
        return _maximumNumberOfSprites;
    }

    public function getLocationMemory() : NativeVector<Int> {
        return _locationArrayView;
    }

    public function getSpriteMemory() : NativeVector<Int> {
        return _spriteArrayView;
    }

    public function getLocationAttributeCount() : Int {
        return _locationAttributes.count;
    }

    public function getSpriteAttributeCount() : Int {
        return _spriteAttributes.count;
    }  

    public function registerFunction(n : String) : Void {
        _pool.registerObjectToGlobal(n);
    }

    public function advanced() : FieldAdvancedInterface {
        return cast this;
    }

    public function setRefresh(refresh : Dynamic->Void) : Void {
        _refresh = refresh;
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

    #if !EXCLUDE_RENDERING
    public function hasListeners(e : Event) : Bool {
        var listeners : Null<NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void>> = _listeners.get(e);
        return listeners != null && listeners.length() > 0;
    }
    #end

    public function field() : FieldInterface<L, S> {
        return this;
    }

    public function equals(f : FieldInterface<L, S>) : Bool {
        return this == f.field();
    }

    private static function toB64(buf : NativeVector<Int>, offset : Int, length : Int, compress : Bool, callback : String->Void) : Void {
        #if js
            var view : Dynamic = cast js.Syntax.code("(new Uint8Array({0}, {1}, {2}))", buf, offset, length);
            if (compress) {
                var blob : Dynamic = js.Syntax.code("new Blob({0}, {type: 'octet/stream'})", view);
                var blobWriter : Dynamic = js.Syntax.code("new zip.BlobWriter('application/zip')");
                js.Syntax.code("zip.createWriter({0}, {1}, {2})", blobWriter, function (writer : Any) {
                    js.Syntax.code("{0}.add('data', new zip.BlobReader({1}), {2})", writer, blob, function () {
                        js.Syntax.code("{0}.close({1})", writer, function (b : Any) {
                            js.Syntax.code("{0}.arrayBuffer().then({1})", b, function (b) {
                                callback(js.Syntax.code("base64.bytesToBase64({0})", b));
                            });
                        });
                    });
                }, function (e : Dynamic) {
                    // TODO
                    js.Syntax.code("console.log({0})", e);
                });
            } else {
                callback(js.Syntax.code("base64.bytesToBase64({0})", view));
            }
        #elseif php
            // TODO - PHP
        #else
            // TODO
        #end
    }

    private static function fromB64(buf : NativeVector<Int>, offset : Int, length : Int, data : Null<String>) : Void {
        if (data != null) {
            #if js
                var view : Dynamic = cast js.Syntax.code("(new Uint8Array({0}, {1}, {2}))", buf, offset, length);
                var decoded : Dynamic = cast js.Syntax.code("base64.base64ToBytes({0})", data);
                js.Syntax.code("{0}.set({1}, 0)", view, decoded);
            #elseif php
                // TODO - PHP                
            #else
                // TODO
            #end
        }
    }

    public function newBlank() : FieldAbstract<L,S> {
        return null;
    }

    public function fromJSON(options : FromJSONOptions) : Void {
        var fo : NativeStringMap<Any> = options.toMap();
        var str : String  = cast fo.get("data");

        #if js
            var data : NativeStringMap<Any> = cast haxe.Json.parse(str);
            str = null;
            var compressed : Null<String> = cast data.get("compressed");
            if (compressed != null) {
                var blobReader : Dynamic = js.Syntax.code("new zip.BlobReader(new Blob(base64.base64ToBytes({0}), {type: 'octet/stream'}))", compressed);
                js.Syntax.code("zip.createReader({0}, {1}, {2})", blobReader, function (reader : Any) {
                    js.Syntax.code("{0}.getEntries({1})", reader, function (entries : Dynamic) {
                        if (entries.length) {
                            js.Syntax.code("{0}[0].getData(new zip.TextWriter(), {1})", entries, function (s : String) {
                                js.Syntax.code("{0}.close({1})", reader, function () {
                                    options.data(s);
                                    fo = null;
                                    fromJSON(options);
                                });
                            });
                        }
                    });
                }, function (e : Dynamic) {
                    // TODO
                    js.Syntax.code("console.log({0})", e);
                });
            } else {
                var field : FieldAbstract<L, S>;
                var generateNew : Bool = fo.get("generateNew");
                if (generateNew == null) {
                    generateNew = false;
                }
                if (generateNew) {
                    field = this.newBlank();
                } else {
                    field = this;
                }
                options = null;

                var callback : Null<Void->Void> = cast fo.get("callback");
                var callbackWithField : Null<FieldInterface<Dynamic,Dynamic>->Void> = cast fo.get("callbackWithField");
                var callbackWithData : Null<FieldInterface<Dynamic,Dynamic>->NativeVector<LocationInterface<Dynamic,Dynamic>>->NativeVector<SpriteInterface<Dynamic,Dynamic>>->NativeVector<FieldInterface<Dynamic,Dynamic>>->Void> = cast fo.get("callbackWithData");
                var locationVisitor : Null<LocationInterface<Dynamic, Dynamic>->Void> = cast fo.get("locationVisitor");
                var spriteVisitor : Null<SpriteInterface<Dynamic, Dynamic>->Void> = cast fo.get("spriteVisitor");
                var subfieldVisitor : Null<FieldInterface<Dynamic, Dynamic>->Void> = cast fo.get("subfieldVisitor");

                var modifiedSprites : Null<NativeArray<SpriteInterface<Dynamic,Dynamic>>> = null;
                var modifiedLocations : Null<NativeArray<LocationInterface<Dynamic,Dynamic>>> = null;
                var modifiedFields : Null<NativeArray<FieldInterface<Dynamic,Dynamic>>> = null;

                if (callbackWithData != null) {
                    modifiedSprites = new NativeArray<SpriteInterface<Dynamic,Dynamic>>();
                    modifiedLocations = new NativeArray<LocationInterface<Dynamic,Dynamic>>();
                    modifiedFields = new NativeArray<FieldInterface<Dynamic,Dynamic>>();
                }

                var accessor : AccessorFlatArrays = cast field._defaultAccessor;
                var locationSize : Int = accessor._data.locationSize * accessor._data.width * accessor._data.height * accessor._data.locationAttributes.count;
        
                // Import raw data
                fromB64(field._memoryBuffer, 0, locationSize, data.get("locationArrayView"));
                fromB64(field._memoryBuffer, locationSize, accessor._data.maximumNumberOfSprites * accessor._data.spriteSize * accessor._data.spriteAttributes.count, data.get("spriteArrayView"));

                // Import misc field info
                if (data.get("id") != null) {
                    field._id = cast data.get("id");
                }
                if (data.get("locationClass") != null) {
                    field._locationClass = cast data.get("locationClass");
                }

                if (data.get("spriteClass") != null) {
                    field._spriteClass = cast data.get("spriteClass");
                }                

                // Import Custom Data
                var locations : Null<NativeIntMap<NativeIntMap<NativeStringMap<NativeStringMap<Any>>>>> = data.get("locations");
                var sprites : Null<NativeIntMap<NativeStringMap<NativeStringMap<Any>>>> = data.get("sprites");
                if (locations != null) {
                    var keysJ : Iterator<Int> = locations.keys();
                    for (j in keysJ) {
                        var row : Null<NativeIntMap<Any>> = locations.get(j);
                        if (row != null) {
                            var keysI : Iterator<Int> = row.keys();
                            for (i in keysI) {
                                var ld : NativeStringMap<NativeStringMap<Any>> = row.get(i);
                                if (ld != null) {
                                    var attributes : NativeStringMap<Any> = ld.get("attributes");
                                    var data : NativeStringMap<Any> = ld.get("data");
                                    if (attributes != null || data != null) {
                                        var l : LocationInterface<Dynamic, L> = cast field.get(i, j);
                                        if (attributes != null) {
                                            var keys : Iterator<String> = attributes.keys();
                                            for (k in keys) {
                                                l.attribute(k, attributes.get(k));
                                            }
                                        }
                                        if (data != null) {
                                            var keys : Iterator<String> = data.keys();
                                            for (k in keys) {
                                                l.data(k, data.get(k));
                                            }
                                        }
                                        if (modifiedLocations != null) {
                                            modifiedLocations.push(l);
                                        }
                                        if (locationVisitor != null) {
                                            locationVisitor(l);
                                        }
                                        l.doneWith();
                                    }
                                }
                            }
                        }
                    }
                }

                if (sprites != null) {
                    var keysI : Iterator<Int> = sprites.keys();
                    for (i in keysI) {
                        var ld : NativeStringMap<NativeStringMap<Any>> = sprites.get(i);
                        if (ld != null) {
                            var attributes : NativeStringMap<Any> = ld.get("attributes");
                            var data : NativeStringMap<Any> = ld.get("data");
                            if (attributes != null || data != null) {
                                var l : SpriteInterface<Dynamic, S> = cast field.getSprite(i);
                                if (attributes != null) {
                                    var keys : Iterator<String> = attributes.keys();
                                    for (k in keys) {
                                        l.attribute(k, attributes.get(k));
                                    }
                                }
                                if (data != null) {
                                    var keys : Iterator<String> = data.keys();
                                    for (k in keys) {
                                        l.data(k, data.get(k));
                                    }
                                }                                        
                                if (modifiedSprites != null) {
                                    modifiedSprites.push(l);
                                }
                                if (spriteVisitor != null) {
                                    spriteVisitor(l);
                                }

                                l.doneWith();
                            }
                        }
                    }
                }

                // Subfields
                var subFields : Null<NativeObjectMap<NativeStringMap<Any>>> = data.get("subfields");
                if (subFields != null) {
                    var keys : Iterator<Any> = subFields.keys();
                    for (id in keys) {
                        var obj : NativeStringMap<Any> = cast subFields.get(id);
                        var subfield : FieldInterface<L, S> = field.createSubField(id, cast obj.get("x"), cast obj.get("y"), cast obj.get("width"), cast obj.get("height"));
                        if (modifiedFields != null) {
                            modifiedFields.push(subfield);
                        }
                        if (subfieldVisitor != null) {
                            subfieldVisitor(subfield);
                        }
                    }
                }

                // Completed
                if (callbackWithData != null) {
                    callbackWithData(field, modifiedLocations.toVector(), modifiedSprites.toVector(), modifiedFields.toVector());
                }
                if (callbackWithField != null) {
                    callbackWithField(field);
                }                
                if (callback != null) {
                    callback();
                }
            }
        #elseif php
            // TODO - PHP
        #else
            // TODO
        #end
    }

    public function fromJSONOptions() : FromJSONOptions {
        return new FromJSONOptions(this);
    }

    public function toJSON(options : ToJSONOptions) : Void {
        var fo : NativeStringMap<Any> = options.toMap();
        options = null;
        var callback : String->Void = cast fo.get("callback");
        var spriteArray : Bool = cast fo.get("spriteArray");
        var locationArray : Bool = cast fo.get("locationArray");
        var compressSpriteArray : Bool = cast fo.get("compressSpriteArray");
        var compressLocationArray : Bool = cast fo.get("compressLocationArray");
        var compressJSON : Bool = cast fo.get("compressJSON");
        var miscInfo : Bool = cast fo.get("miscInfo");
        var sizeInfo : Bool = cast fo.get("sizeInfo");
        var subFields : Bool = cast fo.get("subFields");
        var attributes : Bool = cast fo.get("attributes");
        var customData : Bool = cast fo.get("customData");
        fo = null;

        if (spriteArray == null) {
            spriteArray = true;
        }

        if (locationArray == null) {
            locationArray = true;
        }
/*
        if (compressSpriteArray == null) {
            compressSpriteArray = true;
        }

        if (compressLocationArray == null) {
            compressLocationArray = true;
        }        */

        if (compressJSON == null) {
            compressJSON = true;
        }
        
        var data : NativeStringMap<Any> = new NativeStringMap<Any>();
        var accessor : AccessorFlatArrays = cast _defaultAccessor;
        var locationSize : Int = accessor._data.locationSize * accessor._data.width * accessor._data.height * accessor._data.locationAttributes.count;

        var wuUntil : WaitUntil = new WaitUntil(function () {
            var s : String = haxe.Json.stringify(data);
            if (compressJSON) {
                #if js
                    var blobWriter : Dynamic = js.Syntax.code("new zip.BlobWriter('application/zip')");                
                    js.Syntax.code("zip.createWriter({0}, {1}, {2})", blobWriter, function (writer : Any) {
                        js.Syntax.code("writer.add('data', new zip.TextReader({0}), {1})", s, function () {
                            js.Syntax.code("writer.close({0})", function (b : Any) {
                                js.Syntax.code("{0}.arrayBuffer().then({1})", b, function (b) {
                                    var s : String = cast js.Syntax.code("base64.bytesToBase64(new Uint8Array({0}))", b);
                                    b = null;
                                    s = "{ \"compressed\": \"" + s + "\" }";
                                    callback(s);
                                });
                            });
                        });
                    }, function (e : Dynamic) {
                        js.Syntax.code("console.log({0})", e);
                    });
                #elseif php
                    var tmp : Dynamic = php.Syntax.code("tempname(sys_get_temp_dir(), \"FE-ZIP-\")");
                    var zipWriter : Dynamic = php.Syntax.code("new ZipArchive()");
                    php.Syntax.code("{0}->open({1}, ZIPARCHIVE::CREATE)", zipWriter, tmp);
                    php.Syntax.code("{0}->addFromString({1})", zipWriter, s);
                    php.Syntax.code("{0}->close()", zipWriter);
                    s = cast php.Syntax.code("base64_encode(file_get_contents({0}))", tmp);
                    php.Syntax.code("unlink({0})", tmp);
                    s = "{ \"compressed\": \"" + s + "\" }";
                    callback(s);
                    s = null;
                #end
            } else {
                callback(s);
            }
        });

        wuUntil.wait();

        // Export raw data
        if (locationArray) {
            wuUntil.wait();
            toB64(_memoryBuffer, 0, locationSize, compressLocationArray, function (s) {
                data.set("locationArrayView", s);
                wuUntil.done();
            });
        }
        if (spriteArray) {
            wuUntil.wait();
            toB64(_memoryBuffer, locationSize, accessor._data.maximumNumberOfSprites * accessor._data.spriteSize * accessor._data.spriteAttributes.count, compressSpriteArray, function (s) {
                data.set("spriteArrayView", s);
                wuUntil.done();
            });
        }
        
        // Export custom/dynamic data
        if (customData) {
            wuUntil.wait();

            var locations : Null<NativeIntMap<NativeIntMap<Any>>> = null;
            var sprites : Null<NativeIntMap<Any>> = null;
    
            _locations.forEach(cast function (x : Int, y : Int, l : LocationInterface<Dynamic, L>) {
                var obj : Null<NativeStringMap<Any>> = null;
                var attributes : Null<NativeStringMap<Any>> = null;
                var data : Null<NativeStringMap<Any>> = null;
    
                for (k in l.myCustomAttributeKeys()) {
                    if (attributes == null) {
                        attributes = new NativeStringMap<Any>();
                    }
                    attributes.set(k, l.attribute(k));
                }
                for (k in l.myCustomDataKeys()) {
                    if (data == null) {
                        data = new NativeStringMap<Any>();
                    }
                    data.set(k, l.data(k));
                }
    
                if (attributes != null) {
                    if (obj == null) {
                        obj = new NativeStringMap<Any>();
                    }
                    obj.set("attributes", attributes);
                }
    
                if (data != null) {
                    if (obj == null) {
                        obj = new NativeStringMap<Any>();
                    }
                    obj.set("data", data);
                }
    
                if (obj != null) {
                    if (locations == null) {
                        locations = new NativeIntMap<NativeIntMap<Any>>();
                    }
                    var row : Null<NativeIntMap<Any>> = locations.get(y);
                    if (row == null) {
                        row = new NativeIntMap<Any>();
                        locations.set(y, row);
                    }
                    row.set(x, obj);
                }
            });
            _sprites.forEach(cast function (x : Int, y : Int, s : SpriteInterface<Dynamic, S>) {
                var obj : Null<NativeStringMap<Any>> = null;
                var attributes : Null<NativeStringMap<Any>> = null;
                var data : Null<NativeStringMap<Any>> = null;
    
                for (k in s.myCustomAttributeKeys()) {
                    if (attributes == null) {
                        attributes = new NativeStringMap<Any>();
                    }
                    attributes.set(k, s.attribute(k));
                }
                for (k in s.myCustomDataKeys()) {
                    if (data == null) {
                        data = new NativeStringMap<Any>();
                    }
                    data.set(k, s.data(k));
                }
    
                if (attributes != null) {
                    if (obj == null) {
                        obj = new NativeStringMap<Any>();
                    }
                    obj.set("attributes", attributes);
                }
    
                if (data != null) {
                    if (obj == null) {
                        obj = new NativeStringMap<Any>();
                    }
                    obj.set("data", data);
                }
    
                if (obj != null) {
                    if (sprites == null) {
                        sprites = new NativeIntMap<Any>();
                    }
                    sprites.set(x, obj);
                }
            });
    
            if (locations != null) {
                data.set("locations", locations);
            }
    
            if (sprites != null) {
                data.set("sprites", sprites);
            }
            wuUntil.done();
        }


        // Export misc field info
        if (miscInfo) {
            wuUntil.wait();
            data.set("id", _id);
            data.set("locationClass", _locationClass);
            data.set("spriteClass", _spriteClass);
            wuUntil.done();
        }

        // Export size info
        if (sizeInfo) {
            wuUntil.wait();
            data.set("width", _width);
            data.set("height", _height);
            data.set("maximumNumberOfSprites", _maximumNumberOfSprites);
            wuUntil.done();
        }

        // Export attribute structures
        if (attributes) {
            wuUntil.wait();
            data.set("locationPredefinedAttributes", _locationPredefinedAttributes);
            data.set("spritePredefinedAttributes", _spritePredefinedAttributes);
            data.set("locationNumericalAttributes", _locationNumericalAttributes);
            wuUntil.done();
        }

        // Export subfields
        if (subFields && _subFields != null) {
            wuUntil.wait();
            var fields : Null<NativeObjectMap<NativeStringMap<Any>>> = null;            
            var i : Int = 0;
            while (i < _subFields.length()) {
                if (fields == null) {
                    fields = new NativeObjectMap<NativeStringMap<Any>>();
                }
                var obj : NativeStringMap<Any> = new NativeStringMap<Any>();
                var sub : FieldInterface<L,S> = cast _subFields.get(i);
                obj.set("width", sub.width());
                obj.set("height", sub.height());
                obj.set("x", sub.getX());
                obj.set("y", sub.getY());
                fields.set(sub.id(), obj);
                i++;
            }
            if (fields != null) {
                data.set("subfields", fields);
            }
            wuUntil.done();
        }

        wuUntil.done();
    }

    public function toJSONOptions() : ToJSONOptions {
        return new ToJSONOptions(this);
    }

    public function createSubField(id : String, x : Int, y : Int, width : Int, height : Int) : FieldInterface<L, S> {
        return new FieldSub<L, S>(this, x, y, width, height, id);
    }

    public function getParentField() : FieldInterface<L, S> {
        return this;
    }

    private var _navigator : NavigatorCoreInterface;

    public function navigator() : NavigatorCoreInterface {
        return _navigator;
    }

    public function lastMajorChange() : Dynamic {
        return null;
    }
}

@:nativeGen
class AttributeFillParams {
    public inline function new(attribute : String, value : Any) {
        this.attribute = attribute;
        this.value = value;
    }

    public var attribute : String;
    public var value : Any;
}