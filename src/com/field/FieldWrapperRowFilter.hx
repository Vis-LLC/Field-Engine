
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
import com.field.manager.Pool;

@:nativeGen
@:expose
/**
    A Decorator that changes a Field so that rows are filtered based on the specified criteria.
**/
class FieldWrapperRowFilter<L, S> extends FieldWrapper<L, S> {
    private var _filters : NativeVector<FieldWrapperRowFilterStep>;
    private var _passThroughLocations : Bool;

    private var _locationManager : com.field.manager.Manager<LocationDerived, LocationDerived, Dynamic>;
    private var _locationAllocator : com.field.manager.Allocator<LocationDerived>;
    private var _discardedLocations : Pool<LocationDerived>;
    private var _locations : Pool<LocationDerived>;

    private var _resultingRows : NativeVector<Int>;
    private var _resultingMapping : NativeIntMap<Int>;

    private var _previousWrappedFieldHeight : Int = -1;
    private var _lastMajorChange : Dynamic;
    
    /**
        Creates a FieldWrapperRowFilter based on the options.
    **/
    public static function create(options : FieldWrapperRowFilterOptions<Dynamic, Dynamic>) : FieldWrapperRowFilter<Dynamic, Dynamic>  {
        return new FieldWrapperRowFilter<Dynamic, Dynamic>(options);
    }

    /**
        Allows for the setting of options for the FieldWrapperRowFilter class.
    **/
    public static function options() : FieldWrapperRowFilterOptions<Dynamic, Dynamic> {
        return new FieldWrapperRowFilterOptions<Dynamic, Dynamic>();
    }

    private static function getField(options : FieldWrapperRowFilterOptions<Dynamic, Dynamic>) : FieldInterface<Dynamic, Dynamic> {
        var fo : NativeStringMap<Any> = options.toMap();
        return cast fo.get("field");
    }    

    private function new(options : FieldWrapperRowFilterOptions<L, S>) {
        super(cast getField(options));
        var fo : NativeStringMap<Any> = options.toMap();
        options = null;
        var i : Int = 0;

        _passThroughLocations = cast fo.get("passThroughLocations");
        if (_passThroughLocations == null) {
            _passThroughLocations = true;
        }

        var filters : NativeArray<FieldWrapperRowFilterStep> = new NativeArray<FieldWrapperRowFilterStep>();
        var nextColumn : Null<Int> = fo.get("filterOnColumn" + i);
        var nextColumnValue : Null<Dynamic> = fo.get("filterOnColumnValue" + i);
        var nextColumnAllow : Null<Bool> = fo.get("filterOnColumnAllow" + i);
        var nextColumnAttr : Null<String> = fo.get("filterOnColumnAttr" + i);

        while (nextColumn != null) {
            var step : FieldWrapperRowFilterStep = new FieldWrapperRowFilterStep();
            filters.push(step);
            step.allow = nextColumnAllow;
            step.column = nextColumn;
            step.value = nextColumnAllow;
            step.attr = nextColumnAttr;
            i++;
            nextColumn = fo.get("filterOnColumn" + i);
            nextColumnValue = fo.get("filterOnColumnValue" + i);
            nextColumnAllow = fo.get("filterOnColumnAllow" + i);
            nextColumnAttr = fo.get("filterOnColumnAttr" + i);
        }

        _filters = filters.toVector();

        refresh(null);
    }

    private function setupAllocatorAndManager() : Void {
        if (_passThroughLocations == false) {
            // TODO - _locationManager option
            if (_locationManager == null) {
                _locationManager = new com.field.manager.TransientReuse<LocationDerived, FieldWrapperAttributesToColumns<L,S>, LocationDerived, Dynamic>();
            }
            _locationAllocator = LocationDerived.getAllocator();
            _locations = _locationManager.preallocate(_locationAllocator, cast this, _field.width(), _field.height());
            _discardedLocations = _locationManager.allocateDiscard(_locationAllocator);
        }
    }

    public override function refresh(callback : Void->Void) : Void {
        _field.refresh(function () {
            if (_previousWrappedFieldHeight == -1 || _previousWrappedFieldHeight != _field.height()) {
                setupAllocatorAndManager();
            }

            var resultingRows : NativeArray<Int> = new NativeArray<Int>();
            var resultingMapping : NativeIntMap<Int> = new NativeIntMap<Int>();
            var j : Int = 0;
            var height : Int = _field.height();

            while (j < height) {
                var i : Int = 0;
                var hadAllow : Bool = false;
                var hadBlock : Bool = false;
                var allow : Bool = false;
                var block : Bool = false;
                while (i < _filters.length()) {
                    var step : FieldWrapperRowFilterStep = _filters.get(i);
                    var match : Bool;
                    var l : L = _field.get(step.column, j);
                    var value : Dynamic;

                    if (step.attr == null) {
                        var l2 : LocationTextValue = cast l;
                        value = l2.value();
                        l2.doneWith();
                    } else {
                        var l2 : LocationInterface<L, S> = cast l;
                        value = l2.attribute(step.attr);
                        l2.doneWith();
                    }
                    
                    match = (step.value == value);
                    
                    if (step.allow) {
                        if (match) {
                            allow = true;
                        }
                        hadAllow = true;
                    } else {
                        if (match) {
                            block = true;
                        }
                        hadBlock = true;
                    }
                    i++;
                }

                if (block) {
                    // Do not add - Intentionally left blank
                } else if (allow) {
                    resultingMapping.set(resultingRows.length(), j);
                    resultingRows.push(j);
                } else if (hadAllow) {
                    // Do not add - Intentionally left blank
                } else if (hadBlock) {
                    resultingMapping.set(resultingRows.length(), j);
                    resultingRows.push(j);
                }

                j++;
            }
            
            _resultingRows = resultingRows.toVector();
            _resultingMapping = resultingMapping;
            _lastMajorChange = Date.now().getTime();

            if (callback != null) {
                callback();
            }
        });
    }

    public override function height() : Int {
        return _resultingRows.length();
    }


    public override function get(x : Int, y : Int) : L {
        if (_passThroughLocations) {
            return _field.get(x, _resultingRows.get(y));
        } else {
            // TODO
            return null;
        }
    }

    public override function transformY(x : Float, y : Float) : Float {
        var y2 : Int = Math.floor(y);
        return _resultingMapping.get(y2) + y - y2;
    }

    // TODO
    // getLoop

}

@:nativeGen
/**
    Specifies one of the conditions for filtering the rows of a Field.
**/
class FieldWrapperRowFilterStep {
    /**
        Allow the matched row or block it.
    **/
    public var allow : Bool;

    /**
        The column to match.
    **/
    public var column : Int;

    /**
        The attribute to check.
    **/
    public var attr : Null<String>;

    /**
        The value to match.
    **/
    public var value : Dynamic;

    public inline function new() { }
}